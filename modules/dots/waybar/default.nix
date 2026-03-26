{ config, ... }:
let
  c = config.lib.stylix.colors.withHashtag;
  font = config.stylix.fonts.monospace.name;
in
{
  programs.waybar = {
    enable = true;
    settings = [{
      layer = "top";
      position = "top";
      height = 34;
      spacing = 0;
      exclusive = true;

      modules-left   = [ "niri/workspaces" "niri/window" ];
      modules-center = [ "clock" ];
      modules-right  = [ "cpu" "memory" "pulseaudio" "tray" ];

      "niri/workspaces" = {
        format = "{icon}";
        format-icons = {
          active  = "●";
          default = "○";
        };
      };

      "niri/window" = {
        max-length       = 60;
        separate-outputs = true;
      };

      clock = {
        format     = "  {:%H:%M}";
        format-alt = "  {:%a %d %b %Y}";
        tooltip-format = "<tt><small>{calendar}</small></tt>";
        calendar = {
          mode   = "month";
          format = { today = "<b><u>{}</u></b>"; };
        };
      };

      cpu = {
        format   = "  {usage}%";
        interval = 5;
        tooltip  = false;
      };

      memory = {
        format         = "  {percentage}%";
        interval       = 10;
        tooltip-format = "{used:0.1f}G / {total:0.1f}G";
      };

      pulseaudio = {
        format        = "{icon} {volume}%";
        format-muted  = "󰝟 muted";
        format-icons  = { default = [ "󰕿" "󰖀" "󰕾" ]; };
        on-click      = "wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle";
        scroll-step   = 5;
      };

      tray = {
        spacing   = 8;
        icon-size = 16;
      };
    }];

    style = ''
      * {
        font-family: "${font}";
        font-size: 13px;
        border: none;
        border-radius: 0;
        min-height: 0;
        padding: 0;
        margin: 0;
      }

      window#waybar {
        background-color: ${c.base00};
        color: ${c.base05};
        border-bottom: 2px solid ${c.base02};
      }

      #workspaces {
        padding: 0 4px;
      }

      #workspaces button {
        padding: 0 8px;
        color: ${c.base04};
        background: transparent;
        border-bottom: 2px solid transparent;
        min-height: 34px;
      }

      #workspaces button.active {
        color: ${c.base0E};
        border-bottom: 2px solid ${c.base0E};
      }

      #workspaces button:hover {
        background: ${c.base01};
        color: ${c.base05};
      }

      #window {
        padding: 0 12px;
        color: ${c.base05};
      }

      #clock {
        padding: 0 16px;
        color: ${c.base0B};
        font-weight: bold;
      }

      #cpu {
        padding: 0 12px;
        color: ${c.base0D};
      }

      #memory {
        padding: 0 12px;
        color: ${c.base0C};
      }

      #pulseaudio {
        padding: 0 12px;
        color: ${c.base0A};
      }

      #pulseaudio.muted {
        color: ${c.base04};
      }

      #tray {
        padding: 0 12px;
      }

      #tray > .passive {
        -gtk-icon-effect: dim;
      }

      #tray > .needs-attention {
        -gtk-icon-effect: highlight;
        background-color: ${c.base08};
      }
    '';
  };
}
