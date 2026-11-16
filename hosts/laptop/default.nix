{ config, pkgs, ... }:

{
  imports = [
    ./disko.nix
    ./hardware.nix
    ../../users/g4ng
    ../../modules/theming/stylix
  ];

  age.identityPaths = [ "/etc/ssh/ssh_host_ed25519_key" ];

  # --- Módulos compartidos ---
  misc.allowUnfreeNames = [
    "claude-code"
    "corefonts"
    "nvidia-settings"
    "nvidia-x11"
    "obsidian"
    "steam"
    "steam-original"
    "steam-run"
    "steam-unwrapped"
    "ttf-mscorefonts-installer"
    "vesktop"
    "vscode"
  ];

  misc.audio.enable        = true;
  misc.bluetooth.enable    = true;
  misc.desktop-base.enable = true;
  misc.locale-es.enable    = true;
  misc.boot-systemd = {
    enable             = true;
    configurationLimit = 10;
    timeout            = 15;
  };

  # --- NVIDIA ---
  services.xserver.videoDrivers = [ "nvidia" ];

  hardware.nvidia = {
    package = config.boot.kernelPackages.nvidiaPackages.stable;
    open = true;                       # RTX 3060 (Ampere) → driver abierto, recomendado
    modesetting.enable = true;
    nvidiaSettings = true;
    powerManagement.enable = true;
    powerManagement.finegrained = true; # apaga la 3060 cuando no se usa
    prime = {
      offload.enable = true;
      offload.enableOffloadCmd = true;
      intelBusId  = "PCI:0:2:0";       # 00:02.0 UHD Graphics
      nvidiaBusId = "PCI:1:0:0";       # 01:00.0 RTX 3060
    };
  };

  hardware.graphics.enable = true;

  # --- Batería ---
  services.power-profiles-daemon.enable = true;

  # --- Escritorio ---
  services.displayManager.sddm = {
    enable = true;
    wayland.enable = true;
  };
  services.desktopManager.plasma6.enable = true;

  # --- Paquetes ---
  environment.systemPackages = with pkgs; [
    claude-code
    btop
    papirus-icon-theme
    xwayland-satellite
    mako
    kdePackages.polkit-kde-agent-1
    ffmpeg
    obsidian
    vesktop
    unzip
  ];

  programs.steam.enable   = true;
  programs.firefox.enable = true;

  programs.nix-ld.enable    = true;
  programs.nix-ld.libraries = with pkgs; [
    stdenv.cc.cc.lib
    zlib
    openssl
    curl
    glib
  ];

  virtualisation.podman.enable = true;

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

  system.stateVersion = "26.05";
}
