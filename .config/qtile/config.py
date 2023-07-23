# -*- coding: utf-8 -*-
#
# Generated from ~/dotfiles/system.org
# Author: saucoide
# configuration file for a customized  Qtile window manager (http://www.qtile.org)
# based on a version by Derek Taylor  (http://www.gitlab.com/dwt1/ )
#
# The following comments are the copyright and licensing information from the default
# qtile config. Copyright (c) 2010 Aldo Cortesi, 2010, 2014 dequis, 2012 Randall Ma,
# 2012-2014 Tycho Andersen, 2012 Craig Barnes, 2013 horsik, 2013 Tao Sauvage
#
# Permission is hereby granted, free of charge, to any person obtaining a copy of this
# software and associated documentation files (the "Software"), to deal in the Software
# without restriction, including without limitation the rights to use, copy, modify,
# merge, publish, distribute, sublicense, and/or sell copies of the Software, and to
# permit persons to whom the Software is furnished to do so, subject to the following
# conditions:
#
# The above copyright notice and this permission notice shall be includ ed in all copies
# or substantial portions of the Software.
import os
import pathlib
import random
import socket
import subprocess

from libqtile import bar, layout, widget, hook
from libqtile.config import Click, Drag, Group, Key, Match, Screen
from libqtile.lazy import lazy
from libqtile.utils import guess_terminal

from mailwatcher import main_wrapper as mailwatcher
from inoreader import main_wrapper as inoreader


# Main Modifier
mod = "mod4"

# Programs & Constants'
TERMINAL = guess_terminal()
TEXT_EDITOR = "emacsclient --create-frame --alternate-editor ''"
EMAIL_CLIENT = "emacs"
FILE_MANAGER = "thunar"
BROWSER = "firefox"
SYS_MONITOR = "xfce4-taskmanager"

MY_CONFIG = "~/.config/qtile/config.py"

# Prompt format
prompt = "{0}@{1}: ".format(os.environ["USER"], socket.gethostname())

# Colors
COLORS = {
    "white":"ffffff",
    "background_0":"#2e3440",           # backgrounds 0 darkest - 3 lighest
    "background_1":"#3B4252",           
    "background_2":"#434c5e",          
    "background_3":"#4c566a",          
    "group_highlight":"#ff5555",      # border line color for current group
    "border_line":"#8d62a9",          # border line color for other tab and odd widgets
    "border_focus":"#5e81ac",
    "win_name":"#81a1c1",             # current window name
    "frost0":"#5e81ac",               # Theme colors (nord)
    "frost1":"#81a1c1",
    "frost2":"#434C5E",
    "frost3":"#4C566A",
    "nord_white": "#c7cdd8",
    "nord_red":"#bf616a",
    "lime": "#50fa7b",
}

# Custom Functions
@lazy.function
def float_to_front():
    for group in qtile.groups:
        for window in group.windows:
            if window.floating:
                window.cmd_bring_to_front()
                
def get_wallpaper():
    wp_path = pathlib.Path.home() / ".config/qtile/wallpapers"
    wallpapers = list(filter(lambda x: x.suffix in (".png",".jpg"), wp_path.glob("*")))
    return random.choice(wallpapers)

def launch_rofi():
    lazy.spawn_cmd('rofi -show drun')

