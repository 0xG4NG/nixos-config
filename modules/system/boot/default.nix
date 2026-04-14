{ config, lib, ... }:

let
  cfg = config.misc.boot-systemd;
in
{
  options.misc.boot-systemd = {
    enable = lib.mkEnableOption "Arranque con systemd-boot + EFI";

    configurationLimit = lib.mkOption {
      type        = lib.types.int;
      default     = 10;
      description = "Número máximo de generaciones en el menú.";
    };

    timeout = lib.mkOption {
      type        = lib.types.int;
      default     = 5;
      description = "Timeout del menú en segundos.";
    };
  };

  config = lib.mkIf cfg.enable {
    boot.loader.systemd-boot.enable             = true;
    boot.loader.systemd-boot.configurationLimit = cfg.configurationLimit;
    boot.loader.timeout                         = cfg.timeout;
    boot.loader.efi.canTouchEfiVariables        = true;
  };
}
