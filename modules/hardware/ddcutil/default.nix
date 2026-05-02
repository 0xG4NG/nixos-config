{ config, lib, pkgs, ... }:

let cfg = config.misc.ddcutil;
in {
  options.misc.ddcutil.enable = lib.mkEnableOption "ddcutil (control DDC/CI sobre I²C)";

  config = lib.mkIf cfg.enable {
    hardware.i2c.enable = true;
    environment.systemPackages = [ pkgs.ddcutil ];
  };
}
