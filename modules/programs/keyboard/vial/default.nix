{ config, lib, pkgs, ... }:

let
  cfg = config.misc.vial;

  vial-hidpi = pkgs.symlinkJoin {
    name = "vial";
    paths = [ pkgs.vial ];
    buildInputs = [ pkgs.makeWrapper ];
    postBuild = ''
      wrapProgram $out/bin/Vial \
        --set QT_SCALE_FACTOR ${toString cfg.qtScaleFactor}
    '';
  };
in {
  options.misc.vial = {
    enable = lib.mkEnableOption "Vial (configurador QMK con UI)";

    qtScaleFactor = lib.mkOption {
      type        = lib.types.int;
      default     = 2;
      description = "Factor de escala Qt — útil en pantallas HiDPI.";
    };
  };

  config = lib.mkIf cfg.enable {
    environment.systemPackages = [ vial-hidpi ];
  };
}
