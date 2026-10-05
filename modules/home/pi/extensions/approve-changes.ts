/**
 * Approve Changes Extension
 *
 * Requires explicit user approval before tool execution proceeds
 * (except `read` and whitelisted bash commands).
 *
 * Pi's built-in diff rendering handles the preview — this extension
 * only adds the approve/reject gate.
 */

import { stripVTControlCharacters } from "node:util";
import type { ExtensionAPI } from "@mariozechner/pi-coding-agent";
import { isToolCallEventType } from "@mariozechner/pi-coding-agent";

// Quote-aware argv parsing (simple single/double quotes; no escapes).
// We keep this local because @earendil-works/pi-agent-core does not export
// internal harness helpers via package exports.
function parseCommandArgs(argsString: string): string[] {
	const args: string[] = [];
	let current = "";
	let inQuote: string | null = null;

	for (let i = 0; i < argsString.length; i++) {
		const char = argsString[i]!;
		if (inQuote) {
			if (char === inQuote) inQuote = null;
			else current += char;
		} else if (char === '"' || char === "'") {
			inQuote = char;
		} else if (char === " " || char === "\t") {
			if (current) {
				args.push(current);
				current = "";
			}
		} else {
			current += char;
		}
	}
	if (current) args.push(current);
	return args;
}

// ─── Bash command whitelist ───────────────────────────────────
//
// Goal: allow a very small, *read-only* subset of bash usage without UI approval.
// We intentionally avoid trying to fully parse shell. If the command contains
// quoting/escapes or shell metacharacters, it is NOT whitelisted.

const BASH_WHITELIST = new Set(["ls", "grep", "find", "fd", "rg"]);

