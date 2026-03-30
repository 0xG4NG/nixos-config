{ pkgs, inputs, config, ... }:

{
  imports = [
    ./disk.nix
    ../../users/g4ng
    ../../modules/theming/stylix
  ];

  # --- Boot ---
  boot.loader.systemd-boot.enable             = true;
  boot.loader.systemd-boot.configurationLimit = 10;
  boot.loader.timeout                         = 15;
  boot.loader.efi.canTouchEfiVariables        = true;

  # --- NVIDIA ---
  services.xserver.videoDrivers = [ "nvidia" ];

  hardware.nvidia = {
    modesetting.enable     = true;
    open                   = false;
    nvidiaSettings         = true;
    powerManagement.enable = true;   # suspend/resume estable
  };

  # El Omen 15 tiene gráficos híbridos Intel+NVIDIA (Optimus).
  # Rellena los bus IDs con: lspci | grep -E "VGA|3D"
  # hardware.nvidia.prime = {
  #   offload.enable           = true;
  #   offload.enableOffloadCmd = true;
  #   intelBusId  = "PCI:0:2:0";  # lspci | grep -E "VGA|3D"
  #   nvidiaBusId = "PCI:1:0:0";
  # };

  hardware.graphics.enable = true;

  # --- Display ---
  services.displayManager.sddm.enable = true;
  services.xserver.enable             = true;

  # --- Red (WiFi + cable via NetworkManager) ---
  networking.hostName              = "laptop";
  networking.networkmanager.enable = true;

  # --- Secrets ---
  sops.defaultSopsFile = ../../secrets/laptop.yaml;
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

  # --- Locale ---
  console.keyMap        = "us-acentos";
  i18n.defaultLocale    = "es_ES.UTF-8";
  i18n.supportedLocales = [
    "en_US.UTF-8/UTF-8"
    "es_ES.UTF-8/UTF-8"
  ];

  # --- Audio ---
  security.rtkit.enable = true;
  services.pipewire = {
    enable            = true;
    alsa.enable       = true;
    alsa.support32Bit = true;
    pulse.enable      = true;
    jack.enable       = true;
    lowLatency.enable = true;
  };

  # --- Bluetooth ---
  hardware.bluetooth.enable      = true;
  hardware.bluetooth.powerOnBoot = true;
  services.blueman.enable        = true;

  # --- Batería ---
  services.power-profiles-daemon.enable = true;

  # --- Portales y escritorio ---
  programs.niri.enable = true;

  xdg.portal = {
    enable       = true;
    extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
  };

  services.gnome.gnome-keyring.enable           = true;
  security.pam.services.sddm.enableGnomeKeyring = true;

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
    useUserPackages     = false;
    backupFileExtension = "backup";
    users.g4ng.imports  = [
      ../../users/g4ng/dots/common.nix
      ../../users/g4ng/dots/desktop.nix
    ];
  };

  system.stateVersion = "25.11";
}
