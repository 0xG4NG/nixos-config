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
      theme = "Catppuccin Mocha";
      font-size = 16;
      font-family = "Comic Code Ligatures";
      adjust-cell-height = "50%";
      font-thicken = true;
      font-thicken-strength = 120;
      command = "/etc/profiles/per-user/g4ng/bin/tmux";
      keybind = [
        "global:cmd+shift+space=toggle_quick_terminal"
      ];
    };
  };
}
