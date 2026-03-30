{ config, ... }:

{
  imports = [
    ../git.nix
    ../../../modules/programs/cli/zsh
    ../../../modules/programs/cli/nvf
    ../../../modules/programs/cli/fastfetch
    ../../../modules/programs/cli/cava
    ../../../modules/programs/cli/cmatrix
  ];

  home.username      = "g4ng";
  home.homeDirectory = "/home/g4ng";
  home.stateVersion  = "25.11";

  programs.home-manager.enable = true;

  gtk.gtk4.theme = config.gtk.theme;
}