// Metacharacters that are NEVER allowed (even inside pipeline segments).
// Note: pipe '|' is handled separately by splitting into pipeline stages.
// Shell metacharacters that can introduce side effects or unpredictable evaluation.
// Note: parentheses are intentionally NOT included because they are common in regex
// patterns (e.g. rg '\(') and are only special to the shell in specific contexts.
const DANGEROUS_METACHARS = /[\r\n;&{}$`<>]/;
// Quotes are not inherently dangerous, but they require parsing to understand argv.
// Backslashes are still treated as "needs approval" because they can participate in
// line continuations and escape sequences depending on shell context.
const SHELL_QUOTES = /['"]/;
const SHELL_ESCAPES = /[\\]/;

// Commands that are safe to appear on the *right* side of a pipe.
// These are read-only transformers / viewers that cannot cause side effects.
const SAFE_PIPE_TARGETS = new Set([
	"sort", "uniq", "head", "tail", "wc", "cat", "tac",
	"cut", "tr", "rev", "nl", "column", "paste",
	"grep", "awk", "sed",
	"less", "more",
	"xargs",  // NOTE: xargs is validated separately — only safe variants
]);

function tokenizeNoQuotes(input: string): string[] | null {
	// Split on whitespace; no quoting supported by design.
	// Keep this for commands where we want to reject any quoting entirely.
	if (SHELL_QUOTES.test(input)) return null;
	if (SHELL_ESCAPES.test(input)) return null;
	const tokens = input.trim().split(/\s+/).filter(Boolean);
	return tokens.length ? tokens : null;
}

function tokenizeWithQuotes(input: string): string[] | null {
	// Allow simple single/double quotes and return argv-like tokens.
	// NOTE: parseCommandArgs does not implement escapes.
	// We keep a separate escape gate so specific commands (like rg) can opt into
	// allowing backslashes without enabling other shell metacharacters.
	if (SHELL_ESCAPES.test(input)) return null;
	const tokens = parseCommandArgs(input.trim()).filter(Boolean);
	return tokens.length ? tokens : null;
}

function tokenizeWithQuotesAndBackslashes(input: string): string[] | null {
	// Same as tokenizeWithQuotes, but allows backslashes.
	const tokens = parseCommandArgs(input.trim()).filter(Boolean);
	return tokens.length ? tokens : null;
}

// ─── Pipeline helpers ─────────────────────────────────────────

/**
 * Check if a pipe-target segment (everything after the first '|') is safe.
 * We allow read-only text-processing commands with arbitrary flags,
 * but specifically deny xargs unless it only has display-safe args.
 */
function isSafePipeSegment(segment: string): boolean {
	const trimmed = segment.trim();
	if (!trimmed) return false;
	if (DANGEROUS_METACHARS.test(trimmed)) return false;

	// Pipe segments are allowed to contain simple quotes for things like:
	//   rg ... | sed 's/foo/bar/'
	// but still forbid backslashes.
	const tokens = tokenizeWithQuotes(trimmed);
	if (!tokens) return false;

	const binary = (tokens[0].split("/").pop() ?? tokens[0]).trim();
	if (!SAFE_PIPE_TARGETS.has(binary)) return false;

	// xargs can execute arbitrary commands — disallow.
	if (binary === "xargs") return false;

	// For a couple of common viewers/limiters, keep flags numeric-only / simple.
	// This avoids needing full shell parsing while still allowing typical usage.
	if (binary === "head" || binary === "tail") {
		for (const a of tokens.slice(1)) {
			if (a.startsWith("-")) {
				// allow -n, -c, and forms like -n10 / -c100
				if (!/^-([nc]|n\d+|c\d+)$/.test(a)) return false;
				continue;
			}
			// No file arguments in pipe segments.
			return false;
		}
	}

	return true;
}

function isSafeFindArgs(args: string[]): boolean {
	// Disallow anything that can execute, delete, write, or produce complex output.
	const denyFlags = new Set([
		"-exec",
		"-execdir",
		"-ok",
		"-okdir",
		"-delete",
		"-printf",
		"-fprint",
		"-fprint0",
		"-fls",
		"-ls",
	]);

	for (const a of args) {
		if (denyFlags.has(a)) return false;
	}

	// Optional starting path(s): allow '.', relative paths, and ~ / ~/... home paths.
	// Still reject absolute paths and any '..' traversal.
	let i = 0;
	while (i < args.length && args[i] && !args[i].startsWith("-")) {
		const p = args[i];
		if (p.startsWith("/")) return false;
		// Allow ~ expansion (read-only); keep '..' blocked.
		if (p.split("/").includes("..")) return false;
		i++;
	}

	const allowUnaryWithValue = new Set(["-maxdepth", "-mindepth", "-name", "-iname", "-type", "-path", "-regex", "-not"]);
	const allowBare = new Set(["-print", "-print0", "-not", "!"]);

	for (; i < args.length; i++) {
		const tok = args[i];
		if (allowBare.has(tok)) {
			continue;
		}
		if (tok === "-") return false;

		if (allowUnaryWithValue.has(tok)) {
			const v = args[i + 1];
			if (!v) return false;
			if (tok === "-maxdepth" || tok === "-mindepth") {
				if (!/^\d+$/.test(v)) return false;
			} else if (tok === "-type") {
				if (!/^[fdl]$/.test(v)) return false;
			} else if (tok === "-name" || tok === "-iname") {
				if (v.includes("/")) return false;
			}
			i++; // consume value
			continue;
		}

		// If it starts with '-', it must be explicitly allowed.
		if (tok.startsWith("-")) return false;

		// Anything else (like predicates, parentheses, etc.) not allowed.
		return false;
	}

	return true;
}

function isSafeGrepArgs(args: string[]): boolean {
	// Allow simple grep usage only. Disallow recursion and options that change IO behavior.
	const deny = new Set([
		"-r",
		"-R",
		"--recursive",
		"--dereference-recursive",
		"--devices",
		"--directories",
		"--binary-files",
		"--include",
		"--exclude",
		"--exclude-dir",
	]);
	for (const a of args) {
		if (deny.has(a)) return false;
		// reject option bundles we haven't reviewed
		if (a.startsWith("-") && !["-n", "-H", "-h", "-i", "-I", "-s", "-v", "-w", "-E", "-F", "-P", "-o", "-a"].includes(a)) {
			return false;
		}
		if (a.includes("..")) return false;
	}
	return true;
}

function isSafeLsArgs(args: string[]): boolean {
	// Deny exotic flags; allow common read-only flags.
	for (const a of args) {
		if (a.startsWith("-")) {
			if (!/^-{1,2}[a-zA-Z0-9-]+$/.test(a)) return false;
			if (["--quoting-style", "--hide-control-chars"].includes(a)) return false;
			continue;
		}
		if (a.startsWith("/")) return false;
		if (a === "~" || a.startsWith("~/")) return false;
		if (a.split("/").includes("..")) return false;
	}
	return true;
}

function isSafeFdArgs(args: string[]): boolean {
	// Deny execution features.
	const deny = new Set(["-x", "--exec", "-X", "--exec-batch"]);
	for (let i = 0; i < args.length; i++) {
		const a = args[i];
		if (deny.has(a)) return false;
		if (a.startsWith("/")) return false;
		if (a === "~" || a.startsWith("~/")) return false;
		if (a.split("/").includes("..")) return false;
	}
	return true;
}

function isSafeRgArgs(args: string[]): boolean {
	// ripgrep is read-only, but it can spawn external processes via --pre.
	// Keep those behind explicit approval.
	for (const a of args) {
		if (a === "--pre" || a.startsWith("--pre=")) return false;
		if (a === "--pre-glob" || a.startsWith("--pre-glob=")) return false;
	}
	return true;
}

function isBashCommandWhitelisted(command: string): boolean {
	const trimmed = command.trim();
	if (!trimmed) return false;

	// Check for dangerous metacharacters BEFORE splitting on pipes.
	// Pipes are allowed, everything else dangerous is not.
	if (DANGEROUS_METACHARS.test(trimmed)) return false;

	// Disallow leading environment-variable assignments for whitelisted commands.
	if (/^(?:[A-Za-z_][A-Za-z0-9_]*=)/.test(trimmed)) return false;

	// Split on pipes to handle pipelines like `find . -name '*.ts' | sort`
	const segments = trimmed.split("|");

	// Validate the first (main) command
	const mainSegment = segments[0].trim();
	if (!mainSegment) return false;

	// Tokenize first so we can determine base command name.
	const probeTokens = tokenizeWithQuotesAndBackslashes(mainSegment);
	if (!probeTokens) return false;

	const binary = probeTokens[0];
	if (!binary) return false;
	const baseName = (binary.split("/").pop() ?? binary).trim();

	// For rg: allow single/double quotes *and* backslashes (common in regexes).
	// For other whitelisted commands, remain conservative.
	const tokens = baseName === "rg"
		? probeTokens
		: tokenizeNoQuotes(mainSegment);
	if (!tokens) return false;
	if (!BASH_WHITELIST.has(baseName)) return false;

	const args = tokens.slice(1);
	let mainOk = false;
	if (baseName === "find") mainOk = isSafeFindArgs(args);
	else if (baseName === "grep") mainOk = isSafeGrepArgs(args);
	else if (baseName === "ls") mainOk = isSafeLsArgs(args);
	else if (baseName === "fd") mainOk = isSafeFdArgs(args);
	else if (baseName === "rg") mainOk = isSafeRgArgs(args);

	if (!mainOk) return false;

	// Validate all pipe targets (if any)
	for (let i = 1; i < segments.length; i++) {
		if (!isSafePipeSegment(segments[i])) return false;
	}

	return true;
}

const BASH_APPROVAL_PREVIEW_CHARACTERS = 200;

function formatBashApproval(command: string): string {
	// Count and slice the same Unicode characters, not terminal columns or UTF-16 units.
	// Short commands (including multiline commands) are shown in full.
	const characters = Array.from(stripVTControlCharacters(command));
	const preview = characters.slice(0, BASH_APPROVAL_PREVIEW_CHARACTERS).join("");
	const omittedCharacters = characters.length - Array.from(preview).length;
	const label = `Bash: ${preview}`;

	return omittedCharacters > 0
		? `${label}…\n${omittedCharacters} command characters omitted. Full command in tool preview (Ctrl+O to expand).`
		: label;
}

// ─── Extension entry point ───────────────────────────────────────────────

export default function (pi: ExtensionAPI) {
	pi.on("tool_call", async (event, ctx) => {
		if (event.toolName === "read") return;
		if (isToolCallEventType("bash", event) && isBashCommandWhitelisted(event.input.command)) return;
		if (!ctx.hasUI) return;

		let label: string;
		if (isToolCallEventType("edit", event)) {
			label = `Edit: ${event.input.path}`;
		} else if (isToolCallEventType("write", event)) {
			label = `Write: ${event.input.path}`;
		} else if (isToolCallEventType("bash", event)) {
			label = formatBashApproval(event.input.command);
		} else {
			label = `Tool: ${event.toolName}`;
		}

		const approved = await ctx.ui.confirm(label, "Approve this tool call?");

		if (!approved) {
			const reason = await ctx.ui.input(
				"Rejection reason (for the model):",
				"Explain why you rejected this...",
			);
			return {
				block: true,
				reason: reason?.trim()
					? `User rejected: ${reason.trim()}`
					: "User rejected the proposed changes without giving a reason.",
			};
		}
	});
}
