{ config, lib, pkgs, ... }:

let cfg = config.misc.tor-browser;
in {
  options.misc.tor-browser = {
    enable = lib.mkEnableOption "Tor Browser + servicio tor (SOCKS5 local)";

    enableTorService = lib.mkOption {
      type        = lib.types.bool;
      default     = true;
      description = "Levantar el servicio tor con cliente SOCKS5 en 127.0.0.1:9050.";
    };
  };

  config = lib.mkIf cfg.enable {
    environment.systemPackages = [ pkgs.tor-browser ];

    services.tor = lib.mkIf cfg.enableTorService {
      enable        = true;
      client.enable = true;
    };
  };
}
