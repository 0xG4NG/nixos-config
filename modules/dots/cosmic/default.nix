{ ... }:

{
  wayland.desktopManager.cosmic = {
    enable = true;

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
