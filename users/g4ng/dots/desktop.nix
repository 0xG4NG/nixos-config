{ pkgs, ... }:

{
  imports = [
    ../../../modules/dots/ghostty
    ../../../modules/dots/niri
    ../../../modules/dots/waybar
    ../../../modules/dots/rofi
    ../../../modules/dots/firefox
    ../../../modules/dots/vscode
  ];

  gtk.iconTheme = {
    package = pkgs.papirus-icon-theme;
    name    = "Papirus-Dark";
  };
}
