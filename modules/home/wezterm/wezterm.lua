local wezterm = require("wezterm")
local sessionizer = require("sessionizer")
local config = wezterm.config_builder()

config.default_prog = { '@FISH@/bin/fish', '-l' }


config.enable_tab_bar = false
config.window_decorations = "@WINDOW_DECORATIONS@"
config.window_close_confirmation = "NeverPrompt"

config.font = wezterm.font('JetBrainsMono Nerd Font', { weight = "Bold" })
config.font_size = @FONT_SIZE@

config.unix_domains = { { name = 'unix', }, }
-- config.default_domain = "unix"

config.leader = {
  key = 'p',
  mods = 'CTRL',
  timeout_milliseconds = 2000,
}

config.keys = {
  { key = 'a', mods = 'LEADER', action = wezterm.action.AttachDomain 'unix', },
  { key = 'd', mods = 'LEADER', action = wezterm.action.DetachDomain { DomainName = 'unix' }, },
  { key = "p", mods = "LEADER", action = wezterm.action_callback(sessionizer.toggle)},
  { key = "f", mods = "LEADER", action = wezterm.action_callback(sessionizer.flakes)},
  { key = "l", mods = "LEADER", action = wezterm.action_callback(sessionizer.list)},
  { key = "Backspace", mods = "LEADER", action = wezterm.action_callback(sessionizer.last)},
  { key = "k", mods = "LEADER", action = wezterm.action.CloseCurrentTab { confirm = true } },
  { key = "n", mods = "CTRL", action = wezterm.action_callback(function(_, pane)
    pane:send_text("i\b\b\b\b\b\b\b\bnvim\r")
    end)
  },
}

-- config.color_scheme = 'Monokai Dark (Gogh)'
config.colors = {
  foreground = "#fcfcfa",
  background = "#2d2a2e",
  cursor_fg = "#19181a",
  cursor_bg = "#fcfcfa",
  -- Specifies the border color of the cursor when the cursor style is set to Block,
  -- or the color of the vertical or horizontal bar when the cursor style is set to
  -- Bar or Underline.
  cursor_border = "#fcfcfa",

  -- the foreground color of selected text
  selection_fg = "#fcfcfa",
  -- the background color of selected text
  selection_bg = "#524c54",

  -- The color of the scrollbar "thumb"; the portion that represents the current viewport
  scrollbar_thumb = '#222222',

  -- The color of the split lines between panes
  split = '#444444',


  ansi = {
    "#221f22",
    "#cc6666",
    "#a9dc76",
    "#ffd866",
    "#78dce8",
    "#ab9df2",
    "#fc9867",
    "#fcfcfa",
  },
  brights = {
    "#727072",
    "#ff6188",
    "#a9dc76",
    "#ffd866",
    "#78dce8",
    "#ab9df2",
    "#fc9867",
    "#fcfcfa",
  }
}
return config
