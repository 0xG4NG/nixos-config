{ pkgs, ... }:

{
  imports = [
    ../../../modules/programs/desktop/ghostty
    ../../../modules/programs/desktop/niri
    ../../../modules/programs/desktop/noctalia
    ../../../modules/programs/desktop/rofi
    ../../../modules/programs/desktop/cosmic
    ../../../modules/programs/browser/firefox
    ../../../modules/programs/desktop/vscode
  ];

  gtk.iconTheme = {
    package = pkgs.papirus-icon-theme;
    name    = "Papirus-Dark";
  };

}
