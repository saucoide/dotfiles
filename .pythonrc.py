import IPython
from traitlets.config import get_config

cfg = get_config()
cfg.InteractiveShellEmbed.colors = "Linux"  # syntax highlighting
cfg.InteractiveShellEmbed.confirm_exit = False

alias interacti IPython.embed(config=cfg)
