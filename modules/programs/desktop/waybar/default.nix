{ pkgs, ... }:

{
  programs.waybar = {
    enable = true;
    settings = [{
      layer = "top";
      position = "top";
      height = 32;
      spacing = 4;

      modules-left = [ "niri/workspaces" ];
      modules-center = [ "niri/window" ];
      modules-right = [ "pulseaudio" "cpu" "memory" "clock" "tray" ];

      "niri/workspaces" = {
        format = "{name}";
      };

      "niri/window" = {
        format = "{title}";
        max-length = 60;
      };

      "clock" = {
        format = "{:%H:%M}";
        format-alt = "{:%Y-%m-%d}";
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
    }];
  };
}
