{ config, ... }:

let
  c = config.lib.stylix.colors.withHashtag;
in
{
  xdg.configFile."niri/config.kdl".text = ''
    environment {
        MOZ_ENABLE_WAYLAND "1"
        MOZ_DBUS_REMOTE "1"
        LANG "C.UTF-8"
        NO_AT_BRIDGE "1"
    }

    output "DP-2" {
        mode "3840x2160@143.999"
        scale 1.5
        position x=0 y=0
        variable-refresh-rate
    }

    output "DP-1" {
        mode "3840x2160@144.000"
        scale 1.5
        position x=2560 y=0
        variable-refresh-rate
    }

    input {
        focus-follows-mouse
    }

    prefer-no-csd
    screenshot-path "~/screenshots/Screenshot-%Y-%m-%d-%H-%M-%S.png"
    spawn-sh-at-startup "swaybg -i ${config.stylix.image}"
    spawn-sh-at-startup "wl-paste --watch cliphist store"
    spawn-at-startup "noctalia-shell"

    layout {
        gaps 16
        always-center-single-column
        preset-column-widths {
            proportion 0.4
            proportion 0.6
        }
        default-column-width { proportion 0.6; }
        focus-ring {
            off
        }
        border {
            width 2
            active-color "${c.base0E}"
            inactive-color "${c.base03}"
            urgent-color "${c.base08}"
        }
    }

    overview {
        backdrop-color "${c.base01}"
    }

    window-rule {
        geometry-corner-radius 5
        clip-to-geometry true
    }

    window-rule {
        match app-id="launcher"
        match app-id="mpv"
        match app-id="swayimg"
        match app-id="[Tt]hunar" title="^File Operation Progress"
        match app-id="[Tt]hunar" title="^Rename"
        open-floating true
    }

    binds {
        Mod+Return { spawn "ghostty"; }
        Mod+E { spawn "noctalia-shell" "ipc" "call" "launcher" "toggle"; }
        Mod+A { spawn "firefox"; }
        Mod+X { spawn "foot" "-a" "launcher" "-e" "fsel" "-d"; }
        Mod+Slash { spawn "foot" "-a" "launcher" "-e" "cliphist-select"; }
        Mod+Shift+Slash { spawn "foot" "-a" "launcher" "-e" "cliphist-delete"; }
        Mod+Escape repeat=false { toggle-overview; }
        Mod+Q repeat=false { close-window; }
        Mod+Left { focus-column-left; }
        Mod+Down { focus-window-down; }
        Mod+Up { focus-window-up; }
        Mod+Right { focus-column-right; }
        Mod+Shift+Left { move-column-left; }
        Mod+Shift+Down { move-window-down; }
        Mod+Shift+Up { move-window-up; }
        Mod+Shift+Right { move-column-right; }
        Mod+1 { focus-workspace 1; }
        Mod+2 { focus-workspace 2; }
        Mod+3 { focus-workspace 3; }
        Mod+4 { focus-workspace 4; }
        Mod+5 { focus-workspace 5; }
        Mod+6 { focus-workspace 6; }
        Mod+7 { focus-workspace 7; }
        Mod+8 { focus-workspace 8; }
        Mod+9 { focus-workspace 9; }
        Mod+Shift+1 { move-column-to-workspace 1; }
        Mod+Shift+2 { move-column-to-workspace 2; }
        Mod+Shift+3 { move-column-to-workspace 3; }
        Mod+Shift+4 { move-column-to-workspace 4; }
        Mod+Shift+5 { move-column-to-workspace 5; }
        Mod+Shift+6 { move-column-to-workspace 6; }
        Mod+Shift+7 { move-column-to-workspace 7; }
        Mod+Shift+8 { move-column-to-workspace 8; }
        Mod+Shift+9 { move-column-to-workspace 9; }
        Mod+T { fullscreen-window; }
        Mod+Shift+T { expand-column-to-available-width; }
        Mod+F { toggle-window-floating; }
        Mod+R { switch-preset-column-width; }
        Mod+S { screenshot-screen show-pointer=false; }
        Mod+Shift+S { screenshot show-pointer=false; }
        Mod+Shift+Q { quit; }
    }

    hotkey-overlay {
        skip-at-startup
    }
  '';
}
