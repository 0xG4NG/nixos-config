{ config, lib, pkgs, ... }:

let
  cfg = config.misc.desktop-base;
in
{
  options.misc.desktop-base = {
    enable = lib.mkEnableOption "Base de escritorio Wayland (xdg.portal + gnome-keyring)";

    gnomeKeyring = lib.mkOption {
      type        = lib.types.bool;
      default     = true;
      description = "Activa gnome-keyring y su integración PAM con SDDM.";
    };
  };

  config = lib.mkIf cfg.enable {
    xdg.portal = {
      enable       = true;
      extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
    };

    services.gnome.gnome-keyring.enable           = lib.mkIf cfg.gnomeKeyring true;
    security.pam.services.sddm.enableGnomeKeyring = lib.mkIf cfg.gnomeKeyring true;
  };
}
