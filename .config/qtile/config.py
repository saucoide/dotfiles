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

##### IMPORTS #####
import os
import re
import socket
import subprocess
from libqtile import qtile
from libqtile.config import Key, Screen, Group, Drag, Click, Match
from libqtile.command import lazy
from libqtile import layout, bar, widget, hook
from typing import List  # noqa: F401
from libqtile.config import ScratchPad, DropDown

import random
import pathlib
from mailwatcher import main as get_mails
from inoreader_rss_counter import main as get_feeds

##### DEFINING CONSTANTS & DEFAULT PROGRAMS #####

mod = "mod4"   # mod key to SUPER/WINDOWS
TRANS_FONT_SIZE = 60  # font size used for the separator effect on the bar, adjust for different resolutions

MY_TERMINAL = "termite"
TEXT_EDITOR = "emacs"
EMAIL_CLIENT = "emacs"
FILE_MANAGER = "thunar"
BROWSER = "firefox"
SYS_MONITOR = "xfce4-taskmanager"

MY_CONFIG = "~/.config/qtile/config.py"

## Numpad keys ##
NUMPAD = {  0: "KP_Insert",
            1: "KP_End",
            2: "KP_Down",
            3: "KP_Next",
            4: "KP_Left",
            5: "KP_Begin",
            6: "KP_Right",
            7: "KP_Home",
            8: "KP_Up",
            9: "KP_Prior"
    }

## Colors ##
COLORS = {
          "white":"ffffff",
          "background":"#2e3440",           # panel background
          "active_background":"#3B4252",    # background for current group
          "group_highlight":"#ff5555",      # border line color for current group
          "border_line":"#8d62a9",          # border line color for other tab and odd widgets
          "border_focus":"#5e81ac",
          "win_name":"#81a1c1",             # current window name
          "frost0":"#5e81ac",               # Theme colors (nord)
          "frost1":"#81a1c1",
          "frost2":"#434C5E",
          "frost3":"#4C566A",
          "aurora0":"#bf616a",
    }

##### DEFINING MY FUNCTIONS #####

@lazy.function
def float_to_front():
    for group in qtile.groups:
        for window in group.windows:
            if window.floating:
                window.cmd_bring_to_front()

def bar_transition(col_from, col_to):
    return widget.TextBox(text='◢',
                          background = col_from,
                          foreground = col_to,
                          padding=-5,
                          font="Ubuntu Mono derivative Powerline",
                          fontsize=TRANS_FONT_SIZE)

def get_wallpaper():
    wp_path = pathlib.Path.home() / ".config/qtile/wallpapers"
    wallpapers = list(filter(lambda x: x.suffix in (".png",".jpg"), wp_path.glob("*")))
    return random.choice(wallpapers)

def open_htop():
    qtile.cmd_spawn(f'{MY_TERMINAL} -e htop')

def open_sys_monitor():
    qtile.cmd_spawn(SYS_MONITOR)

def open_audio_settings():
    qtile.cmd_spawn("pavucontrol")

def open_mail():
    qtile.cmd_spawn(EMAIL_CLIENT)

def open_feeds():
    qtile.cmd_spawn(f"{BROWSER} --new-window https://www.inoreader.com")

def toggle_calendar():
    qtile.cmd_spawn(f'{MY_TERMINAL} -e cal;bash') # TODO find something better for this

def logout():
    qtile.cmd_spawn("arcolinux-logout")

def open_pamac():
    qtile.cmd_spawn("pamac-manager")

##### GROUPS #####
# fin the wm_class etc using xprop | grep WM_CLASS or similar

group_names = {"SYS": {'layout': 'columns'},
               "COM": {'layout': 'max'},
               "WWW": {'layout': 'columns'},
               "DEV": {'layout': 'columns'},
               "MUS": {'layout': 'max', "matches":[Match(title="Spotify Free")]},
               "VID": {'layout': 'columns', "matches":[Match(wm_class="smplayer")]},
               "NTS": {'layout': 'max'},
               "DOC": {'layout': 'columns'},
               "VMS": {'layout': 'max'}}

groups = [Group(name, **kwargs) for name, kwargs in group_names.items()]


