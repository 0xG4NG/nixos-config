{ config, lib, pkgs, ... }:

let
  cfg = config.misc.gaming;
in
{
  options.misc.gaming = {
    enable = lib.mkEnableOption "Gaming (Steam, Gamescope, GameMode, libs 32-bit)";
  };

  config = lib.mkIf cfg.enable {
    programs.steam = {
      enable                       = true;
      gamescopeSession.enable      = true;
      platformOptimizations.enable = true;
    };

    security.unprivilegedUsernsClone = true;

    programs.gamescope = {
      enable     = true;
      capSysNice = true;
    };

    programs.gamemode.enable = true;
    hardware.graphics = {
      enable      = true;
      enable32Bit = true;
    };
  };
}
