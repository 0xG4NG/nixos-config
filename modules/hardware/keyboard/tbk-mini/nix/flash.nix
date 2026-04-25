{ pkgs, firmware }:

pkgs.writeShellApplication {
  name          = "tbk-mini-flash";
  runtimeInputs = with pkgs; [ coreutils findutils util-linux ];
  text = ''
    set -euo pipefail

    FW_DIR="${firmware}"
    UF2=$(find "$FW_DIR" -maxdepth 1 -name '*.uf2' | head -n1)
    if [ -z "''${UF2:-}" ]; then
      echo "No se encontró .uf2 en $FW_DIR" >&2
      exit 1
    fi

    flash_half() {
      local timeout=30
      local elapsed=0
      local DEV=""
      local MOUNT
      MOUNT=$(mktemp -d)

      echo "Esperando RPI-RP2... (poné la mitad en bootloader)"
      while [ $elapsed -lt $timeout ]; do
        DEV=$(lsblk -o NAME,LABEL -rn | awk '$2=="RPI-RP2" {print "/dev/" $1}' | head -n1)
        if [ -n "''${DEV:-}" ]; then
          echo "Detectado $DEV — montando y copiando firmware..."
          mount "$DEV" "$MOUNT"
          cp "$UF2" "$MOUNT/"
          sync
          umount "$MOUNT"
          rmdir "$MOUNT"
          echo "Listo. La mitad se reiniciará sola."
          while lsblk -o LABEL -rn | grep -q "^RPI-RP2$"; do sleep 1; done
          return
        fi
        sleep 1
        elapsed=$((elapsed + 1))
      done

      rmdir "$MOUNT"
      echo "Timeout: no se detectó RPI-RP2 en $timeout segundos." >&2
      exit 1
    }

    if [ "$EUID" -ne 0 ]; then
      echo "Este script necesita montar el dispositivo — reejecutando con sudo..."
      exec sudo "$0" "$@"
    fi

    echo "Firmware: $UF2"
    echo ""
    echo "=== Mitad 1 ==="
    flash_half
    echo ""
    echo "=== Mitad 2 ==="
    flash_half
    echo ""
    echo "Ambas mitades flasheadas."
  '';
}
