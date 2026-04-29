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

  # --- SSH ---
  services.openssh = {
    enable = true;
    settings = {
      PasswordAuthentication = false;
      PermitRootLogin        = "no";
    };
  };

  networking.firewall.allowedTCPPorts = [ 22 ];

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
