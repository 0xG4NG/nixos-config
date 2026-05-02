{ config, lib, pkgs, ... }:

let
  cfg = config.misc.ddo;

  wine = pkgs.wineWow64Packages.staging;

  ddo-pkg = pkgs.symlinkJoin {
    name = "ddo";
    paths = [
      (pkgs.writeShellScriptBin "ddo" ''
        PREFIX="''${WINEPREFIX:-$HOME/.wine-ddo}"
        export WINEPREFIX="$PREFIX"
        export WINEARCH=win32

        if [ ! -f "$PREFIX/system.reg" ]; then
          echo "[ddo] Inicializando Wine prefix en $PREFIX..."
          ${wine}/bin/wineboot --init
          echo "[ddo] Instalando DXVK..."
          ${pkgs.dxvk}/bin/setup_dxvk install
          echo "[ddo] Instalando .NET Desktop Runtime 9 x86..."
          WINEPREFIX="$PREFIX" WINEARCH=win32 ${pkgs.winetricks}/bin/winetricks -q dotnetdesktop9
        fi

        exec ${wine}/bin/wine "${cfg.gamePath}"
      '')
      (pkgs.makeDesktopItem {
        name        = "ddo";
        desktopName = "Dragon's Dogma Online";
        exec        = "ddo";
        icon        = "wine";
        categories  = [ "Game" ];
        comment     = "Dragon's Dogma Online (Wine + DXVK)";
      })
    ];
  };
in
{
  options.misc.ddo = {
    enable = lib.mkEnableOption "Dragon's Dogma Online (Wine + DXVK launcher)";

    gamePath = lib.mkOption {
      type        = lib.types.str;
      description = "Ruta absoluta al ejecutable ddo_launcher.exe.";
      example     = "/home/g4ng/juegos/Dragon's Dogma Online/ddo_launcher.exe";
    };
  };

  config = lib.mkIf cfg.enable {
    environment.systemPackages = [
      ddo-pkg
      wine
      pkgs.dxvk
      pkgs.winetricks
    ];

    fonts.packages = [ pkgs.ipafont pkgs.noto-fonts-cjk-sans ];
  };
}
