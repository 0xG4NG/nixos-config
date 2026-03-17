{ config, pkgs, lib, ... }:

{
  imports = [
    ./hardware-configuration.nix
    ../../modules/desktop
  ];

  # Boot
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # Networking
  networking.hostName = "toledo";
  networking.networkmanager.enable = true;

  # Locale
  console.keyMap = "us-acentos";
  i18n.defaultLocale = "es_ES.UTF-8";
  i18n.supportedLocales = [
    "en_US.UTF-8/UTF-8"
    "es_ES.UTF-8/UTF-8"
  ];

  # Users
  users.users.g4ng = {
    isNormalUser = true;
    description = "g4ng";
    extraGroups = [ "networkmanager" "wheel" ];
  };

  # Paquetes específicos de Toledo
  environment.systemPackages = with pkgs; [
    vscode
    claude-code
    btop-rocm
    bitwarden-cli
    papirus-icon-theme
  ];


  # Steam
  programs.steam.enable = true;

  programs.firefox.enable = true;

  # nix-ld (para binarios dinámicos)
  programs.nix-ld.enable = true;
  programs.nix-ld.libraries = with pkgs; [
    stdenv.cc.cc.lib
    zlib
    openssl
    curl
    glib
  ];

  # Home Manager
  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    users.g4ng = import ../../users/g4ng/home.nix;
  };

  system.stateVersion = "25.11";
}
