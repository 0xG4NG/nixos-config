{ pkgs, config, ... }:


{
  stylix = {
    enable = true;
    autoEnable = true;
    image = ./wallpapers/wallhaven-839g92.png;
    base16Scheme = {
      base00 = "#202020";
      base01 = "#212121";
      base02 = "#222222";
      base03 = "#333333";
      base04 = "#999999";
      base05 = "#c1c1c1";
      base06 = "#999999";
      base07 = "#c1c1c1";
      base08 = "#5f8787";
      base09 = "#aaaaaa";
      base0A = "#e78a53";
      base0B = "#fbcb97";
      base0C = "#aaaaaa";
      base0D = "#888888";
      base0E = "#fbcb97";
      base0F = "#444444";
    };
    polarity = "dark";

    fonts = {
      monospace = {
        package = pkgs.nerd-fonts.jetbrains-mono;
        name = "JetBrainsMono Nerd Font Mono";
      };
      sansSerif = {
        package = pkgs.dejavu_fonts;
        name = "DejaVu Sans";
      };
      serif = {
        package = pkgs.dejavu_fonts;
        name = "DejaVu Serif";
      };
      sizes = {
        terminal = 16;
        applications = 12;
        desktop = 12;
      };
    };

    cursor = {
      package = pkgs.bibata-cursors;
      name = "Bibata-Modern-Classic";
      size = 24;
    };
  };
}