##### KEYBINDINGS #####
keys = [
    ### BASICS

         Key([mod], "y", lazy.spawncmd(),
             desc='launch prompt'),
         Key([mod], "k", lazy.window.kill(),
             desc='Kill active window'),
         Key([mod], "q", lazy.window.kill(),
             desc='Kill active window'),
         Key([mod, "shift"], "r", lazy.restart(),
             desc='Restart Qtile'),
         Key([mod, "shift"], "q", lazy.shutdown(),
             desc='Shutdown Qtile'),
         #Key([mod], "x", lazy.spawn('arcolinux-logout')),

    ### WINDOW CONTROL

         ## Focus
         Key([mod], "Down", lazy.layout.down(),
             desc = "Switch focus to window below"),
         Key([mod], "Up", lazy.layout.up(),
             desc = "Switch focus to window above"),
         Key([mod], "Right", lazy.layout.left(),
             desc = "Switch focus to window to the right"),
         Key([mod], "Left", lazy.layout.right(),
             desc = "Switch focus to window to the right"),

         ## Toggle Fullscreen
         Key([mod], "f", lazy.window.toggle_fullscreen(),
             desc = "Toggle fullscreen for the current window"),

         ## Move
         Key([mod, "shift"], "Down", lazy.layout.shuffle_down(),
             desc = "Move window down"),
         Key([mod, "shift"], "Up", lazy.layout.shuffle_up(),
             desc = "Move window up"),
         Key([mod, "shift"], "Left", lazy.layout.shuffle_left(),
             desc = "Move window left"),
         Key([mod, "shift"], "Right", lazy.layout.shuffle_right(),
             desc = "Move window right"),

         ## Resize
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

         # Float
         Key([mod, "shift"], "f", lazy.window.toggle_floating(),
             desc='toggle floating'),

    ### LAYOUT CONTROL

         ## Switching layouts
         Key([mod], "Tab", lazy.next_layout(),
             desc='Toggle through layouts'),
         Key([mod], "c", lazy.to_layout_index(0),
             desc='switch to COLUMNS layout'),
         Key([mod], "t", lazy.to_layout_index(1),
             desc='switch to MONADTALL layout'),
         Key([mod], "m", lazy.to_layout_index(2),
             desc='switch to MAX layout'),
         #Key([mod, "shift"], "m", lazy.to_layout_index(3),
             #desc='switch to TREETAB layout'),

         Key([mod, "control"], "f", float_to_front,
             desc='switch to FLOATING layout'),

         ## Reset sizes
         Key([mod], "n", lazy.layout.normalize(),
             desc='normalize window size ratios'),

        ## Layout specific
         Key([mod], "Return", lazy.layout.toggle_split(),lazy.layout.flip(),
             desc = "Switch between Stack/Tile modes"),

    ### APPLICATION LAUNCHING

         ## Super + Key

         Key([mod], "space", lazy.spawn('rofi -show drun'),
             desc='Launch rofi drun'),

          Key([mod], "r", lazy.spawn('rofi -show run'),
             desc='Launch rofi run'),

         Key([mod], "e", lazy.spawn(FILE_MANAGER),
             desc='Launch file manager'),

         Key([mod], "Escape", lazy.spawn('xkill'),
             desc = 'Click to kill window'),

        ## (CONTROL + ALT + KEY) // alt+super+key?

         Key(["control", "mod1"], "t", lazy.spawn(MY_TERMINAL),
             desc='terminal'),

         Key([mod], "KP_Enter", lazy.spawn(MY_TERMINAL),
             desc='terminal'),

         Key(["control", "mod1"], "f", lazy.spawn(f"{BROWSER}"),
             desc='Launch browser'),

         Key(["control", "mod1"], "e", lazy.spawn(f"{MY_TERMINAL} -e vifm"),
             desc='Launch vifm'),

         Key(["control", "mod1"], "n", lazy.spawn(TEXT_EDITOR),
             desc='Launch text editor'),

         #Key([mod], "v", lazy.spawn('pavucontrol')),    # this is pulseaudio volume control, migth want to bind it to something

         ## Volume & Media keys
         Key([], "XF86AudioRaiseVolume", lazy.spawn("amixer -D pulse -q sset Master 5%+")),
         Key([], "XF86AudioLowerVolume", lazy.spawn("amixer -D pulse -q sset Master 5%-")),
         Key([], "XF86AudioMute", lazy.spawn("amixer -D pulse -q set Master toggle")),

         Key([], "XF86AudioPlay", lazy.spawn("playerctl play-pause")),
         Key([], "XF86AudioNext", lazy.spawn("playerctl next")),
         Key([], "XF86AudioPrev", lazy.spawn("playerctl previous")),
         Key([], "XF86AudioStop", lazy.spawn("playerctl stop")),

]


