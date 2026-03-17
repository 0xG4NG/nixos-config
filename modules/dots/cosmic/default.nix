{ ... }:

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
    };

    appearance.theme.light = {
      is_frosted = true;
      active_hint = 2;
    };
  };
}
