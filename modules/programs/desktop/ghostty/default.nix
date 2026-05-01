{ pkgs, ... }:

{
  programs.ghostty = {
    enable = true;
    package = pkgs.ghostty;
    settings = {
      window-decoration = "none";
      window-padding-balance = true;
      window-padding-x = 15;
      working-directory = "/home/g4ng/nixos-config";
      font-size = 16;
      font-thicken = true;
      font-thicken-strength = 120;
      cursor-style = "block";
      shell-integration-features = "no-cursor";
      keybind = [
        "global:cmd+shift+space=toggle_quick_terminal"
        "ctrl+equal=increase_font_size:1"
        "ctrl+minus=decrease_font_size:1"
        "ctrl+zero=reset_font_size"
        "ctrl+period=increase_font_size:1"
        "ctrl+comma=decrease_font_size:1"
      ];
    };
  };
}
