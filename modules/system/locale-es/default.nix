{ config, lib, ... }:

let
  cfg = config.misc.locale-es;
in
{
  options.misc.locale-es = {
    enable = lib.mkEnableOption "Locale es_ES.UTF-8 con teclado us-acentos";

    timeZone = lib.mkOption {
      type        = lib.types.str;
      default     = "Europe/Madrid";
      description = "Zona horaria del sistema.";
    };
  };

  config = lib.mkIf cfg.enable {
    time.timeZone = cfg.timeZone;

    console.keyMap     = "us-acentos";
    i18n.defaultLocale = "es_ES.UTF-8";
    i18n.supportedLocales = [
      "en_US.UTF-8/UTF-8"
      "es_ES.UTF-8/UTF-8"
    ];
  };
}
