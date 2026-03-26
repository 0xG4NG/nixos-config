{ pkgs, ... }:

{
  programs.ghostty = {
    enable = true;
    package = pkgs.ghostty;
    settings = {
      window-decoration = "none";
      window-theme = "system";
      window-padding-balance = true;
      window-padding-x = 15;
      font-size = 16;
font-thicken = true;
      font-thicken-strength = 120;
      keybind = [
        "global:cmd+shift+space=toggle_quick_terminal"
      ];
    };
  };
}
