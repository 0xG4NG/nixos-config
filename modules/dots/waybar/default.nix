{ config, ... }:
let
  c = config.lib.stylix.colors.withHashtag;
  font = config.stylix.fonts.sansSerif.name;
in
{
  programs.waybar = {
    enable = true;
    settings = [{
      layer = "top";
      position = "top";
      height = 30;
      spacing = 0;
      exclusive = true;

      modules-left   = [ "niri/workspaces" "niri/window" ];
      modules-center = [ "clock" ];
      modules-right  = [ "network" "temperature" "cpu" "memory" "pulseaudio" "tray" ];

      "niri/workspaces" = {
        format = "{id}";
      };

      "niri/window" = {
        max-length       = 60;
        separate-outputs = true;
        format           = "{}";
      };

      clock = {
        format     = "{:%H:%M}";
        format-alt = "{:%a %d %b  %H:%M}";
        tooltip    = false;
      };

      cpu = {
        format   = "cpu {usage}%";
        interval = 3;
        tooltip  = false;
        states = {
          warning  = 70;
          critical = 90;
        };
      };

      memory = {
        format   = "mem {percentage}%";
        interval = 5;
        tooltip  = false;
        states = {
          warning  = 75;
          critical = 90;
        };
      };

      temperature = {
        hwmon-path         = "/sys/class/hwmon/hwmon2/temp1_input";
        critical-threshold = 85;
        interval           = 5;
        format             = "{temperatureC}°";
        format-critical    = "{temperatureC}°";
        tooltip            = false;
      };

      network = {
        interval            = 3;
        format-ethernet     = "{bandwidthDownBytes}";
        format-wifi         = "{essid} {bandwidthDownBytes}";
        format-disconnected = "no red";
        tooltip             = false;
      };

      pulseaudio = {
        format        = "vol {volume}%";
        format-muted  = "mute";
        format-icons  = { default = [ "" "" "" ]; };
        on-click      = "wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle";
        on-click-right = "pwvucontrol";
        scroll-step   = 5;
        tooltip        = false;
      };

      tray = {
        spacing   = 8;
        icon-size = 16;
      };
    }];

    style = ''
      * {
        font-family: "${font}", sans-serif;
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
        border-bottom: 1px solid ${c.base02};
      }

      /* ── Workspaces ─────────────────────────────── */
      #workspaces {
        margin-left: 12px;
      }

      #workspaces button {
        padding: 0 8px;
        color: ${c.base03};
        background: transparent;
        min-height: 30px;
      }

      #workspaces button.active {
        color: ${c.base07};
      }

      #workspaces button.urgent {
        color: ${c.base08};
      }

      #workspaces button:hover {
        background: transparent;
        color: ${c.base05};
        box-shadow: none;
      }

      /* ── Window title ───────────────────────────── */
      #window {
        padding: 0 12px;
        color: ${c.base04};
      }

      /* ── Clock ──────────────────────────────────── */
      #clock {
        color: ${c.base07};
        font-weight: bold;
      }

      /* ── Right modules ──────────────────────────── */
      #network,
      #temperature,
      #cpu,
      #memory,
      #pulseaudio {
        padding: 0 10px;
        color: ${c.base04};
      }

      #network.disconnected { color: ${c.base03}; }

      #temperature.critical { color: ${c.base08}; }
      #cpu.warning          { color: ${c.base0A}; }
      #cpu.critical         { color: ${c.base08}; }
      #memory.warning       { color: ${c.base0A}; }
      #memory.critical      { color: ${c.base08}; }
      #pulseaudio.muted     { color: ${c.base03}; }

      /* ── Tray ───────────────────────────────────── */
      #tray {
        padding: 0 10px 0 0;
      }

      #tray > .passive {
        -gtk-icon-effect: dim;
      }

      #tray > .needs-attention {
        -gtk-icon-effect: highlight;
      }
    '';
  };
}
