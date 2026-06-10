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

  # KDE/portales reescriben mimeapps.list en runtime, rompiendo el symlink de HM.
  # Forzamos la sobreescritura para que la activación no falle por el backup previo.
  xdg.configFile."mimeapps.list".force = true;

  # nixpkgs no registra el esquema lycheeslicer:// — necesario para el callback OAuth.
  xdg.dataFile."applications/lycheeslicer-url-handler.desktop".text = ''
    [Desktop Entry]
    Name=LycheeSlicer URL Handler
    Exec=lycheeslicer %u
    Type=Application
    NoDisplay=true
    MimeType=x-scheme-handler/lycheeslicer;
  '';

  xdg.mimeApps.defaultApplications."x-scheme-handler/lycheeslicer" =
    "lycheeslicer-url-handler.desktop";

  gtk.iconTheme = {
    package = pkgs.papirus-icon-theme;
    name    = "Papirus-Dark";
  };
}
