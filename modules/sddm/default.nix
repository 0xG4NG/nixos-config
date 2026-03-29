{ pkgs, ... }:

{
  services.displayManager.sddm = {
    enable = true;
    wayland.enable = false;
    package = pkgs.kdePackages.sddm;
    extraPackages = with pkgs; [
      kdePackages.qtsvg
      kdePackages.qtmultimedia
      kdePackages.qtvirtualkeyboard
      sddm-astronaut
    ];
    theme = "sddm-astronaut-theme";
  };
}
