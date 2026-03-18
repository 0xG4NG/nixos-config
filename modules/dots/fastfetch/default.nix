{ pkgs, ... }:

{
  home.packages = [ pkgs.fastfetch ];

  xdg.configFile."fastfetch/config.jsonc".text = builtins.toJSON {
    "$schema" = "https://github.com/fastfetch-cli/fastfetch/raw/dev/doc/json_schema.json";

    logo = {
      type = "builtin";
      source = "nixos";
      color = {
        "1" = "white";
        "2" = "white";
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
