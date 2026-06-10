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
    services.sunshine = {
      enable             = true;
      capSysAdmin        = true;   # cap_sys_admin via security wrapper (KMS capture)
      openFirewall       = cfg.openFirewall;
    };
  };
}
