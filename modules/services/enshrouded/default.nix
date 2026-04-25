{ config, lib, pkgs, ... }:

let
  cfg = config.services.enshrouded;

  # El JSON se genera declarativamente; se copia (no symlink) en preStart porque
  # el servidor lo reescribe en cada arranque añadiendo campos nuevos en los patches.
  serverConfigJson = pkgs.writeText "enshrouded_server.json" (builtins.toJSON {
    name         = cfg.serverName;
    password     = cfg.password; # sobreescrito en preStart si hay passwordFile
    saveDirectory = "./savegame";
    logDirectory  = "./logs";
    ip            = "0.0.0.0";
    gamePort      = cfg.gamePort;
    queryPort     = cfg.queryPort;
    slotCount     = cfg.slotCount;
  });

  # Script auxiliar que inyecta la contraseña en tiempo de ejecución
  # sin exponerla en el store de Nix.
  startScript = pkgs.writeShellScript "enshrouded-start" ''
    set -eu

    ${lib.optionalString cfg.autoUpdate ''
      ${pkgs.steamcmd}/bin/steamcmd \
        +@sSteamCmdForcePlatformType windows \
        +force_install_dir ${cfg.dataDir}/server \
        +login anonymous \
        +app_update 2278520 validate \
        +quit
    ''}

    # SteamCMD descarga los archivos como root; transferimos propiedad al usuario del servicio
    chown -R ${cfg.user}:${cfg.group} ${cfg.dataDir}/server

    # Copia base del JSON declarativo
    install -m 0640 -o ${cfg.user} -g ${cfg.group} \
      ${serverConfigJson} ${cfg.dataDir}/server/enshrouded_server.json

    ${lib.optionalString (cfg.passwordFile != null) ''
      # Inyecta la contraseña leyendo el fichero de secreto en tiempo de arranque
      PASSWORD=$(cat ${lib.escapeShellArg cfg.passwordFile})
      ${pkgs.jq}/bin/jq --arg pw "$PASSWORD" '.password = $pw' \
        ${cfg.dataDir}/server/enshrouded_server.json \
        > ${cfg.dataDir}/server/enshrouded_server.json.tmp
      mv ${cfg.dataDir}/server/enshrouded_server.json.tmp \
         ${cfg.dataDir}/server/enshrouded_server.json
    ''}
  '';
in
{
  options.services.enshrouded = {
    enable = lib.mkEnableOption "Servidor dedicado de Enshrouded (vía Wine)";

    dataDir = lib.mkOption {
      type        = lib.types.path;
      default     = "/var/lib/enshrouded";
      description = "Directorio raíz: instalación del server, savegames y prefijo Wine.";
    };

    user = lib.mkOption {
      type    = lib.types.str;
      default = "enshrouded";
    };

    group = lib.mkOption {
      type    = lib.types.str;
      default = "enshrouded";
    };

    serverName = lib.mkOption {
      type    = lib.types.str;
      default = "Enshrouded NixOS Server";
    };

    password = lib.mkOption {
      type        = lib.types.str;
      default     = "";
      description = "Contraseña en texto plano. Vacío = servidor abierto. Usar passwordFile para producción.";
    };

    passwordFile = lib.mkOption {
      type        = lib.types.nullOr lib.types.path;
      default     = null;
      description = "Ruta a un fichero con la contraseña (p.ej. secreto agenix). Tiene prioridad sobre password.";
    };

    slotCount = lib.mkOption {
      type    = lib.types.ints.between 1 16;
      default = 16;
    };

    gamePort = lib.mkOption {
      type    = lib.types.port;
      default = 15636;
    };

    queryPort = lib.mkOption {
      type    = lib.types.port;
      default = 15637;
    };

    openFirewall = lib.mkOption {
      type    = lib.types.bool;
      default = true;
    };

    autoUpdate = lib.mkOption {
      type        = lib.types.bool;
      default     = true;
      description = "Ejecutar SteamCMD antes de arrancar para mantener el server actualizado.";
    };
  };

  config = lib.mkIf cfg.enable {
    nixpkgs.config.allowUnfreePredicate = pkg:
      builtins.elem (lib.getName pkg) [
        "steamcmd"
        "steam-original"
        "steam-run"
      ];

    users.users.${cfg.user} = {
      isSystemUser = true;
      group        = cfg.group;
      home         = cfg.dataDir;
      createHome   = true;
      description  = "Enshrouded dedicated server";
    };
    users.groups.${cfg.group} = {};

    networking.firewall = lib.mkIf cfg.openFirewall {
      allowedUDPPorts = [ cfg.gamePort cfg.queryPort ];
    };

    systemd.tmpfiles.rules = [
      "d ${cfg.dataDir}                0750 ${cfg.user} ${cfg.group} - -"
      "d ${cfg.dataDir}/server         0750 ${cfg.user} ${cfg.group} - -"
      "d ${cfg.dataDir}/server/savegame 0750 ${cfg.user} ${cfg.group} - -"
      "d ${cfg.dataDir}/server/logs    0750 ${cfg.user} ${cfg.group} - -"
      "d ${cfg.dataDir}/wine           0750 ${cfg.user} ${cfg.group} - -"
    ];

    systemd.services.enshrouded = {
      description = "Enshrouded Dedicated Server";
      wants       = [ "network-online.target" ];
      after       = [ "network-online.target" ];
      wantedBy    = [ "multi-user.target" ];

      path = with pkgs; [
        steamcmd
        wineWowPackages.stable
        winetricks
        jq
        coreutils
      ];

      environment = {
        WINEPREFIX        = "${cfg.dataDir}/wine";
        WINEARCH          = "win64";
        WINEDEBUG         = "-all";
        # Evita los popups de Mono/Gecko al arrancar Wine por primera vez
        WINEDLLOVERRIDES  = "mscoree=d;mshtml=d";
        HOME              = cfg.dataDir;
        DISPLAY           = "";
      };

      serviceConfig = {
        Type             = "simple";
        User             = cfg.user;
        Group            = cfg.group;
        WorkingDirectory = "${cfg.dataDir}/server";
        ExecStartPre     = "+${startScript}";
        ExecStart        = "${pkgs.wineWowPackages.stable}/bin/wine ${cfg.dataDir}/server/enshrouded_server.exe";
        Restart          = "on-failure";
        RestartSec       = 30;
        TimeoutStopSec   = 90;
        # Endurecimiento compatible con Wine
        NoNewPrivileges  = true;
        PrivateTmp       = true;
        ProtectSystem    = "strict";
        ProtectHome      = true;
        ReadWritePaths   = [ cfg.dataDir ];
      };
    };
  };
}
