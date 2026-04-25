{ ... }:

{
  imports = [
    ./disk.nix
    ../../users/g4ng
    # nvf (neovim) está configurado con theme.name = "base16", así que necesita
    # los colores base16 que provee stylix aunque el servidor sea headless.
    ../../modules/theming/stylix
  ];

  # --- Módulos compartidos ---
  # El servidor es headless: sin audio, sin bluetooth, sin desktop-base.
  misc.locale-es.enable = true;
  misc.boot-systemd = {
    enable  = true;
    timeout = 3;
  };

  # --- Red ---
  # Ajusta la interfaz con: ip link (ej: enp3s0, eno1, eth0...)
  networking.hostName    = "servidor";
  networking.useDHCP     = false;
  networking.interfaces."enp6s0" = {
    useDHCP = false;
    ipv4.addresses = [{
      address      = "192.168.1.100";
      prefixLength = 24;
    }];
  };
  networking.defaultGateway = "192.168.1.1";
  networking.nameservers    = [ "192.168.1.104" "8.8.8.8" ];

  # --- SSH ---
  services.openssh = {
    enable = true;
    settings = {
      PasswordAuthentication = false;
      PermitRootLogin        = "no";
    };
  };

  # --- Firewall ---
  networking.firewall = {
    enable          = true;
    allowedTCPPorts = [ 22 ];
  };

  # --- Secretos ---
  # g4ng_password se gestiona en users/g4ng/default.nix via age.secrets


  # --- Home Manager (solo herramientas de terminal) ---
  home-manager = {
    useGlobalPkgs        = true;
    useUserPackages      = false;
    backupFileExtension  = "backup";
    users.g4ng.imports   = [ ../../users/g4ng/dots/common.nix ];
  };

  system.stateVersion = "25.11";
}
