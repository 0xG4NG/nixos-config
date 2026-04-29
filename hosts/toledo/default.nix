{ pkgs, inputs, config, ... }:

{
  imports = [
    ./hardware-configuration.nix
    ./disk.nix
    ../../users/g4ng
    ../../modules/programs/media/davinci-resolve
    ../../modules/theming/stylix
    ../../modules/services/syncthing
../../modules/programs/desktop/sddm
    ../../modules/programs/desktop/bitwarden
    ../../modules/programs/keyboard/qmk
    ../../modules/programs/gaming
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

  boot.initrd.kernelModules = [ "amdgpu" ];

  services.xserver.enable       = true;
  services.xserver.videoDrivers = [ "amdgpu" ];

  services.openssh = {
    enable        = true;
    openFirewall  = false; # no exponer SSH externamente
    settings.PasswordAuthentication = false;
  };

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

  networking.hostName = "toledo";
  networking.networkmanager.enable = true;

  hardware.i2c.enable = true;

  environment.systemPackages = with pkgs; [
    inputs.nix-gaming.packages.${pkgs.stdenv.hostPlatform.system}.mo2installer
    ddcutil
    claude-code
    btop-rocm
    papirus-icon-theme
    xwayland-satellite
    kdePackages.polkit-kde-agent-1
    sunshine
    ffmpeg
    (pkgs.symlinkJoin {
      name = "orca-slicer";
      paths = [ pkgs.orca-slicer ];
      buildInputs = [ pkgs.makeWrapper ];
      postBuild = ''
        wrapProgram $out/bin/orca-slicer \
          --set GDK_BACKEND x11 \
          --set QT_QPA_PLATFORM xcb \
          --set WEBKIT_DISABLE_DMABUF_RENDERER 1 \
          --set GTK_USE_PORTAL 0 \
          --prefix GST_PLUGIN_SYSTEM_PATH_1_0 : "${pkgs.gst_all_1.gst-plugins-base}/lib/gstreamer-1.0" \
          --prefix GST_PLUGIN_SYSTEM_PATH_1_0 : "${pkgs.gst_all_1.gst-plugins-good}/lib/gstreamer-1.0" \
          --prefix XDG_DATA_DIRS : "${pkgs.gsettings-desktop-schemas}/share" \
          --prefix XDG_DATA_DIRS : "${pkgs.gtk3}/share"
      '';
    })
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
    stremio-linux-shell
    tor-browser
    darktable
    chromium
    (pkgs.symlinkJoin {
      name = "vial";
      paths = [ pkgs.vial ];
      buildInputs = [ pkgs.makeWrapper ];
      postBuild = ''
        wrapProgram $out/bin/Vial \
          --set QT_SCALE_FACTOR 2
      '';
    })
  ];

  misc.gaming.enable = true;

  programs.firefox.enable = true;
  programs.niri.enable    = true;

  hardware.keyboard.qmk.enable = true;

  hardware.qmk = {
    enable = true;
    users  = [ "g4ng" ];
    devices = [
      { name = "TBK Mini Splinky"; vid = "a8f8"; pid = "1828"; }
    ];
  };

  hardware.tbk-mini.enable = true;

  # Tor: servicio de red + Tor Browser
  services.tor = {
    enable = true;
    client.enable = true;  # SOCKS5 proxy en 127.0.0.1:9050
  };

  services.flatpak.enable = true;

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

  virtualisation.podman.enable = true;

  virtualisation.libvirtd = {
    enable = true;
    qemu.swtpm.enable = true;  # TPM virtual (útil para Windows 11)
  };
  programs.virt-manager.enable = true;
  users.users.g4ng.extraGroups = [ "libvirtd" "networkmanager" "wheel" ];

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
