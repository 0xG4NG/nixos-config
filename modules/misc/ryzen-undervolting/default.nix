{ config, lib, pkgs, ... }:

let
  cfg = config.misc.ryzen-undervolting;
in
{
  options.misc.ryzen-undervolting = {
    enable = lib.mkEnableOption "Ryzen power limit tuning via ryzenadj";

    stapLimit = lib.mkOption {
      type        = lib.types.int;
      default     = 65000;
      description = "Sustained Power Average Limit en mW (STAPM). Controla el TDP sostenido.";
    };

    fastLimit = lib.mkOption {
      type        = lib.types.int;
      default     = 88000;
      description = "Fast PPT Limit en mW. TDP máximo en bursts cortos.";
    };

    slowLimit = lib.mkOption {
      type        = lib.types.int;
      default     = 65000;
      description = "Slow PPT Limit en mW. TDP sostenido a largo plazo.";
    };

    tctlTemp = lib.mkOption {
      type        = lib.types.int;
      default     = 85;
      description = "Thermal Control temperature limit en °C.";
    };
  };

  config = lib.mkIf cfg.enable {
    assertions = [
      {
        assertion = cfg.tctlTemp <= 95;
        message   = "tctlTemp no debe superar 95°C para proteger el procesador.";
      }
    ];

    # ryzenadj necesita acceso al módulo MSR
    boot.kernelModules = [ "msr" ];

    systemd.services.ryzen-undervolting = {
      description = "Ryzen power limit tuning (ryzenadj)";
      wantedBy    = [ "multi-user.target" ];
      after       = [ "multi-user.target" ];
      serviceConfig = {
        Type            = "oneshot";
        RemainAfterExit = true;
        ExecStart       = lib.concatStringsSep " " [
          "${pkgs.ryzenadj}/bin/ryzenadj"
          "--stapm-limit=${toString cfg.stapLimit}"
          "--fast-limit=${toString cfg.fastLimit}"
          "--slow-limit=${toString cfg.slowLimit}"
          "--tctl-temp=${toString cfg.tctlTemp}"
        ];
      };
    };
  };
}
