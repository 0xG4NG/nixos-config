{ pkgs, ... }:

{
  nix.settings.trusted-users = [ "g4ng" ];

  users = {
    users.g4ng = {
      uid          = 1000;
      isNormalUser = true;
      shell        = pkgs.bash;
      extraGroups  = [ "wheel" "networkmanager" "video" "render" "input" ];
      group        = "g4ng";
    };
    groups.g4ng = {
      gid = 1000;
    };
  };

  programs.zsh.enable = true;
}
