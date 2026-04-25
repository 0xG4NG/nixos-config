{ pkgs, config, ... }:

{
  nix.settings.trusted-users = [ "g4ng" ];

  age.secrets.g4ng_password = {
    file = ./../../secrets/g4ng_password.age;
  };

  # El script de activación "agenix" (a < u) corre antes de "users" por orden
  # topológico, así que hashedPasswordFile puede leer /run/agenix/g4ng_password.

  users = {
    mutableUsers = false;
    users.g4ng = {
      uid          = 1000;
      isNormalUser = true;
      shell        = pkgs.zsh;
      extraGroups  = [ "wheel" "networkmanager" "video" "render" "input" ];
      group               = "g4ng";
      hashedPasswordFile  = config.age.secrets.g4ng_password.path;
      openssh.authorizedKeys.keys = [
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIH+ktRXEN5IJwRBS+kA6K6T/FSHcO1pcXlz2TRaQQtCN"
      ];
    };
    groups.g4ng = {
      gid = 1000;
    };
    users.root.hashedPassword = "!";
  };
}
