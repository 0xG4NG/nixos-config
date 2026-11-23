# Flujo de trabajo

## devShell

```bash
nix develop
```

Incluye `just`, `nh`, `deadnix`, `nixfmt`, `agenix`, `age` y `nixos-anywhere`. Si zsh está disponible, el shell hace `exec zsh`.

## Recetas de `just`

`just` sin argumentos lista las recetas.

| Receta | Comando subyacente | Uso |
|--------|--------------------|-----|
| `just switch` | `nh os switch .` | Construye y activa el host actual (según `hostname`) |
| `just dry-run` | `nh os build . --dry` | Comprueba qué se construiría |
| `just diff` | `nh os build . && nvd diff /run/current-system result` | Diff de paquetes entre la generación actual y la nueva |
| `just deploy <host> [target]` | `nixos-rebuild switch --flake .#<host> --target-host g4ng@<target> --use-remote-sudo --ask-sudo-password` | Despliegue remoto. `target` es la IP o nombre (por defecto, el nombre del host) |
| `just install <host> <target>` | `nixos-anywhere --flake .#<host> <target>` | Instalación desde cero (**formatea el disco**) |
| `just fmt` | `deadnix --edit . && nixfmt .` | Elimina código muerto y formatea |
| `just clean` | `sudo nix-collect-garbage --delete-older-than 14d && nix store optimise` | Limpieza manual (además del GC semanal automático) |
| `just update` | `nix flake update` | Actualiza todos los inputs |
| `just update-input <input>` | `nix flake update <input>` | Actualiza un input concreto |
| `just secret <nombre>` | `sops secrets/<nombre>.yaml` | **Obsoleta**: el repo usa agenix (`agenix -e`) |
| `just tbk-build` | — | Compila el firmware del TBK Mini (ver [tbk-mini.md](tbk-mini.md)) |
| `just tbk-flash` | — | Espera a `RPI-RP2`, monta, copia el `.uf2` y desmonta |

Con `nh` también puedes:

```bash
nh os switch . -H laptop     # construir y activar forzando el host
nh os switch . --ask         # confirmar antes de activar
nh search <paquete>
```

## Cambios habituales

### Añadir un paquete

- Sin configuración: añadirlo a `environment.systemPackages` del host (o a `hosts/_common` si va en todos).
- Si es unfree: añadir su nombre (`lib.getName`) a `misc.allowUnfreeNames` del host.
- Si nixpkgs lo marca como inseguro: añadir `nombre-versión` a `misc.allowInsecureNames`.
- Si necesita wrapper, variables o firewall: crear un módulo en `modules/programs/<área>/<nombre>/default.nix` con el [patrón opt-in](architecture.md#patrón-opt-in) e importarlo en el host.

### Antes de hacer commit

```bash
just fmt
nix flake check          # evalúa todas las nixosConfigurations
just dry-run
```

Los ficheros nuevos deben estar en git (`git add`) para que el flake los vea.

## Instalación desde cero

Con [nixos-anywhere](https://github.com/nix-community/nixos-anywhere) desde una máquina que ya tenga el repo:

1. Arranca el destino con un ISO de NixOS (o cualquier Linux con SSH y kexec) y habilita acceso SSH como root.
2. Revisa el dispositivo en `hosts/<host>/disk.nix` (`lsblk` en el destino).
3. Para hosts sin `hardware-configuration.nix` real (p. ej. `router`):

   ```bash
   nixos-anywhere --flake .#router \
     --generate-hardware-config nixos-generate-config ./hosts/router/hardware-configuration.nix \
     root@192.168.1.100
   ```

4. Para discos cifrados (`laptop`), pasa la contraseña de LUKS:

   ```bash
   echo -n 'contraseña' > /tmp/secret.key
   nixos-anywhere --flake .#laptop --disk-encryption-keys /tmp/secret.key /tmp/secret.key root@<ip>
   ```

5. En el resto de casos: `just install <host> root@<ip>`.
6. Registra la clave de host del nuevo equipo en `secrets.nix` y recifra (ver [secrets.md](secrets.md#añadir-un-host-como-destinatario)).

## Despliegue remoto

```bash
just deploy router 192.168.1.100
```

- Conecta como `g4ng` y eleva con sudo **pidiendo contraseña** (no hay sudo sin contraseña).
- `g4ng` es `trusted-user`, así que puede recibir closures construidas localmente.
- El nombre del host también resuelve como `<host>.lan` gracias a `networking.hosts`.

## Mantenimiento

- **GC automático** semanal, borra generaciones de más de 14 días.
- systemd-boot guarda hasta `configurationLimit` generaciones (10 en escritorio y portátil).
- **Rollback**: elegir una generación anterior en el menú de arranque, o `sudo nixos-rebuild switch --rollback`.
- Actualizar: `just update && just diff && just switch`, y commit de `flake.lock`.
