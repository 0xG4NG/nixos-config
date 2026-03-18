{ pkgs, ... }:

{
  imports = [
    ../../modules/dots/ghostty
    ../../modules/dots/tmux
    ../../modules/dots/niri
    ../../modules/dots/noctalia
    ./git.nix
  ];

  home.username = "g4ng";
  home.homeDirectory = "/home/g4ng";
  home.stateVersion = "25.11";

  programs.home-manager.enable = true;
}
