{ config, lib, pkgs, ... }:

let cfg = config.misc.heroic;
in {
  options.misc.heroic.enable =
    lib.mkEnableOption "Heroic Games Launcher (Epic/GOG/Amazon)";

  config = lib.mkIf cfg.enable {
    environment.systemPackages = [ pkgs.heroic ];
  };
}
