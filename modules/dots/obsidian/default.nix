{ pkgs, ... }:

{
  nixpkgs.config.allowUnfree = true;
  stylix.targets.obsidian.enable = true;
  home.packages = [ pkgs.obsidian ];
}
