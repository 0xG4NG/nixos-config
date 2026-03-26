{ pkgs, ... }:

{
  imports = [
    ./git.nix
    ../../modules/dots/zsh
    ../../modules/dots/ghostty
    ../../modules/dots/niri
    ../../modules/dots/waybar
    ../../modules/dots/rofi
    ../../modules/dots/fastfetch
    ../../modules/dots/zen-browser
    ../../modules/dots/nvf
    ../../modules/dots/vscode
  ];

  home.username = "g4ng";
  home.homeDirectory = "/home/g4ng";
  home.stateVersion = "25.11";

  programs.home-manager.enable = true;
}
