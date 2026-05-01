{ pkgs, ... }:

let
  powerMenu = pkgs.writeShellScriptBin "waybar-power-menu" ''
    choices="󰐥  Apagar\n󰜉  Reiniciar\n󰒲  Hibernar\n󰤄  Suspender\n󰗽  Salir"
    choice=$(printf "$choices" | rofi -dmenu -p "Sistema" -i \
      -theme-str 'window { width: 220px; } listview { lines: 5; }')

    case "$choice" in
      *"Apagar")    systemctl poweroff ;;
      *"Reiniciar") systemctl reboot ;;
      *"Hibernar")  systemctl hibernate ;;
      *"Suspender") systemctl suspend ;;
      *"Salir")     niri msg action quit ;;
    esac
  '';
in

{
  home.packages = [ powerMenu ];

  programs.waybar = {
    enable = true;
    settings = [{
      layer = "top";
      position = "top";
      height = 26;
      spacing = 0;
      margin-top = 6;
      margin-left = 8;
      margin-right = 8;

      modules-left = [ "niri/workspaces" ];
      modules-center = [ ];
      modules-right = [ "cpu" "memory" "pulseaudio" "clock" "tray" "custom/power" ];

      "niri/workspaces" = {
        format = "{value}";
      };

      "clock" = {
        format = "{:%a %d, %H:%M}";
        format-alt = "{:%Y-%m-%d %H:%M:%S}";
        tooltip-format = "<big>{:%Y %B}</big>\n<tt><small>{calendar}</small></tt>";
      };

      "cpu" = {
        format = " {usage}%";
        interval = 5;
      };

      "memory" = {
        format = " {}%";
        interval = 5;
      };

      "pulseaudio" = {
        format = "{icon} {volume}%";
        format-muted = " {volume}%";
        format-icons.default = [ "" "" "" ];
        on-click = "wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle";
        scroll-step = 5;
      };

      "tray" = {
        spacing = 8;
      };

      "custom/power" = {
        format = "󰐥";
        on-click = "${powerMenu}/bin/waybar-power-menu";
        tooltip = false;
      };
    }];

    style = ''
      * {
        font-size: 13px;
        font-weight: 500;
        min-height: 0;
      }

      window#waybar {
        border-radius: 12px;
        border: 1px solid alpha(@base02, 0.6);
      }

      #workspaces {
        padding: 0 4px;
      }

      #workspaces button {
        padding: 0 8px;
        margin: 2px;
        color: @base04;
        background: transparent;
        border: none;
        border-bottom: none;
        border-radius: 6px;
        min-width: 18px;
      }

      #workspaces button.active,
      #workspaces button.focused {
        color: @base00;
        background: @base05;
        border-bottom: none;
      }

      #workspaces button:hover {
        background: alpha(@base02, 0.7);
        box-shadow: none;
        text-shadow: none;
      }

      #cpu,
      #memory,
      #pulseaudio,
      #clock,
      #tray {
        padding: 0 8px;
      }

      #clock {
        font-weight: 600;
        padding-right: 12px;
      }

      #custom-power {
        padding: 0 12px 0 8px;
        color: @base08;
        font-size: 15px;
      }

      #custom-power:hover {
        color: @base00;
        background: @base08;
        border-radius: 8px;
      }
    '';
  };
}
