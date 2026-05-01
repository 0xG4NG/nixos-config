{ pkgs, lib, ... }:

{
  home.packages = [ pkgs.imv ];

  xdg.configFile."imv/config".text = ''
    [options]
    background = 000000
    suppress_default_binds = false
  '';

  xdg.mimeApps.enable = lib.mkDefault true;
  xdg.mimeApps.defaultApplications = {
    "image/jpeg"    = "imv.desktop";
    "image/png"     = "imv.desktop";
    "image/gif"     = "imv.desktop";
    "image/webp"    = "imv.desktop";
    "image/avif"    = "imv.desktop";
    "image/jxl"     = "imv.desktop";
    "image/bmp"     = "imv.desktop";
    "image/tiff"    = "imv.desktop";
    "image/svg+xml" = "imv.desktop";
  };
}
