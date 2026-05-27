# Agent Notes

- The project always lives in ~/workspace
- Most projects contain a `justfile` with commands to help with it, for
linting, testing, etc. Use those commands prefentially when running tests, etc.
- Python project use `uv`, default to it instead using python directly or
activating environments.
- tmux is available, if you need to use a tui for debugging, do it via tmux
- ripgrep and fd are also available, prefer them over grep and find
- do not grep too aggresively, use it for finding references, but prefer
reading a whole file unless its extremely large
- dont be overly conservative with `| head` and `| tail`, prefer reading bigger
chunks, of the whole output