### GROUP KEYBINDINGS
for number, group in enumerate(groups, start=1):
    #Mod+Num = Switch group/view
    #Mod+Shift+Num = Send window to group & switch to it
    #Mod+Control+Num = Send window to group
    keys.append(Key([mod], str(number), lazy.group[group.name].toscreen()))
    keys.append(Key([mod], NUMPAD[number], lazy.group[group.name].toscreen()))
    keys.append(Key([mod, "shift"], str(number), lazy.window.togroup(group.name, switch_group=True)))
    keys.append(Key([mod, "shift"], NUMPAD[number], lazy.window.togroup(group.name, switch_group=True)))
    keys.append(Key([mod, "control"], str(number), lazy.window.togroup(group.name, switch_group=False)))
    keys.append(Key([mod, "control"], NUMPAD[number], lazy.window.togroup(group.name, switch_group=False)))

### TOGGLE LAST GROUP
keys.append(Key([mod], "BackSpace", lazy.screen.toggle_group()))


##### ADDING DROPDOWN TERMINAL #####
    ### Appending group
groups.append(ScratchPad("scratchpad", [DropDown("term",
                                                "/usr/bin/termite",
                                                opacity=0.88,
                                                height=0.33,
                                                width=0.8)]
                        )
)

    ### Setting the key binding
keys.extend([Key([], "F4", lazy.group["scratchpad"].dropdown_toggle("term"))])


##### THE LAYOUTS #####

    ### DEFAULT LAYOUT THEME SETTINGS #####
layout_theme = {"border_width": 2,
                "margin": 3,
                "border_focus": COLORS["frost1"],
                "border_normal": "1D2330"
                }

    ### LAYOUTS
layouts = [
    layout.Columns(**layout_theme, border_focus_stack = "bf616a"),
    layout.MonadTall(**layout_theme),
    layout.Max(**layout_theme),
    #layout.TreeTab(
         #font = "Ubuntu",
         #fontsize = 10,
         #sections = ["FIRST", "SECOND"],
         #section_fontsize = 11,
         #bg_color = "141414",
         #active_bg = "bf616a",
         #active_fg = "000000",
         #inactive_bg = "4c566a",
         #inactive_fg = "a7a7a7",
         #padding_y = 5,
         #section_top = 10,
         #panel_width = 150
         #)
    #layout.RatioTile(**layout_theme),
    #layout.VerticalTile(**layout_theme),
    #layout.Floating(**layout_theme),
    #layout.Tile(shift_windows=True, **layout_theme)
    #layout.MonadWide(**layout_theme),
    #layout.Bsp(**layout_theme),
    #layout.Stack(stacks=2, **layout_theme),
]


##### PROMPT FORMAT #####
prompt = "{0}@{1}: ".format(os.environ["USER"], socket.gethostname())

##### DEFAULT WIDGET SETTINGS #####
widget_defaults = dict(
    font="Ubuntu Mono derivative Powerline",
    fontsize = 12,
    padding = 2,
    background=COLORS["white"]
)

extension_defaults = widget_defaults.copy()   # ???

##### WIDGETS #####

