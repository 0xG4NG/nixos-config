{ config, ... }:
let
  c    = config.lib.stylix.colors.withHashtag;
  font = config.stylix.fonts.sansSerif.name;
in
{
  programs.waybar = {
    enable = true;
    settings = [{
      layer    = "top";
      position = "top";
      height   = 36;
      exclusive = true;

      modules-left   = [ "niri/workspaces" "niri/window" ];
      modules-center = [ "clock" ];
      modules-right  = [ "network" "temperature" "cpu" "memory" "pulseaudio" "tray" "clock" ];

      # ── Workspaces ────────────────────────────────────────────────
      "niri/workspaces" = {
        format         = "{index}";
        active-only    = false;
        on-scroll-up   = "niri msg action focus-workspace-up";
        on-scroll-down = "niri msg action focus-workspace-down";
      };

      # ── Window title ──────────────────────────────────────────────
      "niri/window" = {
        max-length       = 50;
        separate-outputs = true;
        format           = "{}";
        icon             = true;
        icon-size        = 16;
      };

      # ── Clock with calendar tooltip ───────────────────────────────
      clock = {
        format     = "󰥔  {:%a %e %b   %H:%M}";
        format-alt = "{:%Y-%m-%d}";
        tooltip    = false;
      };

      network = {
        interval            = 3;
        format-ethernet     = "󰈀  {bandwidthDownBytes}";
        format-wifi         = "󰤨  {essid}";
        format-disconnected = "󰤭  offline";
        tooltip             = false;
      };

      temperature = {
        hwmon-path         = "/sys/class/hwmon/hwmon2/temp1_input";
        critical-threshold = 85;
        interval           = 5;
        format             = "  {temperatureC}°";
        format-critical    = "  {temperatureC}°";
        tooltip            = false;
      };

      cpu = {
        format     = "  {usage}%";
        format-alt = "  {avg_frequency} GHz";
        interval   = 2;
        tooltip    = false;
        states = {
          warning  = 70;
          critical = 90;
        };
      };

      memory = {
        format     = "󰍛  {percentage}%";
        format-alt = "󰍛  {used:0.1f}/{total:0.1f} G";
        interval   = 5;
        tooltip    = false;
        states = {
          warning  = 75;
          critical = 90;
        };
      };

      pulseaudio = {
        format        = "{icon}  {volume}%";
        format-muted  = "󰖁  {volume}%";
        format-icons  = {
          default    = [ "󰕿" "󰖀" "󰕾" ];
          headphones = "󰋋";
          headset    = "󰋎";
        };
        on-click       = "wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle";
        on-click-right = "pwvucontrol";
        scroll-step    = 2;
        tooltip        = false;
      };

      tray = {
        spacing   = 6;
        icon-size = 16;
      };
    }];

    style = ''
      * {
        font-family: "${font}", monospace;
        font-size: 13px;
        font-weight: 400;
        border: none;
        border-radius: 0;
        min-height: 0;
        padding: 0;
        margin: 0;
        transition: all 0.15s ease;
      }

      window#waybar {
        background-color: alpha(${c.base00}, 0.94);
        color: ${c.base05};
        border-bottom: 1px solid ${c.base02};
      }

      /* ── Separador entre módulos ─────────────────── */
      #workspaces,
      #window,
      #clock,
      #network,
      #temperature,
      #cpu,
      #memory,
      #pulseaudio,
      #tray {
        padding: 0 12px;
        border-right: 1px solid ${c.base02};
      }

      #tray { border-right: none; }

      /* ── Workspaces ─────────────────────────────── */
      #workspaces button {
        padding: 0 8px;
        color: ${c.base03};
        background: transparent;
        border-radius: 0;
        box-shadow: none;
      }

      #workspaces button.active {
        color: ${c.base05};
        font-weight: 600;
        border-bottom: 2px solid ${c.base0D};
      }

      #workspaces button.urgent {
        color: ${c.base08};
      }

      #workspaces button:hover {
        color: ${c.base05};
        background: ${c.base01};
      }

      /* ── Window title ───────────────────────────── */
      #window { color: ${c.base04}; }

      /* ── Clock ──────────────────────────────────── */
      #clock {
        font-weight: 600;
        color: ${c.base07};
      }

      /* ── System modules ─────────────────────────── */
      #network     { color: ${c.base0C}; }
      #temperature { color: ${c.base09}; }
      #cpu         { color: ${c.base0B}; }
      #memory      { color: ${c.base0D}; }
      #pulseaudio  { color: ${c.base0E}; }

      #network.disconnected  { color: ${c.base03}; }
      #temperature.critical  { color: ${c.base08}; }
      #cpu.warning           { color: ${c.base0A}; }
      #cpu.critical          { color: ${c.base08}; }
      #memory.warning        { color: ${c.base0A}; }
      #memory.critical       { color: ${c.base08}; }
      #pulseaudio.muted      { color: ${c.base03}; }

      /* ── Tray ───────────────────────────────────── */
      #tray > .passive        { -gtk-icon-effect: dim; }
      #tray > .needs-attention { -gtk-icon-effect: highlight; }
    '';
  };
}
