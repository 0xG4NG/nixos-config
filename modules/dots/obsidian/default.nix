{ pkgs, ... }:

{
  stylix.targets.obsidian.enable = true;

  home.packages = [ pkgs.obsidian ];
}
