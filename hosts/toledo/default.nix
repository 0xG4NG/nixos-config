{ pkgs, inputs, config, ... }:

{
  imports = [
    ./hardware-configuration.nix
    ./disk.nix
    ../../users/g4ng
    ../../modules/programs/media/davinci-resolve
    ../../modules/theming/stylix
    ../../modules/services/syncthing
    ../../modules/services/sunshine
    ../../modules/programs/desktop/sddm
    ../../modules/programs/desktop/bitwarden
    ../../modules/programs/desktop/file-manager
    ../../modules/programs/desktop/orca-slicer
    ../../modules/programs/keyboard/qmk
    ../../modules/programs/keyboard/vial
    ../../modules/programs/gaming
    ../../modules/programs/gaming/ddo.nix
    ../../modules/programs/gaming/heroic.nix
    ../../modules/programs/browser/tor-browser
    ../../modules/programs/virtualisation
    ../../modules/hardware/ddcutil
  ];

  # --- Paquetes unfree permitidos ---
  misc.allowUnfreeNames = [
    "claude-code"
    "corefonts"
    "davinci-resolve"
    "davinci-resolve-studio"
    "obsidian"
    "steam"
    "steam-original"
    "steam-run"
    "steam-unwrapped"
    "steamcmd"
    "ttf-mscorefonts-installer"
    "vesktop"
    "vial"
    "vscode"
  ];

  # --- Módulos del sistema compartidos ---
  misc.audio.enable        = true;
  misc.bluetooth.enable    = true;
  misc.desktop-base.enable = true;
  misc.locale-es.enable    = true;
  misc.boot-systemd = {
    enable             = true;
    configurationLimit = 10;
    timeout            = 15;
  };

  # --- Módulos opt-in ---
  misc.gaming.enable        = true;
  misc.heroic.enable        = true;
  misc.ddo = {
    enable   = true;
    gamePath = "/home/g4ng/juegos/Dragon's Dogma Online 16.04.2025/ddo_launcher.exe";
  };
  misc.ddcutil.enable       = true;
  misc.file-manager.enable  = true;
  misc.orca-slicer.enable   = true;
  misc.sunshine.enable      = true;
  misc.tor-browser.enable   = true;
  misc.vial.enable          = true;
  misc.virtualisation = {
    enable = true;
    user   = "g4ng";
  };

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

  # --- Hardware / drivers ---
  boot.initrd.kernelModules = [ "amdgpu" ];

  services.xserver.enable       = true;
  services.xserver.videoDrivers = [ "amdgpu" ];

  hardware.keyboard.qmk.enable = true;
  hardware.qmk = {
    enable = true;
    users  = [ "g4ng" ];
    devices = [
      { name = "TBK Mini Splinky"; vid = "a8f8"; pid = "1828"; }
    ];
  };
  hardware.tbk-mini.enable = true;

  powerManagement.cpuFreqGovernor = "schedutil";

  # --- Servicios ---
  services.openssh = {
    enable        = true;
    openFirewall  = false; # no exponer SSH externamente
    settings.PasswordAuthentication = false;
  };

  services.flatpak.enable = true;

  # --- Secretos ---
  age.secrets.git_email = {
    file  = ../../secrets/git_email.age;
    owner = "g4ng";
  };

  system.activationScripts.gitconfig = {
    text = ''
      mkdir -p /run/secrets
      printf '[user]\n  email = %s\n' "$(cat ${config.age.secrets.git_email.path})" \
        > /run/secrets/gitconfig
      chown g4ng:users /run/secrets/gitconfig
      chmod 0400 /run/secrets/gitconfig
    '';
    deps = [ "agenix" ];
  };

  # --- Programas del sistema ---
  programs.firefox.enable = true;
  programs.niri.enable    = true;

  programs.nix-ld.enable    = true;
  programs.nix-ld.libraries = with pkgs; [
    stdenv.cc.cc.lib
    zlib
    openssl
    curl
    glib
  ];

  nix.settings = {
    substituters       = [ "https://nix-gaming.cachix.org" ];
    trusted-public-keys = [ "nix-gaming.cachix.org-1:nbjlureqMbRAxR1gJ/f3hxemL9svXaZF/Ees8vCUUs4=" ];
  };

  # --- Paquetes sueltos ---
  # Apps simples sin configuración propia. Si alguno crece (wrappers, env vars,
  # firewall…), pásalo a su propio módulo en modules/programs/.
  environment.systemPackages = with pkgs; [
    # Utilidades de sistema y deploy
    nixos-anywhere
    inputs.agenix.packages.${pkgs.stdenv.hostPlatform.system}.default
    btop-rocm
    unzip
    ffmpeg

    # Desktop / sesión
    papirus-icon-theme
    xwayland-satellite
    kdePackages.polkit-kde-agent-1

    # Apps
    obsidian
    vesktop
    chromium
    darktable
    obs-studio

    # Dev
    claude-code
    distrobox
    ilspycmd

    # Gaming auxiliar
    inputs.nix-gaming.packages.${pkgs.stdenv.hostPlatform.system}.mo2installer
  ];

  # --- Home Manager ---
  home-manager = {
    useGlobalPkgs       = true;
    useUserPackages     = true;
    backupFileExtension = "backup";
    users.g4ng.imports  = [
      ../../users/g4ng/dots/common.nix
      ../../users/g4ng/dots/desktop.nix
    ];
  };

  system.stateVersion = "25.11";
}
