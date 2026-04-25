{ config, lib, pkgs, ... }:

let
  cfg        = config.hardware.tbk-mini;
  mkFirmware = import ./nix/firmware.nix { keymapSrc = ./keymap; };
  mkFlash    = import ./nix/flash.nix;
  firmware   = mkFirmware { inherit pkgs; };
  flash      = mkFlash { inherit pkgs firmware; };
in

{
  options.hardware.tbk-mini = {
    enable = lib.mkEnableOption "Firmware Vial personalizado para TBK Mini (Splinky v3)";
  };

  config = lib.mkIf cfg.enable {
    environment.systemPackages = [ firmware flash ];
  };
}
