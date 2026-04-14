{ config, lib, pkgs, ... }:

let
  cfg = config.hardware.tbk-mini;

  keyboard   = "bastardkb/tbkmini/promicro";
  keymapDir  = "bastardkb/tbkmini/keymaps";
  keymapName = "g4ng";

  # qmk_firmware pineado con submódulos recursivos (chibios, chibios-contrib,
  # pico-sdk, lufa, etc. son necesarios para compilar RP2040/AVR).
  qmkFirmware = pkgs.fetchFromGitHub {
    owner          = "qmk";
    repo           = "qmk_firmware";
    rev            = "c93ef27143d1d99c20d20f478e9c5635c82b4cf8";
    fetchSubmodules = true;
    hash           = "sha256-neFSsDL7jTHWj1e6K2s/Yvca5v6/xPAU123DfXvUKwQ=";
  };

  firmware = pkgs.stdenv.mkDerivation {
    pname   = "tbk-mini-firmware";
    version = "0.1.0";

    src = qmkFirmware;

    nativeBuildInputs = with pkgs; [
      qmk
      gcc-arm-embedded
      python3
      git
      which
    ];

    dontConfigure = true;
    dontFixup     = true;
    enableParallelBuilding = true;

    unpackPhase = ''
      runHook preUnpack
      cp -r $src qmk_firmware
      chmod -R u+w qmk_firmware
      cd qmk_firmware
      runHook postUnpack
    '';

    postPatch = ''
      rm -rf keyboards/${keymapDir}/${keymapName}
      mkdir -p keyboards/${keymapDir}/${keymapName}
      cp -r ${./keymap}/. keyboards/${keymapDir}/${keymapName}/
      chmod -R u+w keyboards/${keymapDir}/${keymapName}

      # Quitar la redirección que oculta errores de uf2conv.py
      substituteInPlace builddefs/common_rules.mk \
        --replace-warn '>/dev/null 2>&1' ""

      patchShebangs util/uf2conv.py
    '';

    buildPhase = ''
      runHook preBuild
      export HOME=$TMPDIR
      export SKIP_GIT=yes
      export SKIP_VERSION=yes
      make -j$NIX_BUILD_CORES ${keyboard}:${keymapName}${
        lib.optionalString (cfg.converter != null) " CONVERT_TO=${cfg.converter}"
      }
      runHook postBuild
    '';

    installPhase = ''
      runHook preInstall
      mkdir -p $out
      shopt -s nullglob
      for f in *.uf2 *.hex *.bin; do
        cp "$f" $out/
      done
      shopt -u nullglob
      if [ -z "$(ls -A $out)" ]; then
        echo "No firmware artifact was produced" >&2
        exit 1
      fi
      runHook postInstall
    '';
  };

  flashHelper = pkgs.writeShellApplication {
    name = "tbk-mini-flash";
    runtimeInputs = [ pkgs.coreutils pkgs.findutils ];
    text = ''
      set -euo pipefail
      FW_DIR="${firmware}"
      UF2=$(find "$FW_DIR" -maxdepth 1 -name '*.uf2' | head -n1)
      if [ -z "''${UF2:-}" ]; then
        echo "No se encontró .uf2 en $FW_DIR" >&2
        exit 1
      fi
      echo "Firmware: $UF2"
      echo ""
      echo "1. Poné el TBK Mini en modo bootloader (doble-tap reset, o QK_BOOT desde la capa adjust)."
      echo "2. Montá el volumen RPI-RP2 (o usá el autoarranque del DE)."
      echo "3. Copiá el .uf2 al volumen:"
      echo ""
      echo "   cp '$UF2' /run/media/$USER/RPI-RP2/"
      echo ""
      echo "La mitad se reiniciará sola. Repetí para la otra mitad."
    '';
  };
in
{
  options.hardware.tbk-mini = {
    enable = lib.mkEnableOption "Firmware QMK personalizado para TBK Mini";

    converter = lib.mkOption {
      type        = lib.types.nullOr lib.types.str;
      default     = "promicro_rp2040";
      example     = "promicro_rp2040";
      description = ''
        Target `CONVERT_TO` de QMK para el controlador.
        - `promicro_rp2040` sirve para Splinky v3 (RP2040, VID a8f8) y otros Pro Micro RP2040.
        - `elite_pi` para Elite-Pi.
        - `null` para Pro Micro AVR nativo (elite-c).
      '';
    };
  };

  config = lib.mkIf cfg.enable {
    environment.systemPackages = [ firmware flashHelper ];
  };
}
