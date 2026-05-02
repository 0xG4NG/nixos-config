{ pkgs, ... }:

{
  imports = [
    ../../../modules/programs/desktop/ghostty
    ../../../modules/programs/desktop/niri
    ../../../modules/programs/desktop/waybar
    ../../../modules/programs/desktop/swaync
    ../../../modules/programs/desktop/rofi
    ../../../modules/programs/desktop/cosmic
    ../../../modules/programs/browser/firefox
    ../../../modules/programs/desktop/vscode
    ../../../modules/programs/media/mpv
    ../../../modules/programs/media/imv
    ../../../modules/theming/qt
  ];

  misc.ghostty.enable = true;
  misc.swaync.enable  = true;
  misc.rofi.enable    = true;

  gtk.iconTheme = {
    package = pkgs.papirus-icon-theme;
    name    = "Papirus-Dark";
  };
}
