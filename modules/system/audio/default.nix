{ config, lib, ... }:

let
  cfg = config.misc.audio;
in
{
  options.misc.audio = {
    enable = lib.mkEnableOption "Pipewire con soporte ALSA/Pulse/JACK y rtkit";

    lowLatency = lib.mkOption {
      type        = lib.types.bool;
      default     = true;
      description = "Activa el módulo de baja latencia de nix-gaming.";
    };
  };

  config = lib.mkIf cfg.enable {
    security.rtkit.enable = true;

    services.pipewire = {
      enable            = true;
      alsa.enable       = true;
      alsa.support32Bit = true;
      pulse.enable      = true;
      jack.enable       = true;
      lowLatency.enable = cfg.lowLatency;
    };
  };
}
