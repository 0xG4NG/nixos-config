{ config, lib, ... }:

let
  cfg = config.misc.locale-es;
in
{
  options.misc.locale-es = {
    enable = lib.mkEnableOption "Locale es_ES.UTF-8 con zona horaria y teclado configurables";

    timeZone = lib.mkOption {
      type    = lib.types.str;
      default = "Europe/Madrid";
    };

    keyboard = {
      layout = lib.mkOption {
        type    = lib.types.str;
        default = "es";
      };
      variant = lib.mkOption {
        type    = lib.types.str;
        default = "";
      };
    };
  };

  config = lib.mkIf cfg.enable {
    time.timeZone = cfg.timeZone;

    services.xserver.xkb = {
      layout  = cfg.keyboard.layout;
      variant = cfg.keyboard.variant;
    };

    # La consola hereda la misma distribución que XKB
    console.useXkbConfig = true;

    i18n.defaultLocale = "es_ES.UTF-8";
    i18n.supportedLocales = [
      "en_US.UTF-8/UTF-8"
      "es_ES.UTF-8/UTF-8"
    ];
  };
}
