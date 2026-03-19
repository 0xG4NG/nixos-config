{ pkgs, inputs, ... }:

{
  imports = [
    ./hardware-configuration.nix
    ./disk.nix
    ../../users/g4ng
    ../../modules/davinci-resolve
    ../../modules/stylix
    ../../modules/misc/ryzen-undervolting
  ];

  boot.loader.systemd-boot.enable             = true;
  boot.loader.systemd-boot.configurationLimit = 10;
  boot.loader.timeout                         = 15;
  boot.loader.efi.canTouchEfiVariables        = true;
  boot.initrd.kernelModules                   = [ "amdgpu" ];

  services.displayManager.sddm.enable  = true;
  services.xserver.enable              = true;
  services.xserver.videoDrivers        = [ "amdgpu" ];

  networking.hostName                = "toledo";
  networking.networkmanager.enable   = true;
  networking.interfaces.enp13s0 = {
    useDHCP = false;
    ipv4.addresses = [{
      address      = "192.168.1.120";
      prefixLength = 24;
    }];
  };
  networking.defaultGateway = "192.168.1.1";
  networking.nameservers    = [ "192.168.1.104" ];

  console.keyMap        = "us-acentos";
  i18n.defaultLocale    = "es_ES.UTF-8";
  i18n.supportedLocales = [
    "en_US.UTF-8/UTF-8"
    "es_ES.UTF-8/UTF-8"
  ];

  environment.systemPackages = with pkgs; [
    claude-code
    btop-rocm
    bitwarden-cli
    papirus-icon-theme
    xwayland-satellite
    mako
    fuzzel
    kdePackages.polkit-kde-agent-1
    inputs.noctalia.packages.${pkgs.stdenv.hostPlatform.system}.default
    sunshine
    ffmpeg
  ];

  security.rtkit.enable = true;
  services.pipewire = {
    enable            = true;
    alsa.enable       = true;
    alsa.support32Bit = true;
    pulse.enable      = true;
    jack.enable       = true;
  };

  programs.steam.enable   = true;
  programs.firefox.enable = true;
  programs.niri.enable    = true;

  xdg.portal = {
    enable       = true;
    extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
  };

  services.gnome.gnome-keyring.enable           = true;
  security.pam.services.sddm.enableGnomeKeyring = true;

  programs.nix-ld.enable    = true;
  programs.nix-ld.libraries = with pkgs; [
    stdenv.cc.cc.lib
    zlib
    openssl
    curl
    glib
  ];

  misc.ryzen-undervolting.enable = true;

  home-manager = {
    useGlobalPkgs       = false;
    useUserPackages     = false;
    backupFileExtension = "backup";
    users.g4ng.imports  = [ ../../users/g4ng/dots.nix ];
  };

  system.stateVersion = "25.11";
}