def init_widgets_list():

    widgets_list = [

              widget.Image(
                        filename = "~/.config/qtile/icons/arcolinux.png",
                        background =  COLORS["background"],
                        margin = 2,
                        #margin_x = 0,
                        #margin_y = 0,
                        mouse_callbacks = {'Button1': lambda x: x.cmd_spawn('rofi -show drun')}
                   ),
             #widget.Sep(
                        #linewidth = 0,
                        #padding = 0+,
                        #foreground = COLORS["white"],
                        #background = COLORS["background"]
                        #),
               widget.GroupBox(font="Ubuntu Bold",
                        fontsize = 9,
                        margin_y = 3,
                        margin_x = 0,
                        padding_y = 5,
                        padding_x = 5,
                        borderwidth = 3,
                        active = COLORS["white"],
                        inactive = COLORS["white"],
                        rounded = False,
                        highlight_color = COLORS['active_background'],
                        highlight_method = "line",
                        this_current_screen_border = COLORS["group_highlight"],
                        this_screen_border = COLORS["border_line"],
                        other_current_screen_border = COLORS["background"],
                        other_screen_border = COLORS["background"],
                        foreground = COLORS["white"],
                        background = COLORS["background"],
                        disable_drag = True
                        ),
               widget.TextBox(text='⟋',
                          background = COLORS["background"],
                          foreground = COLORS["frost1"],
                          padding=0,
                          fontsize=50),
               widget.Prompt(
                        prompt=prompt,
                        font="Ubuntu Mono",
                        padding=10,
                        foreground = COLORS["group_highlight"],
                        background = COLORS["active_background"]
                        ),
               widget.Sep(
                        linewidth = 0,
                        padding = 2,
                        foreground = COLORS["white"],
                        background = COLORS["background"]
                        ),
               widget.TaskList(
                        background = COLORS["background"],
                        foreground = "#d8dee9",
                        font = "Ubuntu Mono",
                        fontsize = 12,
                        icon_size = 8,
                        border = COLORS["active_background"],
                        highlight_method = "block",
                        max_title_width = 120,
                        txt_floating = "🗗 ",
                        txt_maximized = "🗖 ",
                        margin = 0,
                        padding = 5,
                        ),
                widget.CurrentLayoutIcon(
                        custom_icon_paths=[os.path.expanduser("~/.config/qtile/icons")],
                        background = COLORS["background"],
                        padding = 0,
                        scale=0.7
                        ),
               widget.CurrentLayout(
                        foreground = COLORS["white"],
                        background = COLORS["background"],
                        padding = 5
                        ),
               bar_transition(COLORS["background"], COLORS["frost0"]),
               widget.GenPollText(
                   background = COLORS["frost0"],
                   func = get_mails,
                   update_interval = 600,
                   mouse_callbacks = {'Button1':open_mail}
                   ),
               bar_transition(COLORS["frost0"], COLORS["frost1"]),
               widget.TextBox(
                        text = "",
                        foreground = COLORS["white"],
                        background = COLORS["frost1"],
                        mouse_callbacks = {'Button1': open_feeds}
                   ),
               widget.GenPollText(
                   background = COLORS["frost1"],
                   func = get_feeds,
                   update_interval = 600,
                   mouse_callbacks={'Button1': open_feeds}
                   ),
               bar_transition(COLORS["frost1"], COLORS["frost2"]),
               widget.CPU(
                        foreground = COLORS["white"],
                        background = COLORS["frost2"],
                        padding = 0,
                        format = "CPU {load_percent}% | ",
                        mouse_callbacks={'Button1': open_htop, 'Button3': open_sys_monitor}
                        ),
               widget.Memory(
                        foreground = COLORS["white"],
                        background = COLORS["frost2"],
                        format = 'RAM {MemUsed}M/{MemTotal}M',
                        padding = 0,
                        mouse_callbacks={'Button1': open_htop, 'Button3': open_sys_monitor}
                        ),
               bar_transition(COLORS["frost2"], COLORS["frost3"]),
               widget.ThermalSensor(
                        foreground=COLORS["white"],
                        background=COLORS["frost3"],
                        padding = 0,
                        update_interval = 10,
                        ),
               bar_transition(COLORS["frost3"], COLORS["frost0"]),
               widget.TextBox(
                        text = "",
                        foreground = COLORS["white"],
                        background = COLORS["frost0"],
                        mouse_callbacks = {'Button1': open_audio_settings}
                   ),
               widget.Volume(
                        foreground = COLORS["white"],
                        background = COLORS["frost0"],
                        padding = 0,
                        volume_app = "pulseaudio",
                        device = "pulse"
                        ),
               bar_transition(COLORS["frost0"], COLORS["frost1"]),
               widget.CheckUpdates(
                        update_interval = 1800,
                        foreground = COLORS["white"],
                        background = COLORS["frost1"],
                        color_have_updates = COLORS["aurora0"],
                        display_format = '{updates} ⟳',
                        distro = "Arch_checkupdates",
                        mouse_callbacks = {'Button1': open_pamac}
                        ),
               bar_transition(COLORS["frost1"], COLORS["frost2"]),
                #widget.Systray(
                        #background=COLORS["frost2"],
                        #padding = 5
                        #),
               #bar_transition(COLORS["frost2"], COLORS["frost3"]),
               widget.Clock(
                        foreground = COLORS["white"],
                        background = COLORS["frost2"],
                        format="%d-%b-%Y [%H:%M] ",
                        padding = 2,
                        mouse_callbacks = {'Button1': toggle_calendar}
                        ),
               # bar_transition(COLORS["frost3"], COLORS["frost0"]),
               #widget.Battery(
                        #font="Ubuntu Mono",
                        #update_interval = 10,
                        #fontsize = 12,
                        #foreground = COLORS["white"],
                        #background = COLORS["frost3"],
	                    #),
               widget.TextBox(
                        text = "[⏻]",
                        background = COLORS["frost3"],
                        mouse_callbacks = {'Button1': logout}
                   ),
               #widget.QuickExit(
                        #background = COLORS["frost3"],
                        #countdown_format = "[{}s]",
                        #default_text = "[⏼]" # ⏻ ⏼ ⏽ ⭘ ⏾
                   #)
              ]
    return widgets_list

