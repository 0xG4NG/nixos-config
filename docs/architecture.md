# Arquitectura

Este documento explica cómo se ensambla la configuración de un host, qué tipos de módulo existen y qué convenciones se siguen al escribir módulos nuevos.

## 1. El flake

[`flake.nix`](../flake.nix) expone cuatro salidas:

| Salida | Descripción |
|--------|-------------|
| `nixosConfigurations.<host>` | Una por cada carpeta de `hosts/` distinta de `_common` |
| `packages.x86_64-linux.firmware` | Firmware `.uf2` del TBK Mini (`nix build .#firmware`) |
| `devShells.x86_64-linux.default` | Shell con `just`, `nh`, `deadnix`, `nixfmt`, `agenix`, `age`, `nixos-anywhere` (hace `exec zsh` si existe) |

Todos los inputs secundarios siguen a `nixpkgs` (`inputs.nixpkgs.follows = "nixpkgs"`), así solo hay una copia de nixpkgs en el closure.

### Auto-descubrimiento de hosts

```nix
hostDirs  = builtins.readDir ./hosts;
hostNames = builtins.attrNames (lib.filterAttrs (name: type:
  type == "directory" && name != "_common") hostDirs);
```

Basta con crear `hosts/<nombre>/default.nix` para que exista `.#<nombre>`. Ver [hosts.md → Añadir un host](hosts.md#añadir-un-host-nuevo) para los pasos adicionales (perfil de red, clave age…).

### `mkHost`

Cada host se construye con `nixpkgs.lib.nixosSystem` y la siguiente lista de módulos, en este orden:

1. `disko.nixosModules.disko`
2. `stylix.nixosModules.stylix`
3. `home-manager.nixosModules.home-manager`
4. `agenix.nixosModules.default`
5. `nix-gaming.nixosModules.platformOptimizations` (añade `programs.steam.platformOptimizations`)
6. `nix-gaming.nixosModules.pipewireLowLatency` (añade `services.pipewire.lowLatency`)
7. `./modules/hardware/keyboard/tbk-mini` (siempre importado; se activa con `hardware.tbk-mini.enable`)
8. Ajustes globales de home-manager: `sharedModules = [ nvf.homeManagerModules.default ]` y `extraSpecialArgs = { inherit inputs; }`
9. `./hosts/_common`
10. `./hosts/<host>`

`specialArgs` inyecta `inputs` y `hostName` en todos los módulos NixOS. `hostName` es el nombre de la carpeta y lo consume [`modules/network`](../modules/network/default.nix) para elegir el perfil de red y fijar `networking.hostName`.

## 2. Capas de configuración

```
flake.nix (mkHost)
 └── hosts/_common            ← todo host: nix, gc, overlays NUR, paquetes CLI base, red
      │   └── modules/system/* , modules/network   (importados, pero opt-in salvo red)
      └── hosts/<host>        ← hardware, disco, qué módulos activa, paquetes propios
           ├── users/g4ng     ← usuario del sistema + contraseña (agenix)
           ├── modules/...    ← módulos NixOS que el host importa
           └── home-manager.users.g4ng.imports
                ├── users/g4ng/dots/common.nix   ← CLI: zsh, nvf, git, ssh, fastfetch…
                └── users/g4ng/dots/desktop.nix  ← GUI: niri, waybar, ghostty, rofi, firefox…
```

### `hosts/_common`

Se aplica a todos los hosts:

- Importa `modules/system/{audio,boot,bluetooth,desktop-base,locale-es}` (todos desactivados por defecto) y `modules/network` (siempre activo).
- Habilita `nix-command` + `flakes`, GC semanal (`--delete-older-than 14d`), overlay de NUR.
- `age.identityPaths = [ "/etc/age/keys.txt" "/etc/ssh/ssh_host_ed25519_key" ]`.
- Activa zsh a nivel de sistema, `EDITOR`/`VISUAL = nvim` y un set de paquetes CLI (`git`, `gh`, `just`, `nh`, `ripgrep`, `jq`, `rsync`, `tree`, `fastfetch`, `cava`, `cmatrix`, `ghostty`, `neovim`, `wget`).
- Define dos opciones propias para controlar paquetes no libres e inseguros por host:

| Opción | Tipo | Efecto |
|--------|------|--------|
| `misc.allowUnfreeNames` | `listOf str` | Alimenta `nixpkgs.config.allowUnfreePredicate` comparando con `lib.getName pkg` |
| `misc.allowInsecureNames` | `listOf str` | Se pasa tal cual a `nixpkgs.config.permittedInsecurePackages` (nombre **con versión**) |

> Al ser una lista, cualquier módulo puede añadir nombres a `misc.allowUnfreeNames` y se fusionan. No definas otro `allowUnfreePredicate`: es una función y chocaría con el de `_common` (ver [known-issues](known-issues.md)).

### Usuario `g4ng`

[`users/g4ng/default.nix`](../users/g4ng/default.nix):

- `users.mutableUsers = false`: las cuentas solo existen si están declaradas.
- `g4ng` (uid/gid 1000), shell zsh, grupos `wheel networkmanager video render input`, contraseña desde el secreto agenix `g4ng_password` (`hashedPasswordFile`).
- `root` sin contraseña (`hashedPassword = "!"`) y solo accesible por clave SSH.
- La misma clave pública ed25519 autoriza a `g4ng` y `root`.
- `g4ng` es `trusted-user` de Nix (necesario para despliegues remotos y cachés extra).

Perfiles home-manager:

| Fichero | Contenido | Usado por |
|---------|-----------|-----------|
| `dots/common.nix` | `git.nix`, `ssh.nix`, zsh + starship, nvf, fastfetch, cava, cmatrix | todos |
| `dots/desktop.nix` | ghostty, niri, waybar, swaync, rofi, cosmic, firefox, vscode, mpv, imv, Qt/Kvantum, iconos Papirus, handler `lycheeslicer://` | `toledo`, `laptop` |

Todos los hosts usan `useGlobalPkgs = true` (home-manager comparte el `pkgs` del sistema, con sus overlays y la política de unfree), `useUserPackages = true` y `backupFileExtension = "backup"`.

## 3. Tipos de módulo

Hay dos familias y **no son intercambiables**: un módulo home-manager importado desde un host NixOS (o al revés) falla al evaluar porque las opciones no existen.

| Familia | Dónde se importa | Ejemplos |
|---------|------------------|----------|
| **NixOS** | `hosts/*/default.nix` o `hosts/_common` | `modules/system/*`, `modules/services/*`, `modules/programs/gaming`, `…/desktop/{kde,sddm,bitwarden,file-manager,orca-slicer}`, `…/media/davinci-resolve`, `…/keyboard/*`, `modules/theming/stylix` |
| **home-manager** | `users/g4ng/dots/*.nix` | `modules/programs/cli/*`, `…/desktop/{ghostty,niri,waybar,swaync,rofi,cosmic,vscode}`, `…/browser/firefox`, `…/media/{mpv,imv}`, `modules/theming/qt` |

La tabla completa con opciones está en [modules.md](modules.md).

### Patrón opt-in

La mayoría de módulos siguen este esquema:

```nix
{ config, lib, pkgs, ... }:

let cfg = config.misc.<nombre>;
in {
  options.misc.<nombre> = {
    enable = lib.mkEnableOption "Descripción corta";
    # otras opciones con default razonable
  };

  config = lib.mkIf cfg.enable {
    # …
  };
}
```

Convenciones:

- El espacio de nombres es `misc.*` para módulos propios. Excepciones: `hardware.qmk`, `hardware.tbk-mini` y `services.enshrouded`, que imitan la nomenclatura de NixOS.
- Importar un módulo no debería cambiar nada; activarlo sí. Algunos módulos antiguos **no** siguen el patrón y se activan solo con importarlos: `sddm`, `bitwarden`, `davinci-resolve`, `stylix`, y los módulos home-manager `niri`, `waybar`, `cosmic`, `firefox`, `vscode`, `mpv`, `imv`, `qt`, `zsh`, `nvf`, `fastfetch`, `cava`, `cmatrix`.
- Paquetes sueltos sin configuración van directamente en `environment.systemPackages` del host. Si un paquete necesita wrapper, variables o firewall, se le crea módulo propio.
- Los módulos home-manager pueden leer la configuración del sistema vía `osConfig` (p. ej. `niri` toma el layout XKB de `osConfig.services.xserver.xkb`, `ssh.nix` lee la ruta de un secreto agenix).
- Los colores salen de Stylix (`config.lib.stylix.colors.withHashtag`) en vez de estar hardcodeados (cava, fastfetch, rofi, waybar). La única excepción relevante son los bordes de niri.

## 4. Red

[`modules/network`](../modules/network/default.nix) contiene una tabla `profiles` indexada por `hostName`:

| Host | Tipo | Dirección |
|------|------|-----------|
| `toledo` | NetworkManager + perfil estático `static-eth` | `192.168.1.101/24` |
| `laptop` | NetworkManager (DHCP) | — |
| `router` | `networking.interfaces` estática en `eno1` | `192.168.1.100/24` |

Comunes: gateway `192.168.1.1`, DNS de Google (`8.8.8.8`, `8.8.4.4`), firewall activo, `timesyncd`. Además genera `networking.hosts` para que cada host con IP fija se resuelva como `<host>` y `<host>.lan` desde cualquier máquina.

> Todo host nuevo **necesita** una entrada en `profiles`; si no, la evaluación falla con `attribute '<host>' missing`.

## 5. Theming

- [`modules/theming/stylix`](../modules/theming/stylix/default.nix) (NixOS): esquema base16 propio (fondos grises neutros `#1d1d1d…` + acentos Catppuccin Mocha), polaridad oscura, fuentes Iosevka Nerd Font (terminal 16, apps/desktop 12), cursor Bibata-Modern-Classic 24, wallpaper `wallhaven-qrgvll.png`. `autoEnable = true` propaga el tema a todos los targets compatibles de NixOS y home-manager. Se importa también en `router` porque nvf usa `theme.name = "base16"` y necesita los colores.
- [`modules/theming/qt`](../modules/theming/qt/default.nix) (home-manager): fuerza Kvantum con el tema `KvGnomeDark` para apps Qt.
- Iconos Papirus-Dark (GTK y rofi).
