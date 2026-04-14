{ pkgs, ... }:

{
  imports = [
    ./disk.nix
    ../../users/g4ng
    ../../modules/theming/stylix
  ];

  # --- Módulos compartidos ---
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
  # Por ahora el laptop solo usa secrets/common.yaml (hashedPassword del usuario).
  # Cuando tenga su propia clave age en .sops.yaml se puede añadir secrets/laptop.yaml
  # con git_email y recrear la plantilla de gitconfig como en toledo.
  sops.defaultSopsFile = ../../secrets/common.yaml;
  sops.age.keyFile     = "/etc/age/keys.txt";

  systemd.tmpfiles.rules = [
    "z /etc/age/keys.txt 0600 root root -"
  ];

  # --- Batería ---
  services.power-profiles-daemon.enable = true;

  # --- Escritorio ---
  programs.niri.enable = true;

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
