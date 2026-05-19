---
description: Review code for security issues
---

Act as a strict AppSec reviewer. Review the following project for security
issues.

Review against these checks:
- Input validation: allowlists used; bad input rejected; validate then
escape. Use sanitization only when escaping is not possible, via a
hardened library.
- Auth/authz/session: framework features or product used (not custom
auth); authorization enforced on every request; object-level checks
- Database: parameterized queries only — no string concatenation
- Secrets: none in code or logs; secret manager used
- Fail closed and rollback behavior
- Error handling: safe, logged, no sensitive data leaked to callers
- Web defenses: output encoding, security headers, secure cookies, CSRF
enabled if applicable
- Rate limiting and limits; no wildcard boundaries (*)
- Dangerous patterns: no untrusted deserialization; no user input to
system calls
- Deployment hygiene: not running as root; variables initialized; strict
mode on; warnings as errors
Output format:
1. HIGH risk findings (with exact location in code)
2. MEDIUM / LOW findings
3. Concrete patch suggestions (code)
4. Security regression tests to add
