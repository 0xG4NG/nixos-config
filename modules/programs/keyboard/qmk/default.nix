{ config, lib, pkgs, ... }:

let
  cfg = config.hardware.qmk;

  deviceRules = lib.concatMapStrings (dev: ''
    # ${dev.name}
    KERNEL=="hidraw*", ATTRS{idVendor}=="${dev.vid}", ATTRS{idProduct}=="${dev.pid}", TAG+="uaccess", GROUP="plugdev", MODE="0660"
    SUBSYSTEM=="usb",  ATTRS{idVendor}=="${dev.vid}", ATTRS{idProduct}=="${dev.pid}", TAG+="uaccess", GROUP="plugdev", MODE="0664"
  '') cfg.devices;
in
{
  options.hardware.qmk = {
    enable = lib.mkEnableOption "QMK firmware tooling";

    users = lib.mkOption {
      type        = lib.types.listOf lib.types.str;
      default     = [];
      description = "Usuarios con acceso para compilar y flashear firmware QMK (se añaden al grupo plugdev).";
    };

    devices = lib.mkOption {
      default     = [];
      description = "Teclados QMK con VID/PID específicos para udev (necesario para WebHID en Chromium/VIA).";
      type        = lib.types.listOf (lib.types.submodule {
        options = {
          name = lib.mkOption {
            type        = lib.types.str;
            description = "Nombre descriptivo del teclado.";
          };
          vid = lib.mkOption {
            type        = lib.types.str;
            description = "Vendor ID en hex minúscula sin 0x (ej: 6b65).";
          };
          pid = lib.mkOption {
            type        = lib.types.str;
            description = "Product ID en hex minúscula sin 0x (ej: 1828).";
          };
        };
      });
    };
  };

  config = lib.mkIf cfg.enable {
    # Paquete qmk + udev rules genéricas para dispositivos QMK (Pro Micro, Elite-C, RP2040…)
    environment.systemPackages = [ pkgs.qmk ];
    services.udev.packages     = [ pkgs.qmk ];

    # Udev rules específicas por VID/PID: necesarias para que WebHID (VIA) funcione en Chromium
    services.udev.extraRules = lib.mkIf (cfg.devices != []) deviceRules;

    # Crea el grupo plugdev y añade cada usuario
    users.groups.plugdev = {};
    users.users = lib.genAttrs cfg.users (_: {
      extraGroups = [ "plugdev" ];
    });
  };
}
