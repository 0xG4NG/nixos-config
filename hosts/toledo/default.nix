{ pkgs, inputs, lib, config, ... }:

{
  imports = [
    ./hardware-configuration.nix
    ./disk.nix
    ../../users/g4ng
    ../../modules/davinci-resolve
    ../../modules/stylix
    ../../modules/misc/syncthing
    ../../modules/sddm
  ];

  boot.loader.systemd-boot.enable             = true;
  boot.loader.systemd-boot.configurationLimit = 10;
  boot.loader.timeout                         = 15;
  boot.loader.efi.canTouchEfiVariables        = true;
  boot.initrd.kernelModules                   = [ "amdgpu" ];

  services.xserver.enable              = true;
  services.xserver.videoDrivers        = [ "amdgpu" ];

  sops.defaultSopsFile = ../../secrets/toledo.yaml;
  sops.age.keyFile     = "/etc/age/keys.txt";

  sops.secrets.git_email = {};

  sops.templates.gitconfig = {
    content = ''
      [user]
        email = ${config.sops.placeholder.git_email}
    '';
    path  = "/run/secrets/gitconfig";
    owner = "g4ng";
    mode  = "0400";
  };

  systemd.tmpfiles.rules = [
    "z /etc/age/keys.txt 0600 root root -"
  ];

  networking.hostName = "toledo";
  networking.useDHCP = false;
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

  hardware.i2c.enable = true;

  hardware.bluetooth.enable      = true;
  hardware.bluetooth.powerOnBoot = true;
  services.blueman.enable        = true;

  environment.systemPackages = with pkgs; [
    inputs.nix-gaming.packages.${pkgs.stdenv.hostPlatform.system}.mo2installer
    ddcutil
    claude-code
    btop-rocm
    bitwarden-cli
    papirus-icon-theme
    xwayland-satellite
    mako
    kdePackages.polkit-kde-agent-1
    sunshine
    ffmpeg
    (pkgs.symlinkJoin {
      name = "orca-slicer";
      paths = [ pkgs.orca-slicer ];
      buildInputs = [ pkgs.makeWrapper ];
      postBuild = ''
        wrapProgram $out/bin/orca-slicer \
          --set MESA_LOADER_DRIVER_OVERRIDE zink
      '';
    })
    bitwarden-desktop
    obsidian
    vesktop
    unzip
    ilspycmd
    bottles
    distrobox
    obs-studio
    heroic
    xfce.thunar
    xfce.thunar-volman
    xfce.tumbler
    gvfs
  ];

  security.rtkit.enable = true;
  services.pipewire = {
    enable            = true;
    alsa.enable       = true;
    alsa.support32Bit = true;
    pulse.enable      = true;
    jack.enable       = true;
    lowLatency.enable = true;
  };

  programs.steam.enable   = true;
  programs.firefox.enable = true;
  programs.niri.enable    = true;

  services.flatpak.enable = true;
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

  nix.settings = {
    substituters = ["https://nix-gaming.cachix.org"];
    trusted-public-keys = ["nix-gaming.cachix.org-1:nbjlureqMbRAxR1gJ/f3hxemL9svXaZF/Ees8vCUUs4="];
  };

  programs.steam.platformOptimizations.enable = true;

  virtualisation.podman.enable = true;

  virtualisation.libvirtd = {
    enable = true;
    qemu.swtpm.enable = true;  # TPM virtual (útil para Windows 11)
  };
  programs.virt-manager.enable = true;
  users.users.g4ng.extraGroups = [ "libvirtd" ];

  misc.syncthing = {
    enable  = true;
    role    = "client";
    user    = "g4ng";
    dataDir = "/home/g4ng";
    overrideDevices = true;
    overrideFolders = false;
    devices = {
      proxmox = {
        id                = "ZDR47VZ-J2FNFSV-7XX6KQY-6EJDS6C-GA6XS4G-VBJH6XD-D4U27LT-X7CXRQX";
        autoAcceptFolders = false;
      };
    };
    folders = {
      "uzyxu-holdf" = {
        path    = "/home/g4ng/Documents/";
        devices = [ "proxmox" ];
        type    = "sendreceive";
      };
    };
  };

  # Sunshine game streaming
  networking.firewall.allowedTCPPorts = [ 47984 47989 48010 ];
  networking.firewall.allowedUDPPorts = [ 47998 47999 48000 48002 ];

  powerManagement.cpuFreqGovernor = "schedutil";

  home-manager = {
    useGlobalPkgs       = true;
    useUserPackages     = false;
    backupFileExtension = "backup";
    users.g4ng.imports  = [
      ../../users/g4ng/dots/common.nix
      ../../users/g4ng/dots/desktop.nix
    ];
  };
  
  system.stateVersion = "25.11";
}
