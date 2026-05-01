{ lib, ... }:

{
  programs.mpv = {
    enable = true;
    config = {
      profile               = "high-quality";
      vo                    = "gpu-next";
      hwdec                 = "auto-safe";
      keep-open             = "yes";
      save-position-on-quit = true;
      osc                   = true;
      cursor-autohide       = 800;
    };
  };

  xdg.mimeApps.enable = lib.mkDefault true;
  xdg.mimeApps.defaultApplications = {
    "video/mp4"        = "mpv.desktop";
    "video/x-matroska" = "mpv.desktop";
    "video/webm"       = "mpv.desktop";
    "video/quicktime"  = "mpv.desktop";
    "video/x-msvideo"  = "mpv.desktop";
    "video/x-flv"      = "mpv.desktop";
    "video/mpeg"       = "mpv.desktop";
    "video/x-ms-wmv"   = "mpv.desktop";
    "audio/mpeg"       = "mpv.desktop";
    "audio/flac"       = "mpv.desktop";
    "audio/aac"        = "mpv.desktop";
    "audio/ogg"        = "mpv.desktop";
    "audio/wav"        = "mpv.desktop";
    "audio/opus"       = "mpv.desktop";
  };
}
