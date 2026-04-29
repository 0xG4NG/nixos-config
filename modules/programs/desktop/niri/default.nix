{ config, pkgs, osConfig, ... }:

{
  xdg.configFile."niri/config.kdl".text = ''
    environment {
        MOZ_ENABLE_WAYLAND "1"
        MOZ_DBUS_REMOTE "1"
        MOZ_GTK_TITLEBAR_DECORATION "client"
        LANG "C.UTF-8"
        NO_AT_BRIDGE "1"
    }

    output "DP-1" {
        mode "3840x2160@143.999"
        scale 1.5
        position x=0 y=0
    }

    output "DP-2" {
        mode "3840x2160@144"
        scale 1.5
        position x=2560 y=0
    }

    input {
        keyboard {
            xkb {
                layout "${osConfig.services.xserver.xkb.layout}"
                variant "${osConfig.services.xserver.xkb.variant}"
            }
        }
    }

    prefer-no-csd
    screenshot-path "~/screenshots/Screenshot-%Y-%m-%d-%H-%M-%S.png"
    spawn-at-startup "${pkgs.swaybg}/bin/swaybg" "-i" "${./wallpapers/996764.jpg}"
    spawn-sh-at-startup "wl-paste --watch cliphist store"
    spawn-at-startup "noctalia-shell"

    layout {
        gaps 32
        always-center-single-column
        preset-column-widths {
            proportion 0.5
            proportion 0.6667
            proportion 1.0
        }
        default-column-width { proportion 1.0; }
        focus-ring {
            off
        }
        border {
            width 2
            active-color "#CBA6F7"
            inactive-color "#373737"
        }
    }

    window-rule {
        geometry-corner-radius 0
        clip-to-geometry true
        opacity 1.0
    }

    animations {
        workspace-switch {
            spring damping-ratio=1.0 stiffness=1000 epsilon=0.0001
        }


       // Movimientos de cámara y ventanas: spring para sensación natural
        horizontal-view-movement {
            spring damping-ratio=1.0 stiffness=800 epsilon=0.0001
        }
        window-movement {
            spring damping-ratio=1.0 stiffness=800 epsilon=0.0001
        }
        window-resize {
            spring damping-ratio=1.0 stiffness=800 epsilon=0.0001
        }

        // Overview: spring suave
        overview-open-close {
            spring damping-ratio=1.0 stiffness=800 epsilon=0.0001
        }

        // Screenshot UI
        screenshot-ui-open {
            duration-ms 200
            curve "ease-out-quad"
        }

        // Notificación de error de config: rebota un poco (damping < 1)
        config-notification-open-close {
            spring damping-ratio=0.6 stiffness=1000 epsilon=0.001
        }
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
        // --- Lanzadores (capa base del TBK Mini) ---
        Mod+Return { spawn "ghostty"; }
        Mod+E { spawn "rofi" "-show" "drun"; }
        Mod+W { spawn "noctalia-shell" "msg" "launcher" "toggle"; }
        Mod+X { spawn "foot" "-a" "launcher" "-e" "fsel" "-d"; }
        Mod+Slash { spawn "foot" "-a" "launcher" "-e" "cliphist-select"; }
        Mod+Shift+Slash { spawn "foot" "-a" "launcher" "-e" "cliphist-delete"; }

        // --- Ventana / sesión ---
        Mod+Escape repeat=false { toggle-overview; }
        Mod+Backspace repeat=false { close-window; }
        Mod+Shift+Backspace { quit; }
        Mod+T { fullscreen-window; }
        Mod+Shift+T { expand-column-to-available-width; }
        Mod+F { toggle-window-floating; }
        Mod+R { switch-preset-column-width; }
        Mod+S { screenshot-screen show-pointer=false; }
        Mod+Shift+S { screenshot show-pointer=false; }

        // --- Navegación (J=izq, K=arriba, L=abajo, ;=der) ---
        // J/; = columnas, K/L = workspaces
        Mod+J { focus-column-left; }
        Mod+ntilde { focus-column-right; }
        Mod+L { focus-workspace-down; }
        Mod+K { focus-workspace-up; }
        Mod+Shift+J { move-column-left; }
        Mod+Shift+ntilde { move-column-right; }
        Mod+Shift+L { move-column-to-workspace-down; }
        Mod+Shift+K { move-column-to-workspace-up; }
        Mod+Ctrl+J { focus-monitor-left; }
        Mod+Ctrl+ntilde { focus-monitor-right; }
        Mod+Ctrl+Shift+J { move-column-to-monitor-left; }
        Mod+Ctrl+Shift+ntilde { move-column-to-monitor-right; }

        // --- Acceso directo a workspace (números en L1: MO(1) + fila superior) ---
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

        // --- Redimensionado (Minus/Equal en L2 del TBK: poco frecuente, aceptable) ---
        Mod+Minus { set-column-width "-10%"; }
        Mod+Equal { set-column-width "+10%"; }
        Mod+Ctrl+Minus repeat=true { set-window-height "-10%"; }
        Mod+Ctrl+Equal repeat=true { set-window-height "+10%"; }

        // --- Audio (Comma/Period/M están en capa base — ergonómico) ---
        Mod+Comma  allow-when-locked=true { spawn "wpctl" "set-volume" "@DEFAULT_AUDIO_SINK@" "5%-"; }
        Mod+Period allow-when-locked=true { spawn "wpctl" "set-volume" "@DEFAULT_AUDIO_SINK@" "5%+"; }
        Mod+M      allow-when-locked=true { spawn "wpctl" "set-mute"   "@DEFAULT_AUDIO_SINK@" "toggle"; }

        // Fallback para teclados externos con teclas multimedia dedicadas
        XF86AudioRaiseVolume allow-when-locked=true { spawn "wpctl" "set-volume" "@DEFAULT_AUDIO_SINK@" "5%+"; }
        XF86AudioLowerVolume allow-when-locked=true { spawn "wpctl" "set-volume" "@DEFAULT_AUDIO_SINK@" "5%-"; }
        XF86AudioMute        allow-when-locked=true { spawn "wpctl" "set-mute"   "@DEFAULT_AUDIO_SINK@" "toggle"; }
    }

    hotkey-overlay {
        skip-at-startup
    }
  '';
}