# Key bindings
keys = [
    
    # Basics
    Key([mod], "y", lazy.spawncmd(), desc='launch prompt'),
    Key([mod], "k", lazy.window.kill(), desc='Kill active window'),
    Key([mod], "q", lazy.window.kill(), desc='Kill active window'),
    Key([mod, "shift"], "r", lazy.restart(), desc='Restart Qtile'),
    Key([mod, "shift"], "q", lazy.shutdown(), desc='Shutdown Qtile'),
    Key([mod, "control"], "r", lazy.reload_config(), desc="Reload the config"),

    # Window Control

    ## Focus
    Key([mod], "Down", lazy.layout.down(), desc = "Move focus down"),
    Key([mod], "Up", lazy.layout.up(), desc = "Move focus up"),
    Key([mod], "Right", lazy.layout.left(), desc = "Move focus to right"),
    Key([mod], "Left", lazy.layout.right(),desc="Move focus to left"),
    # Key([mod], "h", lazy.layout.left(), desc="Move focus to left"),
    # Key([mod], "l", lazy.layout.right(), desc="Move focus to right"),
    # Key([mod], "j", lazy.layout.down(), desc="Move focus down"),
    # Key([mod], "k", lazy.layout.up(), desc="Move focus up"),
    Key([mod], "space", lazy.layout.next(), desc="Move window focus to other window"),

    ## Toggle Fullscreen
    Key([mod], "f", lazy.window.toggle_fullscreen(), desc = "Toggle fullscreen for the current window"),
    
    ## Move
    Key([mod, "shift"], "Down", lazy.layout.shuffle_down(), desc = "Move window down"),
    Key([mod, "shift"], "Up", lazy.layout.shuffle_up(), desc = "Move window up"),
    Key([mod, "shift"], "Left", lazy.layout.shuffle_left(), desc = "Move window left"),
    Key([mod, "shift"], "Right", lazy.layout.shuffle_right(), desc = "Move window right"),
    # Key([mod, "shift"], "h", lazy.layout.shuffle_left(), desc="Move window to the left"),
    # Key([mod, "shift"], "l", lazy.layout.shuffle_right(), desc="Move window to the right"),
    # Key([mod, "shift"], "j", lazy.layout.shuffle_down(), desc="Move window down"),
    # Key([mod, "shift"], "k", lazy.layout.shuffle_up(), desc="Move window up"),

    ## Resize
    Key([mod], "n",
        lazy.layout.normalize(),
        desc="Reset all window sizes"),
    Key([mod, "control"], "Down",
        lazy.layout.grow_down(),
        lazy.layout.shrink(),
        desc = "Increase size down"),
    Key([mod, "control"], "Up",
        lazy.layout.grow_up(),
        lazy.layout.grow(),
        desc = "Increase size up"),
    Key([mod, "control"], "Left",
        lazy.layout.grow_left(),
        lazy.layout.shrink(),
        lazy.layout.decrease_ratio(),
        desc = "Increase size left"),
    Key([mod, "control"], "Right",
        lazy.layout.grow_right(),
        lazy.layout.grow(),
        lazy.layout.increase_ratio(),
        desc = "Increase size right"),
    # Key([mod, "control"], "h", lazy.layout.grow_left(), desc="Grow window to the left"),
    # Key([mod, "control"], "l", lazy.layout.grow_right(), desc="Grow window to the right"),
    # Key([mod, "control"], "j", lazy.layout.grow_down(), desc="Grow window down"),
    # Key([mod, "control"], "k", lazy.layout.grow_up(), desc="Grow window up"),

    # Layout Control
    
    ## Switching layouts
    Key([mod], "Tab", lazy.next_layout(), desc='Toggle through layouts'),
    Key([mod], "c", lazy.to_layout_index(0), desc='switch to COLUMNS layout'),
    Key([mod], "t", lazy.to_layout_index(0), desc='switch to COLUMNS layout'),
    Key([mod], "m", lazy.to_layout_index(1), desc='switch to MAX layout'),

    ## Layout specific
    Key([mod], "Return", lazy.layout.toggle_split(),lazy.layout.flip(),
        desc = "Switch between Stack/Tile modes"),
    
    ## Float
    Key([mod, "shift"], "f", lazy.window.toggle_floating(), desc='toggle floating'),
    Key([mod, "control"], "f", float_to_front, desc='Surface all floating windows'),

    # Application Launching

    ## Super + Key
    Key([mod], "space", lazy.spawn('rofi -show drun'), desc='Launch rofi drun'),
    Key([mod], "e", lazy.spawn(FILE_MANAGER), desc='Launch file manager'),
    Key([mod], "Escape", lazy.spawn('xkill'), desc = 'Click to kill window'),

    ## (CONTROL + ALT + KEY) // alt+super+key?
    Key(["control", "mod1"], "t", lazy.spawn(TERMINAL), desc='terminal'),
    Key(["control", "mod1"], "f", lazy.spawn(f"{BROWSER}"), desc='Launch browser'),
    Key(["control", "mod1"], "n", lazy.spawn(TEXT_EDITOR), desc='Launch text editor'),

    ## Screenshots
    Key([], "Print", lazy.spawn('flameshot gui'), desc='Take a Screenshot'),
    Key([mod], "Print", lazy.spawn('flameshot launcher'), desc='Screenshot Menu'),

    ## Volume & Media keys
    # TODO:
    Key([], "XF86AudioRaiseVolume", lazy.spawn("pactl set-sink-volume @DEFAULT_SINK@ +5%")),
    Key([], "XF86AudioLowerVolume", lazy.spawn("pactl set-sink-volume @DEFAULT_SINK@ -5%")),
    Key([], "XF86AudioMute", lazy.spawn("pactl set-sink-mute @DEFAULT_SINK@ toggle")),
    Key([], "XF86AudioMicMute", lazy.spawn("pactl set-source-mute @DEFAULT_SOURCE@ toggle")),

    # Key([], "XF86AudioPlay", lazy.spawn("playerctl play-pause")),
    # Key([], "XF86AudioNext", lazy.spawn("playerctl next")),
    # Key([], "XF86AudioPrev", lazy.spawn("playerctl previous")),
    # Key([], "XF86AudioStop", lazy.spawn("playerctl stop")),
]

