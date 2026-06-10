{ config, lib, pkgs, ... }:

let cfg = config.misc.kde;
in {
  options.misc.kde.enable =
    lib.mkEnableOption "Escritorio KDE Plasma 6 (sesión Wayland seleccionable en SDDM)";

  config = lib.mkIf cfg.enable {
    # Plasma 6 convive con otras sesiones (niri); SDDM ofrece ambas al iniciar.
    services.desktopManager.plasma6.enable = true;

    # Quita algunas apps por defecto de Plasma que no queremos.
    environment.plasma6.excludePackages = with pkgs.kdePackages; [
      elisa
      khelpcenter
    ];
  };
}
