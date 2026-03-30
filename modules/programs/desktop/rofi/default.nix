{ config, pkgs, lib, ... }:
let
  c    = config.lib.stylix.colors.withHashtag;
  font = config.stylix.fonts.monospace.name;
  inherit (config.lib.formats.rasi) mkLiteral;
in
{
  stylix.targets.rofi.enable = false;

  programs.rofi = {
    enable   = true;
    package  = pkgs.rofi;
    terminal = "ghostty";
    font     = lib.mkForce "${font} 13";

    extraConfig = {
      modi              = "drun,run";
      icon-theme        = "Papirus-Dark";
      show-icons        = true;
      drun-display-format = "{name}";
      disable-history   = false;
      hide-scrollbar    = true;
      display-drun      = "  Apps";
      display-run       = "  Run";
      sidebar-mode      = false;
    };

    theme = {
      "*" = {
        bg      = mkLiteral c.base00;
        bg-alt  = mkLiteral c.base01;
        fg      = mkLiteral c.base05;
        fg-alt  = mkLiteral c.base04;
        accent  = mkLiteral c.base0E;

        background-color = mkLiteral "transparent";
        text-color       = mkLiteral "@fg";
      };

      "window" = {
        width            = mkLiteral "500px";
        background-color = mkLiteral "@bg";
        border           = mkLiteral "2px solid";
        border-color     = mkLiteral "@accent";
        border-radius    = mkLiteral "8px";
        padding          = mkLiteral "8px";
      };

      "mainbox" = {
        background-color = mkLiteral "transparent";
        spacing          = mkLiteral "8px";
      };

      "inputbar" = {
        background-color = mkLiteral "@bg-alt";
        border-radius    = mkLiteral "4px";
        padding          = mkLiteral "8px 12px";
      };

      "entry" = {
        background-color  = mkLiteral "transparent";
        text-color        = mkLiteral "@fg";
        placeholder-color = mkLiteral "@fg-alt";
        placeholder       = "Search...";
        vertical-align    = mkLiteral "0.5";
      };

      "listview" = {
        background-color = mkLiteral "transparent";
        lines            = mkLiteral "8";
        scrollbar        = false;
        spacing          = mkLiteral "4px";
      };

      "element" = {
        background-color = mkLiteral "transparent";
        border-radius    = mkLiteral "4px";
        padding          = mkLiteral "8px 12px";
        spacing          = mkLiteral "12px";
      };

      "element selected" = {
        background-color = mkLiteral "@bg-alt";
        text-color       = mkLiteral "@accent";
      };

      "element-icon" = {
        size           = mkLiteral "24px";
        vertical-align = mkLiteral "0.5";
      };

      "element-text" = {
        vertical-align = mkLiteral "0.5";
        text-color     = mkLiteral "inherit";
      };
    };
  };
}