# Mouse
follow_mouse_focus = False
dgroups_key_binder = None
dgroups_app_rules = []  # type: list
bring_front_click = False
cursor_warp = False
## Drag floating layouts.
mouse = [
    Drag([mod], "Button1", lazy.window.set_position_floating(), start=lazy.window.get_position()),
    Drag([mod], "Button3", lazy.window.set_size_floating(), start=lazy.window.get_size()),
    Click([mod], "Button2", lazy.window.bring_to_front()),
]

# floating_types = ["notification", "toolbar", "splash", "dialog"]

# @hook.subscribe.client_new
# def set_floating(window):
#     if (window.window.get_wm_transient_for()
#             or window.window.get_wm_type() in floating_types):
#         window.floating = True

floating_layout = layout.Floating(
    float_rules=[
        # Run the utility of `xprop` to see the wm class and name of an X client.
        *layout.Floating.default_float_rules,
        Match(wm_class="ssh-askpass"),  # ssh-askpass
        Match(wm_class="pinentry"),
        Match(wm_class='confirm'),
        Match(wm_class='dialog'),
        Match(wm_class='download'),
        Match(wm_class='error'),
        Match(wm_class='file_progress'),
        Match(wm_class='notification'),
        Match(wm_class='splash'),
        Match(wm_class='toolbar'),
        Match(wm_class='Arandr'),
        Match(title='Open File'),
    ],
    border_width=1,
    border_focus="#bf616a", # TODO: change color
)

# Groups
groups = [Group(i, layout="columns") for i in "123456789"]

## Keybindings

### Goto last group
keys.append(Key([mod], "BackSpace", lazy.screen.toggle_group()))

### Number keys for each group
for number, group in enumerate(groups, start=1):
    #Mod+Num = Switch group/view
    #Mod+Shift+Num = Send window to group & switch to it
    #Mod+Control+Num = Send window to group
    keys.append(Key([mod], str(number), lazy.group[group.name].toscreen()))
    keys.append(Key([mod, "shift"], str(number), lazy.window.togroup(group.name, switch_group=True)))
    keys.append(Key([mod, "control"], str(number), lazy.window.togroup(group.name, switch_group=False)))

