{ cosmicLib, ... }:

{
  wayland.desktopManager.cosmic = {
    enable = true;

    applets.time.settings = {
      first_day_of_week = 1;
      military_time = true;
      show_date_in_top_panel = true;
      show_seconds = false;
      show_weekday = true;
    };

    appearance.theme.dark = {
      is_frosted = true;
      active_hint = 2;
      gaps = cosmicLib.cosmic.mkRON "tuple" [ 4 4  ];
      accent = cosmicLib.cosmic.mkRON "optional" {
        red   = 0.92;
        green = 0.93;
        blue  = 0.95;
      };
    };

    appearance.toolkit = {
      apply_theme_global = false;
      icon_theme = "Papirus-Dark";

    };

    compositor = {

      active_hint = true;
      autotile = true;
      autotile_behavior = cosmicLib.cosmic.mkRON "enum" "Global";
      cursor_follows_focus = false;
      descale_xwayland = false;
      edge_snap_threshold = 0;
      focus_follows_cursor = false;
      focus_follows_cursor_delay = 250;
      workspaces = {
        workspace_layout = cosmicLib.cosmic.mkRON "enum" "Horizontal";
        workspace_mode = cosmicLib.cosmic.mkRON "enum" "OutputBound";

      };
    };

    appearance.theme.light = {
      is_frosted = true;
      active_hint = 2;
    };
  };
}
