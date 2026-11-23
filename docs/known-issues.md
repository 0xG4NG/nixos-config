# Problemas conocidos y pendientes

Encontrados revisando el código en noviembre de 2026 (rama `claude/cool-tesla-h9npzz`, commit `633ded8`). No se han verificado con `nix flake check` porque los inputs no se pudieron descargar en el entorno de análisis; los marcados como **bloqueante** fallan al evaluar por cómo funciona el sistema de módulos.

## Bloqueantes de evaluación

### 1. `toledo` referencia un secreto que ya no existe

`hosts/toledo/default.nix` declara `age.secrets.git_email` con `file = ../../secrets/git_email.age`, pero ese fichero se eliminó (commit `aee748e`) y no está en `secrets.nix`. El activation script `gitconfig` que lo lee tampoco se usa ya: `users/g4ng/git.nix` fija el email directamente y tiene comentado el `includes`.

**Solución**: eliminar el bloque `age.secrets.git_email` y `system.activationScripts.gitconfig` de `toledo`.

### 2. `ssh.nix` necesita `github_ssh` en todos los hosts

`users/g4ng/dots/common.nix` (cargado por **todos** los hosts) importa `users/g4ng/ssh.nix`, que lee `osConfig.age.secrets.github_ssh.path`. Ese secreto solo se declara en `laptop`, así que `toledo` y `router` fallan con `attribute 'github_ssh' missing`.

**Opciones**: mover `age.secrets.github_ssh` a `users/g4ng/default.nix` (y añadir las claves de host de toledo/router en `secrets.nix`), o importar `ssh.nix` solo desde `laptop`, o protegerlo con `lib.mkIf (osConfig.age.secrets ? github_ssh)`.

### 3. Host nuevo sin perfil de red

`modules/network` hace `profiles.${hostName}` sin valor por defecto: cualquier host sin entrada en la tabla falla al evaluar. Es intencionado, pero conviene saberlo (documentado en [hosts.md](hosts.md#añadir-un-host-nuevo)).

## Secretos

- **toledo y router no tienen clave en `secrets.nix`.** Solo pueden descifrar `g4ng_password` si tienen la clave `admin` en `/etc/age/keys.txt`. Si no, con `mutableUsers = false`, `g4ng` se queda sin contraseña (solo acceso por SSH con clave).
- `just secret` invoca `sops secrets/<nombre>.yaml`, resto de cuando se usaba sops-nix. Debería ser `agenix -e secrets/{{name}}.age`.

## justfile

- `tbk-build` ejecuta `nix build` sobre `…config.environment.systemPackages`, que es una lista y no una derivación, y después llama a `tbk-mini-flash` (que pide sudo y se pone a esperar al teclado). Lo correcto sería `nix build .#firmware --print-out-paths`.
- `diff` usa `nvd`, que no está en el devShell ni en los paquetes del sistema. Alternativa: añadir `nvd` al devShell, o confiar en el diff que ya muestra `nh os build`
- `deploy` usa `--use-remote-sudo`, marcado como obsoleto en `nixos-rebuild-ng` en favor de `--sudo`.

## Escritorio

- **Atajos de niri sin dependencias**: `Mod+X` y `Mod+/` lanzan `foot`, `fsel`, `cliphist-select` y `cliphist-delete`, y al arrancar se ejecuta `wl-paste --watch cliphist store`. Ninguno de esos paquetes (`foot`, `fsel`, `cliphist`, `wl-clipboard`) está declarado. Además `cliphist-select`/`cliphist-delete` son scripts que no existen en el repo.
- **niri en `laptop`**: home-manager instala la configuración de niri (con las salidas `DP-1`/`DP-2` de toledo) y waybar, pero el host no tiene `programs.niri.enable`. No rompe nada, pero es configuración muerta; las salidas deberían depender del host.
- **Color hardcodeado**: el borde activo de niri (`#CBA6F7`) y el inactivo (`#373737`) están escritos a mano en lugar de leerse de Stylix (`base0E`/`base02`).
- **COSMIC**: `modules/programs/desktop/cosmic` escribe configuración de un escritorio que ningún host activa.
- **Wallpapers**: la carpeta `modules/programs/desktop/niri/wallpapers/` tiene siete imágenes y Stylix solo usa una. `modules/theming/stylix/wallpapers/wallhaven-839g92.png` no se usa.
- **ghostty**: `working-directory = "/home/g4ng/nixos-config"` está fijo.
- **Tildes en el TBK Mini**: las macros `RAlt+A/E/I/O/U/N` del keymap asumen el layout `us` variante `altgr-intl`, pero los hosts usan el layout `es` por defecto de `misc.locale-es`. Con `es`, la ñ sale en la tecla `;`, y las tildes se escriben con la tecla muerta `´`.

## Módulos

- **`services.enshrouded` define su propio `nixpkgs.config.allowUnfreePredicate`**, que chocaría con el de `hosts/_common` (las funciones no se fusionan) si algún host lo activara. Debería añadir sus nombres a `misc.allowUnfreeNames`.
- **Módulos que no son opt-in**: `sddm`, `bitwarden` y `davinci-resolve` se aplican con solo importarlos, al contrario que el resto (`misc.*.enable`).
- **`laptop` duplica configuración** que ya tiene módulo: SDDM/Plasma (`misc.kde`, `sddm`), Steam (`misc.gaming`), podman (`misc.virtualisation`) y `nix-ld` (repetido igual en toledo; podría ir a `_common` o a un módulo).
- `TAPPING_FORCE_HOLD` está obsoleto en QMK reciente (sustituido por `QUICK_TAP_TERM 0`); en el commit fijado de vial-qmk todavía compila.
- `router` añade `g4ng` al grupo `networkmanager`, que no existe en ese host porque no usa NetworkManager.
- El perfil NM `static-eth` de toledo fija `/24` en vez de usar un `prefix` como el perfil estático de `router`, y no está atado a ninguna interfaz.

## Varios

- `README` y comentarios mencionaban `servidor`/`xeon`; el host actual es `router`.
- `home.stateVersion = "25.11"` es común a todos los hosts, mientras que `laptop` usa `system.stateVersion = "26.05"`. Es correcto (son independientes), pero no hay que cambiarlos sin leer las notas de migración.
