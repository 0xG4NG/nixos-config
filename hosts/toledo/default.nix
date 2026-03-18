{ pkgs, inputs, ... }:

{
  imports = [
    ./hardware-configuration.nix
  ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.systemd-boot.configurationLimit = 10;
  boot.loader.timeout = 15;
  boot.loader.efi.canTouchEfiVariables = true;

  services.displayManager.sddm.enable = true;
  services.xserver.enable = true;
  #services.displayManager.sddm.wayland.enable = true;
  #services.xserver.videoDrivers = [ "amdgpu" ];

  networking.hostName = "toledo";
  networking.networkmanager.enable = true;

  console.keyMap = "us-acentos";
  i18n.defaultLocale = "es_ES.UTF-8";
  i18n.supportedLocales = [
    "en_US.UTF-8/UTF-8"
    "es_ES.UTF-8/UTF-8"
  ];

  users.users.g4ng = {
    isNormalUser = true;
    description = "g4ng";
    extraGroups = [ "networkmanager" "wheel" ];
  };

  environment.systemPackages = with pkgs; [
    vscode
    claude-code
    btop-rocm
    bitwarden-cli
    papirus-icon-theme
    xwayland-satellite
    mako
    fuzzel
    kdePackages.polkit-kde-agent-1
    inputs.noctalia.packages.${pkgs.stdenv.hostPlatform.system}.default
  ];

  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    jack.enable = true;
  };

  programs.steam.enable = true;
  programs.firefox.enable = true;
  programs.niri.enable = true;

  xdg.portal = {
    enable = true;
    extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
  };

  services.gnome.gnome-keyring.enable = true;

  programs.nix-ld.enable = true;
  programs.nix-ld.libraries = with pkgs; [
    stdenv.cc.cc.lib
    zlib
    openssl
    curl
    glib
  ];

  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    users.g4ng = import ../../users/g4ng/home.nix;
  };

  system.stateVersion = "25.11";
}
