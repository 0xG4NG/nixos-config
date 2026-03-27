{ pkgs, config, ... }:

{
  imports = [
    ./disk.nix
    ../../users/g4ng
  ];

  # --- Boot ---
  boot.loader.systemd-boot.enable      = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "servidor";

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

  # --- Secrets ---
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
