{ pkgs, ... }:

{
  home.packages = [ pkgs.fastfetch ];

  xdg.configFile."fastfetch/config.jsonc".text = builtins.toJSON {
    "$schema" = "https://github.com/fastfetch-cli/fastfetch/raw/dev/doc/json_schema.json";

    logo = {
      type = "builtin";
      source = "nixos";
      color = {
        "1" = "#c1c1c1";
        "2" = "#fbcb97";
        "3" = "#c1c1c1";
        "4" = "#fbcb97";
        "5" = "#c1c1c1";
        "6" = "#fbcb97";

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
