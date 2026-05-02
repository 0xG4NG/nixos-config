{ pkgs, config, ... }:


{
  stylix = {
    enable = true;
    autoEnable = true;
    image = ../../programs/desktop/niri/wallpapers/wallhaven-qrgvll.png;
    base16Scheme = {
      base00 = "#1d1d1d";
      base01 = "#282828";
      base02 = "#373737";
      base03 = "#918072";
      base04 = "#bdaead";
      base05 = "#c4cbcf";
      base06 = "#eee7f2";
      base07 = "#fffef9";
      base08 = "#F38BA8"; # red     — variables, errores
      base09 = "#FAB387"; # peach   — constantes, numeros
      base0A = "#F9E2AF"; # yellow  — clases, busqueda
      base0B = "#A6E3A1"; # green   — strings
      base0C = "#94E2D5"; # teal    — soporte, escape
      base0D = "#89B4FA"; # blue    — funciones
      base0E = "#CBA6F7"; # mauve   — keywords
      base0F = "#F2CDCD"; # flamingo
    };
    polarity = "dark";

    opacity = {
      terminal     = 1.0;
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

    targets.qt.enable = false;
  };
}
