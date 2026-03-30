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
        --target-host {{target}} \
        --use-remote-sudo

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

# Crear un nuevo secreto con agenix
# Uso: just secret nombre-del-secreto
secret name:
    cd secrets && agenix -e {{name}}.age

# Actualizar todos los inputs del flake
update:
    nix flake update

# Actualizar un input específico
# Uso: just update-input nixpkgs
update-input input:
    nix flake update {{input}}
