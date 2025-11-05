#!/usr/bin/env fish

argparse 'c/closed' 'o/opened' -- $argv
or return

if set -ql _flag_c
    # notify-send Closed

    echo $(hyprctl monitors -j | jq '.[] | select(.name == "eDP-1") | "\(.name), preferred, auto-center-down, \(.scale)"') > ./temp-sett.txt

    if test (hyprctl monitors -j | jq length) -gt 1
        # More than 1 monitor: turn off laptop one
        hyprctl dispatch exec hyprctl keyword monitor "eDP-1, disable"
    else
        # Only 1 monitor: suspend
        systemctl suspend
    end

else if set -ql _flag_o
    # notify-send Opened

    # Resume laptop display anyway
    hyprctl dispatch exec hyprctl keyword monitor $(cat temp-sett.txt)

end
