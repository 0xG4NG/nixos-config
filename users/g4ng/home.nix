{ pkgs, ... }:

{
  imports = [
    ../../modules/dots/ghostty
    ../../modules/dots/tmux
    ../../modules/dots/cosmic
    ./git.nix
  ];

  home.username = "g4ng";
  home.homeDirectory = "/home/g4ng";
  home.stateVersion = "25.11";

  programs.home-manager.enable = true;
}
