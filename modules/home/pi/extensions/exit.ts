import type { ExtensionAPI } from "@earendil-works/pi-coding-agent";

export default function (pi: ExtensionAPI) {
  pi.on("input", (event, ctx) => {
    if (event.source === "interactive" && event.text.trim() === "exit") {
      ctx.shutdown();
      return { action: "handled" };
    }

    return { action: "continue" };
  });

  pi.registerCommand("exit", {
    description: "Exit pi cleanly (alias for /quit)",
    handler: async (_args, ctx) => {
      ctx.shutdown();
    },
  });
}
