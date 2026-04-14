{ config, lib, ... }:

let
  cfg = config.misc.bluetooth;
in
{
  options.misc.bluetooth.enable = lib.mkEnableOption "Bluetooth (bluez + blueman)";

  config = lib.mkIf cfg.enable {
    hardware.bluetooth.enable      = true;
    hardware.bluetooth.powerOnBoot = true;
    services.blueman.enable        = true;
  };
}
