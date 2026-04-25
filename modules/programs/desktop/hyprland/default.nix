{ config, pkgs, lib, ... }:

let
  c = config.lib.stylix.colors.withHashtag;

  powermenu = pkgs.writeShellScript "powermenu" ''
    options="  Apagar\n  Reiniciar\n  Suspender\n  Hibernar\n󰍃  Cerrar sesión"
    chosen=$(printf "$options" | ${pkgs.rofi}/bin/rofi -dmenu -p "Sesión" -i)
    case "$chosen" in
      *"Apagar"*)        systemctl poweroff ;;
      *"Reiniciar"*)     systemctl reboot ;;
      *"Suspender"*)     systemctl suspend ;;
      *"Hibernar"*)      systemctl hibernate ;;
      *"Cerrar sesión"*) hyprctl dispatch exit ;;
    esac
  '';

  screenshot = pkgs.writeShellScript "screenshot" ''
    mkdir -p ~/screenshots
    ${pkgs.grim}/bin/grim ~/screenshots/Screenshot-$(date +%Y-%m-%d-%H-%M-%S).png
  '';

  screenshot-area = pkgs.writeShellScript "screenshot-area" ''
    mkdir -p ~/screenshots
    ${pkgs.grim}/bin/grim -g "$(${pkgs.slurp}/bin/slurp)" ~/screenshots/Screenshot-$(date +%Y-%m-%d-%H-%M-%S).png
  '';
in
{
  stylix.targets.hyprland.enable = false;

  home.packages = with pkgs; [
    grim
    slurp
    foot
  ];

  wayland.windowManager.hyprland = {
    enable = true;

    settings = {
      monitor = [
        "DP-1, 3840x2160@144, 0x0, 1.5"
        "DP-2, 3840x2160@144, 2560x0, 1.5"
      ];

      env = [
        "MOZ_ENABLE_WAYLAND,1"
        "MOZ_DBUS_REMOTE,1"
        "MOZ_GTK_TITLEBAR_DECORATION,client"
        "LANG,C.UTF-8"
        "NO_AT_BRIDGE,1"
      ];

      exec-once = [
        "${pkgs.swaybg}/bin/swaybg -i ${../niri/wallpapers/996764.jpg}"
        "wl-paste --watch cliphist store"
        "noctalia-shell"
      ];

      input = {
        kb_layout = "us";
        kb_variant = "altgr-intl";
        follow_mouse = 1;
      };

      general = {
        gaps_in = 8;
        gaps_out = 16;
        border_size = 2;
        "col.active_border" = "rgba(ffffffff)";
        "col.inactive_border" = "rgba(${lib.removePrefix "#" c.base02}ff)";
        layout = "dwindle";
      };

      decoration = {
        rounding = 0;
        active_opacity = 1.0;
        inactive_opacity = 1.0;
      };

      animations = {
        enabled = true;
        bezier = [
          "easeOutExpo, 0.16, 1, 0.3, 1"
          "easeOutQuad, 0.25, 0.46, 0.45, 0.94"
        ];
        animation = [
          "windows, 1, 3, easeOutExpo, slide"
          "windowsOut, 1, 2, easeOutQuad, slide"
          "border, 1, 10, default"
          "fade, 1, 4, easeOutQuad"
          "workspaces, 1, 4, easeOutExpo, slide"
        ];
      };

      dwindle = {
        pseudotile = true;
        preserve_split = true;
      };

      misc = {
        disable_hyprland_logo = true;
        disable_splash_rendering = true;
        force_default_wallpaper = 0;
      };

      windowrulev2 = [
        "float, class:^(launcher)$"
        "float, class:^(mpv)$"
        "float, class:^(swayimg)$"
        "float, class:^([Tt]hunar)$, title:^(File Operation Progress)"
        "float, class:^([Tt]hunar)$, title:^(Rename)"
      ];

      bind = [
        # --- Lanzadores ---
        "SUPER, Return, exec, ghostty"
        "SUPER, E, exec, rofi -show drun"
        "SUPER, W, exec, noctalia-shell msg launcher toggle"
        "SUPER, X, exec, foot -a launcher -e fsel -d"
        "SUPER, slash, exec, foot -a launcher -e cliphist-select"
        "SUPER SHIFT, slash, exec, foot -a launcher -e cliphist-delete"
        "SUPER, P, exec, ${powermenu}"

        # --- Ventana / sesión ---
        "SUPER, Q, killactive"
        "SUPER, T, fullscreen, 0"
        "SUPER SHIFT, T, fullscreen, 1"
        "SUPER, F, togglefloating"
        "SUPER, S, exec, ${screenshot}"
        "SUPER SHIFT, S, exec, ${screenshot-area}"
        "SUPER, Escape, exec, rofi -show window"
        "SUPER SHIFT, Q, exit"

        # --- Navegación (J=izq, ;=der, K=workspace anterior, L=workspace siguiente) ---
        "SUPER, J, movefocus, l"
        "SUPER, semicolon, movefocus, r"
        "SUPER, K, workspace, -1"
        "SUPER, L, workspace, +1"
        "SUPER SHIFT, J, movewindow, l"
        "SUPER SHIFT, semicolon, movewindow, r"
        "SUPER SHIFT, K, movetoworkspace, -1"
        "SUPER SHIFT, L, movetoworkspace, +1"

        # --- Monitores ---
        "SUPER CTRL, J, focusmonitor, l"
        "SUPER CTRL, semicolon, focusmonitor, r"
        "SUPER CTRL SHIFT, J, movewindow, mon:l"
        "SUPER CTRL SHIFT, semicolon, movewindow, mon:r"

        # --- Workspaces 1-9 ---
        "SUPER, 1, workspace, 1"
        "SUPER, 2, workspace, 2"
        "SUPER, 3, workspace, 3"
        "SUPER, 4, workspace, 4"
        "SUPER, 5, workspace, 5"
        "SUPER, 6, workspace, 6"
        "SUPER, 7, workspace, 7"
        "SUPER, 8, workspace, 8"
        "SUPER, 9, workspace, 9"
        "SUPER SHIFT, 1, movetoworkspace, 1"
        "SUPER SHIFT, 2, movetoworkspace, 2"
        "SUPER SHIFT, 3, movetoworkspace, 3"
        "SUPER SHIFT, 4, movetoworkspace, 4"
        "SUPER SHIFT, 5, movetoworkspace, 5"
        "SUPER SHIFT, 6, movetoworkspace, 6"
        "SUPER SHIFT, 7, movetoworkspace, 7"
        "SUPER SHIFT, 8, movetoworkspace, 8"
        "SUPER SHIFT, 9, movetoworkspace, 9"

        # --- Audio ---
        ", XF86AudioRaiseVolume, exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%+"
        ", XF86AudioLowerVolume, exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"
        ", XF86AudioMute, exec, wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"
        "SUPER, comma, exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"
        "SUPER, period, exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%+"
        "SUPER, M, exec, wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"
      ];

      # Binds con repeat activado (redimensionado)
      binde = [
        "SUPER, minus, resizeactive, -100 0"
        "SUPER, equal, resizeactive, 100 0"
        "SUPER CTRL, minus, resizeactive, 0 -100"
        "SUPER CTRL, equal, resizeactive, 0 100"
      ];
    };
  };
}
