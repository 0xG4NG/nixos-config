{ pkgs, ... }:

{
  nix.settings.trusted-users = [ "g4ng" ];

  users = {
    users.g4ng = {
      uid          = 1000;
      isNormalUser = true;
      shell        = pkgs.zsh;
      extraGroups  = [ "wheel" "networkmanager" "video" "render" "input" ];
      group        = "g4ng";
      openssh.authorizedKeys.keys = [
        # Pega aquí tu clave pública: cat ~/.ssh/id_ed25519.pub
        # "ssh-ed25519 AAAA... g4ng@toledo"
      ];
    };
    groups.g4ng = {
      gid = 1000;
    };
  };
}
