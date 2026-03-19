# Gestión de NixOS con nh + just
# Uso: just <tarea>

default:
    @just --list

# Aplicar configuración del host actual
switch:
    nh os switch .

# Preview de cambios sin aplicar
dry-run:
    nh os build . --dry-run

# Aplicar en un host remoto (requiere SSH)
deploy host:
    nixos-rebuild switch --flake .#{{host}} \
        --target-host {{host}} \
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
