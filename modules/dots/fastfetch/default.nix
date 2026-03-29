{ pkgs, config, ... }:

let
  c = config.lib.stylix.colors.withHashtag;
in
{
  home.packages = [ pkgs.fastfetch ];

  xdg.configFile."fastfetch/config.jsonc".text = builtins.toJSON {
    "$schema" = "https://github.com/fastfetch-cli/fastfetch/raw/dev/doc/json_schema.json";

    logo = {
      type = "builtin";
      source = "nixos";
      color = {
        "1" = c.base0E;
        "2" = c.base0D;
        "3" = c.base0B;
        "4" = c.base0A;
        "5" = c.base09;
        "6" = c.base08;
      };
    };

    modules = [
      "title"
      "separator"
      "os"
      "kernel"
      "uptime"
      "packages"
      "shell"
      "terminal"
      "wm"
      "display"
      "separator"
      "cpu"
      "gpu"
      "memory"
      "disk"
      "separator"
      "colors"
    ];
  };
}