# Layouts
layouts = [
    layout.Columns(
        margin=2,
        border_width= 2,
        border_normal=COLORS["background_0"],
        border_focus=COLORS["lime"],
        border_focus_stack=COLORS["nord_red"]),
    layout.Max(
        margin=0,
        border_width=1,
        border_focus=COLORS["frost3"],
        ),
]

# Screens & Widgets
auto_fullscreen = True
focus_on_window_activation = "smart"
reconfigure_screens = True
# If things like steam games want to auto-minimize themselves when losing
# focus, should we respect this or not?
auto_minimize = True

widget_defaults = dict(
    font="Ubuntu Mono",
    fontsize = 12,
    padding = 2,
    background=COLORS["background_0"]
)
extension_defaults = widget_defaults.copy()   # ???

#TODO CHANGE ALL THIS 
screens = [
    Screen(
        top=bar.Bar(
            [
                widget.Image(
                    filename = "~/.config/qtile/icons/arcolinux.png",
                    margin = 3,
                    mouse_callbacks = {'Button1': lazy.spawn("rofi -show drun")}
                ),
                widget.GroupBox(
                    font="UbuntuMono Nerd Font",
                    fontsize=18,
                    margin_x=5,
                    padding_x=5,
                    borderwidth=3,
                    block_highlight_text_color=COLORS["white"],
                    active=COLORS["nord_white"],
                    inactive=COLORS["background_2"],
                    highlight_color=COLORS["background_1"],
                    highlight_method="line",
                    this_current_screen_border=COLORS["nord_red"],
                    this_screen_border=COLORS["nord_red"],
                    rounded=False,
                    disable_dag=True,
                ),
                widget.CurrentLayoutIcon(
                    custom_icon_paths=[os.path.expanduser("~/.config/qtile/icons")],
                    background = COLORS["background_0"],
                    padding = 0,
                    scale=0.6
                ),
                widget.Prompt(),
                widget.WindowTabs(
                    foreground=COLORS["nord_white"],
                ),
                widget.GenPollText(
                    func=mailwatcher,
                    update_interval=600,
                    fmt="󰇮 {} |",
                ),
                widget.GenPollText(
                    func=inoreader,
                    update_interval=600,
                    fmt=" {} |",
                ),
                widget.CPU(
                    format="CPU {freq_current}GHz {load_percent}% |",
                    update_interval=5,
                ),
                widget.ThermalSensor(
                    format="{temp:.0f}{unit} |",
                    update_interval=5,
                ),
                widget.PulseVolume(
                    fmt=" {} |",
                    update_interval=1,
                ), 
                widget.Systray(),
                widget.Clock(
                    format="%Y-%m-%d %H:%M |",
                    mouse_callbacks={"Button1": lazy.spawn(
                        cmd="alacritty --hold --title 'terminal-calendar' --command cal --monday --three --columns=3"
                    )}
                ),
                widget.TextBox(
                    fmt="󰐥 ",
                    mouse_callbacks={'Button1': lazy.spawn("logout-menu")}
                ),
            ],
            24,
        ),
        wallpaper = get_wallpaper(),
        wallpaper_mode = 'fill',
    ),
]

# Startup Applications
@hook.subscribe.startup_once
def autostart():
    autostart_script = pathlib.Path.home() / ".config/qtile/autostart.sh"
    subprocess.call([autostart_script])

# XXX: Gasp! We're lying here. In fact, nobody really uses or cares about this
# string besides java UI toolkits; you can see several discussions on the
# mailing lists, GitHub issues, and other WM documentation that suggest setting
# this string if your java app doesn't work correctly. We may as well just lie
# and say that we're a working one by default.
#
# We choose LG3D to maximize irony: it is a 3D non-reparenting WM written in
# java that happens to be on java's whitelist.
wmname = "LG3D"
