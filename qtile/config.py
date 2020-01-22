# -*- coding: utf-8 -*-
from libqtile.config import Key, Screen, Group, Drag, Click, Match
from libqtile.command import lazy
from libqtile import layout, bar, widget
from libqtile import hook
import time
import subprocess
import re
from subprocess import call

mod = "mod4"
shell = "xterm -ls" 
file_manager = "dolphin"
dgroups_key_binder = None
dgroups_app_rules = []
main = None
follow_mouse_focus = False
bring_front_click = False
cursor_warp = False
floating_layout = layout.Floating()
auto_fullscreen = True
wmname = "qtile"

keys = [
    # Switch between windows in current stack pane
    Key(
        [mod], "k",
        lazy.layout.next()
    ),
    Key(
        [mod], "j",
        lazy.layout.previous()
    ),
    Key(
        [mod], "l",
        lazy.next_screen()
    ),
    Key(
        [mod], "o",
        lazy.prev_screen()
    ),
    Key(
        [mod], "1",
        lazy.to_screen(1)
    ),
    Key(
        [mod], "2",
        lazy.to_screen(0)
    ),
    Key(
        [mod], "3",
        lazy.to_screen(2)
    ),
    
    # Move windows up or down in current stack
    Key(
        [mod, "control"], "k",
        lazy.layout.shuffle_down()
    ),
    Key(
        [mod, "control"], "j",
        lazy.layout.shuffle_up()
    ),

    # Swap panes of split stack
    Key(
        [mod, "shift"], "space",
        lazy.layout.rotate()
    ),
    # multiple stack panes
    Key(
        [mod, "shift"], "Return",
        lazy.layout.toggle_split()
    ),

    # Toggle between different layouts as defined below
    Key([mod], "Tab", lazy.next_layout()),
    Key([mod], "q", lazy.window.kill()),
    Key([mod, "control"], "r", lazy.restart()),
    Key([mod, "control"], "q", lazy.shutdown()),
    Key([mod, "control"], "s", lazy.spawn("sudo pm-suspend")),
        
    Key([mod], "g", lazy.layout.grow()),
    Key([mod], "h", lazy.layout.shrink()),

    Key([mod], "Return", lazy.spawn(shell)),
    Key([mod], "w", lazy.spawn(file_manager)),
    Key([mod], "r", lazy.spawncmd()),
    #Multimedia Keys Config
    Key([], "XF86MonBrightnessUp", lazy.spawn("xbacklight -inc 2")),
    Key([], "XF86MonBrightnessDown", lazy.spawn("xbacklight -dec 2")),
    Key([], "Print", lazy.spawn("deepin-screenshot")),
]

groups = [Group(i) for i in "asdfzxc"]

for i in groups:
    # mod1 + letter of group = switch to group
    keys.append(
        Key([mod], i.name, lazy.group[i.name].toscreen())
    )

    # mod1 + shift + letter of group = switch to & move focused window to group
    keys.append(
        Key([mod, "shift"], i.name, lazy.window.togroup(i.name))
    )

layouts = [
    layout.Max(),
    layout.MonadTall(ratio=0.6, change_size=10),
    layout.VerticalTile()
]

widget_defaults = dict(
    font='Droid Sans Mono',
    fontsize=32,
)

screens = [
    Screen(
        bottom=bar.Bar(
            [
                widget.GroupBox(),
                widget.Prompt(),
                widget.WindowName(),
                widget.Systray(icon_size=32),
                widget.BatteryIcon(fontsize=12),
                widget.Clock(format='%b %d %Y %I:%M %p'),
            ],
            40,
        ),
        top=bar.Bar(
            [
                widget.CurrentScreen(active_text="*"*200, inactive_text="")
            ],
            20,
        ),
    ),
    Screen(
        top=bar.Bar(
            [
                widget.CurrentScreen(active_text="*"*200, inactive_text="")
            ],
            20,
        ),
    ),
    Screen(
        top=bar.Bar(
            [
                widget.CurrentScreen(active_text="*"*200, inactive_text="")
            ],
            20,
        ),
    ),
]

# Drag floating layouts.
mouse = [
    Drag([mod], "Button1", lazy.window.set_position_floating(),
        start=lazy.window.get_position()),
    Drag([mod], "Button3", lazy.window.set_size_floating(),
        start=lazy.window.get_size()),
    Click([mod], "Button2", lazy.window.bring_to_front())
]

def execute(process):
    return subprocess.Popen(process.split())

@hook.subscribe.startup_once
def startup_once():
    execute('nm-applet')
    execute('/usr/bin/chrome  --force-device-scale-factor=2')
    execute('redshift -l 26.1619104:-80.3242327')
    execute('volctl')
    execute('xscreensaver')
    
@hook.subscribe.startup
def startup():
    execute('xsetroot -solid black')

# look for new monitor
#@hook.subscribe.screen_change
#def restart_on_randr(qtile, ev):
#    call("setup_screens")
#    qtile.cmd_restart()
