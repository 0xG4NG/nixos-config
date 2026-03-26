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
      height = 36;
      spacing = 0;
      exclusive = true;

      modules-left   = [ "niri/workspaces" "niri/window" ];
      modules-center = [ "clock" ];
      modules-right  = [ "network" "disk" "temperature" "cpu" "memory" "pulseaudio" "idle_inhibitor" "tray" ];

      "niri/workspaces" = {
        format = "{icon}";
        format-icons = {
          active  = "";
          default = "";
          urgent  = "";
        };
      };

      "niri/window" = {
        max-length       = 50;
        separate-outputs = true;
        format           = "  {}";
      };

      clock = {
        format     = " {:%H:%M}";
        format-alt = " {:%a %d %b  %H:%M}";
        tooltip-format = "<tt><small>{calendar}</small></tt>";
        calendar = {
          mode          = "month";
          weeks-pos     = "right";
          format = {
            today = "<b><u>{}</u></b>";
          };
        };
      };

      cpu = {
        format   = " {usage}%";
        interval = 3;
        tooltip  = false;
        states = {
          warning  = 70;
          critical = 90;
        };
      };

      memory = {
        format         = " {percentage}%";
        interval       = 5;
        tooltip-format = "RAM: {used:0.1f}G / {total:0.1f}G\nSwap: {swapUsed:0.1f}G / {swapTotal:0.1f}G";
        states = {
          warning  = 75;
          critical = 90;
        };
      };

      temperature = {
        # k10temp para AMD Ryzen — ajusta hwmon-path si es necesario
        hwmon-path     = "/sys/class/hwmon/hwmon2/temp1_input";
        critical-threshold = 85;
        interval       = 5;
        format         = " {temperatureC}°C";
        format-critical = " {temperatureC}°C";
        tooltip        = false;
      };

      network = {
        interval           = 3;
        format-ethernet    = "󰈀 {bandwidthDownBytes}";
        format-wifi        = " {essid}  {bandwidthDownBytes}";
        format-disconnected = "󰈂 sin red";
        tooltip-format-ethernet = "󰈀 {ifname}\n󰁅 {bandwidthDownBytes}  󰁝 {bandwidthUpBytes}";
        tooltip-format-wifi     = " {essid} ({signalStrength}%)\n󰁅 {bandwidthDownBytes}  󰁝 {bandwidthUpBytes}";
        tooltip-format-disconnected = "Sin conexión";
      };

      disk = {
        format         = "󰋊 {percentage_used}%";
        path           = "/";
        interval       = 30;
        tooltip-format = "{path}: {used} / {total}";
        states = {
          warning  = 75;
          critical = 90;
        };
      };

      pulseaudio = {
        format        = "{icon} {volume}%";
        format-muted  = "󰝟 silencio";
        format-icons  = { default = [ "󰕿" "󰖀" "󰕾" ]; };
        on-click      = "wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle";
        on-click-right = "pwvucontrol";
        scroll-step   = 5;
      };

      idle_inhibitor = {
        format = "{icon}";
        format-icons = {
          activated   = "󰅶";
          deactivated = "󰾪";
        };
        tooltip-format-activated   = "Idle inhibitor: activo";
        tooltip-format-deactivated = "Idle inhibitor: inactivo";
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
        transition: background-color 0.2s ease, color 0.2s ease;
      }

      window#waybar {
        background-color: ${c.base00};
        color: ${c.base05};
        border-bottom: 1px solid ${c.base02};
      }

      /* ── Workspaces ─────────────────────────────── */
      #workspaces {
        margin: 5px 4px 5px 8px;
        padding: 0 4px;
        background: ${c.base01};
        border-radius: 12px;
      }

      #workspaces button {
        padding: 0 10px;
        color: ${c.base03};
        background: transparent;
        border-radius: 10px;
        min-height: 26px;
      }

      #workspaces button.active {
        color: ${c.base0E};
        background: ${c.base02};
      }

      #workspaces button.urgent {
        color: ${c.base08};
        background: ${c.base01};
      }

      #workspaces button:hover {
        background: ${c.base02};
        color: ${c.base05};
      }

      /* ── Window title ───────────────────────────── */
      #window {
        margin: 5px 4px;
        padding: 0 14px;
        color: ${c.base04};
        background: ${c.base01};
        border-radius: 12px;
      }

      /* ── Clock (center) ─────────────────────────── */
      #clock {
        margin: 5px 4px;
        padding: 0 20px;
        color: ${c.base07};
        background: ${c.base01};
        border-radius: 12px;
        font-weight: bold;
        letter-spacing: 0.5px;
      }

      /* ── Right modules base ─────────────────────── */
      #network,
      #disk,
      #temperature,
      #cpu,
      #memory,
      #pulseaudio,
      #idle-inhibitor,
      #tray {
        margin: 5px 2px;
        padding: 0 12px;
        background: ${c.base01};
        border-radius: 12px;
      }

      /* ── Network ────────────────────────────────── */
      #network {
        color: ${c.base0B};
      }

      #network.disconnected {
        color: ${c.base03};
      }

      /* ── Disk ───────────────────────────────────── */
      #disk {
        color: ${c.base0F};
      }

      #disk.warning { color: ${c.base0A}; }
      #disk.critical { color: ${c.base08}; }

      /* ── Temperature ────────────────────────────── */
      #temperature {
        color: ${c.base09};
      }

      #temperature.critical {
        color: ${c.base08};
        animation: blink 1s steps(1) infinite;
      }

      /* ── CPU ────────────────────────────────────── */
      #cpu {
        color: ${c.base0D};
      }

      #cpu.warning  { color: ${c.base0A}; }
      #cpu.critical { color: ${c.base08}; }

      /* ── Memory ─────────────────────────────────── */
      #memory {
        color: ${c.base0C};
      }

      #memory.warning  { color: ${c.base0A}; }
      #memory.critical { color: ${c.base08}; }

      /* ── Audio ──────────────────────────────────── */
      #pulseaudio {
        color: ${c.base0A};
      }

      #pulseaudio.muted {
        color: ${c.base03};
      }

      /* ── Idle inhibitor ─────────────────────────── */
      #idle-inhibitor {
        color: ${c.base03};
        padding: 0 14px;
      }

      #idle-inhibitor.activated {
        color: ${c.base0E};
      }

      /* ── Tray ───────────────────────────────────── */
      #tray {
        padding: 0 10px;
        margin-right: 4px;
      }

      #tray > .passive {
        -gtk-icon-effect: dim;
      }

      #tray > .needs-attention {
        -gtk-icon-effect: highlight;
        background-color: ${c.base08};
        border-radius: 12px;
      }

      /* ── Blink animation ────────────────────────── */
      @keyframes blink {
        50% { color: ${c.base08}; background: ${c.base01}; }
      }
    '';
  };
}
