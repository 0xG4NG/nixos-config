{ pkgs, lib, ... }:

{
  services.displayManager.sddm = {
    enable = true;
    wayland.enable = false;
    # Plasma 6 también define este package; forzamos el nuestro (tema astronaut).
    package = lib.mkForce pkgs.kdePackages.sddm;
    extraPackages = with pkgs; [
      kdePackages.qtsvg
      kdePackages.qtmultimedia
      sddm-astronaut
    ];
    theme = "sddm-astronaut-theme";
  };
}
