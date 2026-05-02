# Gestión de NixOS con nh + just
# Uso: just <tarea>

default:
    @just --list

# Aplicar configuración del host actual
switch:
    nh os switch .

# Preview de cambios sin aplicar
dry-run:
    nh os build . --dry

# Despliegue inicial en una máquina nueva (formatea disco e instala desde cero)
# Uso: just install servidor root@192.168.1.x
install host target:
    nixos-anywhere --flake .#{{host}} {{target}}

# Aplicar configuración en un host remoto ya instalado (requiere SSH)
# Uso: just deploy servidor g4ng@192.168.1.x
deploy host target=host:
    nixos-rebuild switch --flake .#{{host}} \
        --target-host g4ng@{{target}} \
        --use-remote-sudo \
        --ask-sudo-password

# Formatear código Nix (requiere: nix develop)
fmt:
    deadnix --edit .
    nixfmt .

# Limpiar generaciones antiguas del sistema y store
clean:
    sudo nix-collect-garbage --delete-older-than 14d
    nix store optimise

# Ver diferencias entre la generación actual y la nueva (sin aplicar)
diff:
    nh os build . && nvd diff /run/current-system result

# Editar (o crear) un secreto cifrado con sops
# Uso: just secret toledo     -> edita secrets/toledo.yaml
#      just secret common
secret name:
    sops secrets/{{name}}.yaml

# Actualizar todos los inputs del flake
update:
    nix flake update

# Actualizar un input específico
# Uso: just update-input nixpkgs
update-input input:
    nix flake update {{input}}

# ───────────────── TBK Mini ──────────────────
# Solo compila el firmware del TBK Mini sin flashear.
# Útil tras editar modules/hardware/tbk-mini/keymap/*.
tbk-build:
    nix build --no-link --print-out-paths \
      '.#nixosConfigurations.toledo.config.environment.systemPackages' \
      > /dev/null
    tbk-mini-flash | awk '/Firmware:/ { print $2 }'

# Flashea una mitad del TBK Mini.
# 1. Pon la mitad en bootloader (combo QK_BOOT o doble-tap reset físico)
# 2. Corre este comando; espera hasta 30s al volumen RPI-RP2, monta, copia y sync.
# Uso: just tbk-flash    (repite para la otra mitad)
tbk-flash:
    #!/usr/bin/env bash
    set -euo pipefail
    FW=$(tbk-mini-flash | awk '/Firmware:/ { print $2; exit }')
    if [ ! -f "$FW" ]; then
      echo "No encontré el firmware ($FW)" >&2
      exit 1
    fi
    echo "Firmware: $FW"
    echo "Esperando al volumen RPI-RP2 (pulsa reset o el combo QK_BOOT)…"
    DEV=""
    for _ in $(seq 1 60); do
      DEV=$(lsblk -rno NAME,LABEL | awk '$2 == "RPI-RP2" { print "/dev/" $1; exit }')
      [ -n "$DEV" ] && break
      sleep 0.5
    done
    if [ -z "$DEV" ]; then
      echo "No se detectó ninguna mitad en 30s. Aborto." >&2
      exit 1
    fi
    echo "Detectado: $DEV"
    sudo mkdir -p /mnt/rpi
    sudo mount "$DEV" /mnt/rpi
    sudo cp "$FW" /mnt/rpi/
    sync
    sudo umount /mnt/rpi 2>/dev/null || true
    echo "OK — la mitad se reinicia sola. Si queda otra, repite: just tbk-flash"
