{ config, lib, pkgs, ... }:

let
  cfg = config.misc.orca-slicer;

  # Orca-Slicer en Wayland tiene problemas con WebKit/dmabuf y portales,
  # así que forzamos backend X11 y deshabilitamos los problemáticos.
  orca-slicer-wrapped = pkgs.symlinkJoin {
    name = "orca-slicer";
    paths = [ pkgs.orca-slicer ];
    buildInputs = [ pkgs.makeWrapper ];
    postBuild = ''
      wrapProgram $out/bin/orca-slicer \
        --set GDK_BACKEND x11 \
        --set QT_QPA_PLATFORM xcb \
        --set WEBKIT_DISABLE_DMABUF_RENDERER 1 \
        --set GTK_USE_PORTAL 0 \
        --prefix GST_PLUGIN_SYSTEM_PATH_1_0 : "${pkgs.gst_all_1.gst-plugins-base}/lib/gstreamer-1.0" \
        --prefix GST_PLUGIN_SYSTEM_PATH_1_0 : "${pkgs.gst_all_1.gst-plugins-good}/lib/gstreamer-1.0" \
        --prefix XDG_DATA_DIRS : "${pkgs.gsettings-desktop-schemas}/share" \
        --prefix XDG_DATA_DIRS : "${pkgs.gtk3}/share"
    '';
  };
in {
  options.misc.orca-slicer.enable = lib.mkEnableOption "Orca Slicer (con wrapper X11)";

  config = lib.mkIf cfg.enable {
    environment.systemPackages = [ orca-slicer-wrapped ];
  };
}
