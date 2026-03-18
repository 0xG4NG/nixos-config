{ pkgs, ... }:

{
  home.packages = [ pkgs.fastfetch ];

  xdg.configFile."fastfetch/config.jsonc".text = builtins.toJSON {
    "$schema" = "https://github.com/fastfetch-cli/fastfetch/raw/dev/doc/json_schema.json";

    logo = {
      type = "builtin";
      source = "nixos_small";
      color = {
        "1" = "blue";
        "2" = "cyan";
      };
      padding = {
        top = 1;
        left = 2;
        right = 1;
      };
    };

    display = {
      separator = "  ";
      color = {
        keys = "cyan";
        title = "blue";
        separator = "white";
      };
    };

    modules = [
      {
        type = "title";
        format = "{6}{7}{8}";
        color = {
          user = "blue";
          at = "white";
          host = "cyan";
        };
      }
      "separator"
      {
        type = "os";
        key = " os";
        keyColor = "blue";
      }
      {
        type = "kernel";
        key = " kern";
        keyColor = "blue";
      }
      {
        type = "uptime";
        key = "󰔟 up";
        keyColor = "blue";
      }
      {
        type = "packages";
        key = "󰏗 pkgs";
        keyColor = "blue";
      }
      {
        type = "shell";
        key = " sh";
        keyColor = "cyan";
      }
      {
        type = "terminal";
        key = " term";
        keyColor = "cyan";
      }
      {
        type = "wm";
        key = "󱂬 wm";
        keyColor = "cyan";
      }
      {
        type = "display";
        key = "󰍹 res";
        keyColor = "cyan";
      }
      "separator"
      {
        type = "cpu";
        key = " cpu";
        keyColor = "magenta";
        showPeCoreCount = true;
        temp = true;
      }
      {
        type = "gpu";
        key = "󰿵 gpu";
        keyColor = "magenta";
        temp = true;
        driverSpecific = true;
      }
      {
        type = "memory";
        key = "󰍛 ram";
        keyColor = "magenta";
      }
      {
        type = "disk";
        key = "󰋊 disk";
        keyColor = "magenta";
        folders = "/";
      }
      "separator"
      {
        type = "colors";
        paddingLeft = 1;
        symbol = "circle";
      }
    ];
  };
}
