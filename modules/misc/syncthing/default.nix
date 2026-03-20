{ config, lib, ... }:

let
  cfg = config.misc.syncthing;
in
{
  options.misc.syncthing = {
    enable = lib.mkEnableOption "Syncthing";

    role = lib.mkOption {
      type        = lib.types.enum [ "client" "server" ];
      default     = "client";
      description = ''
        client: sincroniza carpetas desde/hacia el servidor.
        server: almacena y sirve carpetas, expone GUI en red.
      '';
    };

    user = lib.mkOption {
      type        = lib.types.str;
      description = "Usuario bajo el que corre Syncthing.";
    };

    dataDir = lib.mkOption {
      type        = lib.types.str;
      description = "Directorio de datos (donde viven las carpetas sincronizadas).";
    };

    overrideDevices = lib.mkOption {
      type    = lib.types.bool;
      default = true;
      description = "Elimina dispositivos no declarados en Nix.";
    };

    overrideFolders = lib.mkOption {
      type    = lib.types.bool;
      default = true;
      description = "Elimina carpetas no declaradas en Nix.";
    };

    devices = lib.mkOption {
      default     = {};
      description = "Dispositivos conocidos (peers).";
      type        = lib.types.attrsOf (lib.types.submodule {
        options = {
          id = lib.mkOption {
            type        = lib.types.str;
            description = "Device ID de Syncthing.";
          };
          autoAcceptFolders = lib.mkOption {
            type    = lib.types.bool;
            default = false;
          };
        };
      });
    };

    folders = lib.mkOption {
      default     = {};
      description = "Carpetas a sincronizar.";
      type        = lib.types.attrsOf (lib.types.submodule {
        options = {
          path = lib.mkOption {
            type        = lib.types.str;
            description = "Ruta local de la carpeta.";
          };
          devices = lib.mkOption {
            type    = lib.types.listOf lib.types.str;
            default = [];
            description = "Lista de nombres de dispositivos con los que sincronizar.";
          };
          type = lib.mkOption {
            type    = lib.types.enum [ "sendreceive" "sendonly" "receiveonly" ];
            default = "sendreceive";
          };
        };
      });
    };
  };

  config = lib.mkIf cfg.enable {
    services.syncthing = {
      enable      = true;
      user        = cfg.user;
      dataDir     = cfg.dataDir;
      openDefaultPorts  = true;
      overrideDevices   = cfg.overrideDevices;
      overrideFolders   = cfg.overrideFolders;

      settings = {
        # En servidor exponemos la GUI en la red; en cliente solo localhost
        gui.address = if cfg.role == "server"
          then "0.0.0.0:8384"
          else "127.0.0.1:8384";

        devices = lib.mapAttrs (_: dev: {
          inherit (dev) id autoAcceptFolders;
        }) cfg.devices;

        folders = lib.mapAttrs (_: folder: {
          inherit (folder) path devices type;
        }) cfg.folders;
      };
    };

    # El servidor también abre el puerto de la GUI en el firewall
    networking.firewall.allowedTCPPorts = lib.mkIf (cfg.role == "server") [ 8384 ];
  };
}
