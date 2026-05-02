{ config, lib, pkgs, ... }:

let cfg = config.misc.sunshine;
in {
  options.misc.sunshine = {
    enable = lib.mkEnableOption "Sunshine game streaming";

    openFirewall = lib.mkOption {
      type        = lib.types.bool;
      default     = true;
      description = "Abrir los puertos TCP/UDP que usa Moonlight para conectarse.";
    };
  };

  config = lib.mkIf cfg.enable {
    environment.systemPackages = [ pkgs.sunshine ];

    networking.firewall = lib.mkIf cfg.openFirewall {
      allowedTCPPorts = [ 47984 47989 48010 ];
      allowedUDPPorts = [ 47998 47999 48000 48002 ];
    };
  };
}
