{ ... }:

{
  imports = [
    ./disk.nix
    ../../users/g4ng
    ../../modules/theming/stylix
  ];

  # --- Boot ---
  boot.loader.systemd-boot.enable      = true;
  boot.loader.efi.canTouchEfiVariables = true;

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
  sops.defaultSopsFile = ../../secrets/servidor.yaml;
  sops.age.keyFile     = "/etc/age/keys.txt";


  # --- Home Manager (solo herramientas de terminal) ---
  home-manager = {
    useGlobalPkgs        = true;
    useUserPackages      = false;
    backupFileExtension  = "backup";
    users.g4ng.imports   = [ ../../users/g4ng/dots/common.nix ];
  };

  # --- Locale ---
  time.timeZone      = "Europe/Madrid";
  i18n.defaultLocale = "es_ES.UTF-8";

  system.stateVersion = "25.11";
}