##### SCREENS ##### (TRIPLE MONITOR SETUP)

def init_screens():
    return [Screen(top=bar.Bar(widgets=init_widgets_list(), opacity=0.95, size=20),
                    wallpaper = get_wallpaper(),
                    wallpaper_mode = 'fill')
            ]

if __name__ in ["config", "__main__"]:
    screens = init_screens()
    widgets_list = init_widgets_list()



##### FLOATING WINDOWS #####

float_theme = {"border_width": 1,
               "border_focus": COLORS["background"]
               }

floating_types = ["notification", "toolbar", "splash", "dialog"]

@hook.subscribe.client_new
def set_floating(window):
    if (window.window.get_wm_transient_for()
            or window.window.get_wm_type() in floating_types):
        window.floating = True

floating_layout = layout.Floating(float_rules=[
                    {'wmclass': 'confirm'},
                    {'wmclass': 'dialog'},
                    {'wmclass': 'download'},
                    {'wmclass': 'error'},
                    {'wmclass': 'file_progress'},
                    {'wmclass': 'notification'},
                    {'wmclass': 'splash'},
                    {'wmclass': 'toolbar'},
                    {'wmclass': 'confirmreset'},  # gitk
                    {'wmclass': 'makebranch'},  # gitk
                    {'wmclass': 'maketag'},  # gitk
                    {'wname': 'branchdialog'},  # gitk
                    {'wname': 'pinentry'},  # GPG key password entry
                    {'wmclass': 'ulauncher'},
                    {'wmclass': 'krunner'},
                    {'wmclass': 'ssh-askpass'},  # ssh-askpass
                    {'wmclass': 'Arcolinux-tweak-tool.py'},
                    {'wmclass': 'Arandr'},
                    {'wmclass': 'arcolinux-logout'},
                    {'wname': 'branchdialog'},
                    {'wname': 'Open File'},
                    {'wname': 'pinentry'},
                    ],
                    **float_theme
                    )

auto_fullscreen = True
focus_on_window_activation = "smart"

##### DRAG FLOATING WINDOWS #####
mouse = [
    Drag([mod], "Button1", lazy.window.set_position_floating(),
         start=lazy.window.get_position()),
    Drag([mod], "Button3", lazy.window.set_size_floating(),
         start=lazy.window.get_size()),
    Click([mod], "Button2", lazy.window.bring_to_front())
]

dgroups_key_binder = None
dgroups_app_rules = []  # type: List
main = None
follow_mouse_focus = True
bring_front_click = False
cursor_warp = False



##### STARTUP APPLICATIONS #####
@hook.subscribe.startup_once
def start_once():
    autostart = pathlib.Path.home() / ".config/qtile/autostart.sh"
    subprocess.call([autostart])

# XXX: Gasp! We're lying here. In fact, nobody really uses or cares about this
# string besides java UI toolkits; you can see several discussions on the
# mailing lists, GitHub issues, and other WM documentation that suggest setting
# this string if your java app doesn't work correctly. We may as well just lie
# and say that we're a working one by default.
#
# We choose LG3D to maximize irony: it is a 3D non-reparenting WM written in
# java that happens to be on java's whitelist.
wmname = "LG3D"
