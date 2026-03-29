{ ... }:

{
  imports = [
    ../git.nix
    ../../../modules/dots/zsh
    ../../../modules/dots/nvf
    ../../../modules/dots/fastfetch
    ../../../modules/dots/cava
    ../../../modules/dots/cmatrix
  ];

  home.username      = "g4ng";
  home.homeDirectory = "/home/g4ng";
  home.stateVersion  = "25.11";

  programs.home-manager.enable = true;
}
