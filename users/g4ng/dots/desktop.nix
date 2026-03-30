{ pkgs, ... }:

{
  imports = [
    ../../../modules/programs/desktop/ghostty
    ../../../modules/programs/desktop/niri
    ../../../modules/programs/desktop/waybar
    ../../../modules/programs/desktop/rofi
    ../../../modules/programs/browser/firefox
    ../../../modules/programs/desktop/vscode
  ];

  gtk.iconTheme = {
    package = pkgs.papirus-icon-theme;
    name    = "Papirus-Dark";
  };

}
