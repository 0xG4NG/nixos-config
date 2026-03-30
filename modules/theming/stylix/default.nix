{ pkgs, config, ... }:


{
  stylix = {
    enable = true;
    autoEnable = true;
    image = ./wallpapers/wallhaven-839g92.png;
    base16Scheme = {
      base00 = "#1d1d1d";
      base01 = "#282828";
      base02 = "#373737";
      base03 = "#918072";
      base04 = "#bdaead";
      base05 = "#c4cbcf";
      base06 = "#eee7f2";
      base07 = "#fffef9";
      base08 = "#f07c82";
      base09 = "#f4a83a";
      base0A = "#f4ce69";
      base0B = "#b2cf87";
      base0C = "#b0d5df";
      base0D = "#8fb2c9";
      base0E = "#be9db9";
      base0F = "#b89485";
    };
    polarity = "dark";

    opacity = {
      terminal     = 0.9;
      applications = 1.0;
    };

    fonts = {
      monospace = {
        package = pkgs.nerd-fonts.iosevka-term;
        name = "IosevkaTerm Nerd Font Mono";
      };
      sansSerif = {
        package = pkgs.nerd-fonts.iosevka;
        name = "Iosevka Nerd Font";
      };
      serif = {
        package = pkgs.nerd-fonts.iosevka;
        name = "Iosevka Nerd Font";
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
