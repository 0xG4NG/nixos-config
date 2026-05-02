{ config, lib, pkgs, ... }:

let cfg = config.misc.file-manager;
in {
  options.misc.file-manager.enable =
    lib.mkEnableOption "Thunar + thumbnails + montajes automáticos";

  config = lib.mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      thunar
      thunar-volman
      tumbler
      gvfs
    ];
  };
}
