# nixos-config

Configuración de NixOS gestionada con flakes. Auto-descubre hosts y centraliza módulos reutilizables para expandirse a un pequeño homelab.

## Hardware

| Host | Rol | CPU | GPU |
|------|-----|-----|-----|
| `toledo` | Escritorio principal | AMD Ryzen 9 7950X | AMD Radeon RX 9070 XT |
| `laptop` | Portátil (WIP) | — | NVIDIA (Optimus) |
| `servidor` | Homelab (WIP) | — | headless |

Base: `nixos-unstable` + `home-manager` + `stylix` + `agenix` + `nix-gaming` + `nvf` + `noctalia`.

## Estructura

```
nixos-config/
├── flake.nix                     # Inputs, auto-descubrimiento de hosts, devShell
├── justfile                      # Tareas comunes (switch, deploy, fmt, tbk-flash…)
├── secrets.nix                   # Claves age por host y reglas de cifrado (agenix)
│
├── hosts/
│   ├── _common/                  # Config compartida por todos los hosts
│   ├── toledo/                   # Escritorio (activo)
│   ├── laptop/                   # Portátil
│   └── servidor/                 # Servidor headless (IP estática)
│
├── modules/
│   ├── hardware/
│   │   └── keyboard/tbk-mini/    # Firmware QMK para TBK Mini Splinky (RP2040)
│   ├── programs/
│   │   ├── browser/firefox/
│   │   ├── cli/{zsh,nvf,fastfetch,cava,cmatrix}/
│   │   ├── desktop/{ghostty,niri,hyprland,noctalia,rofi,cosmic,vscode,sddm,bitwarden}/
│   │   ├── gaming/               # Steam + Gamescope + GameMode + libs 32-bit
│   │   ├── keyboard/qmk/         # Opciones hardware.qmk (udev, plugdev…)
│   │   └── media/davinci-resolve/  # Workarounds RDNA 4 (Rusticl + stub)
│   ├── services/
│   │   ├── syncthing/            # Wrapper con role = client|server
│   │   └── enshrouded/           # Servidor dedicado Enshrouded vía Wine
│   ├── system/
│   │   ├── audio/                # Pipewire + rtkit + low-latency
│   │   ├── boot/                 # systemd-boot + EFI
│   │   ├── bluetooth/            # bluez + blueman
│   │   ├── desktop-base/         # xdg.portal + gnome-keyring
│   │   └── locale-es/            # es_ES.UTF-8 + teclado us-acentos
│   └── theming/
│       ├── stylix/               # Esquema base16, fuentes, cursor, wallpaper
│       └── qt/                   # Kvantum para apps Qt
│
├── users/
│   └── g4ng/
│       ├── default.nix           # Usuario NixOS (uid, grupos, shell, hashedPasswordFile)
│       ├── git.nix               # Config git (email vía agenix)
│       └── dots/
│           ├── common.nix        # Home-Manager base (CLI)
│           └── desktop.nix       # Home-Manager escritorio (GUI)
│
└── secrets/
    ├── g4ng_password.age         # Hash de contraseña del usuario (todos los hosts)
    └── git_email.age             # Email de git (toledo)
```

## Hosts

Los hosts se auto-descubren: cualquier subdirectorio en `hosts/` que no sea `_common` se registra automáticamente como `nixosConfiguration`. Para añadir un host basta con crear `hosts/<nombre>/default.nix`.

### toledo (escritorio)

Escritorio completo con Niri como compositor Wayland. Destacado:

- **Gaming**: Steam, Gamescope, GameMode, nix-gaming platform optimizations, Heroic, Bottles, mo2installer.
- **Virtualización**: libvirt/QEMU (TPM virtual para Windows 11) + Podman + Distrobox.
- **Streaming**: Sunshine (game streaming) con puertos abiertos.
- **3D printing**: OrcaSlicer (wrappeado para compatibilidad Wayland/X11).
- **Privacidad**: Tor (cliente SOCKS5 en :9050) + Tor Browser.
- **i2c**: habilitado para control de monitor vía `ddcutil`.
- **Flatpak**: habilitado.

## Flujo de trabajo

```bash
nix develop               # Entra al devShell (just, nh, agenix, age, deadnix, nixfmt…)

just switch               # Aplica la configuración al host actual
just dry-run              # Build sin aplicar
just diff                 # Diff entre la generación actual y la nueva
just deploy <host> <tgt>  # Deploy remoto vía SSH
just install <host> <tgt> # Instalación nueva con nixos-anywhere
just fmt                  # deadnix + nixfmt
just clean                # GC + store optimise (14 días)
just update               # nix flake update
just update-input <input> # Actualiza un input específico (ej: nixpkgs)

# TBK Mini
just tbk-build            # Solo compila el firmware (sin flashear)
just tbk-flash            # Espera RPI-RP2, monta y copia el .uf2 automáticamente
```

## Secretos (agenix)

Todos los secretos viven cifrados en `secrets/*.age`. Las reglas de cifrado están en [`secrets.nix`](secrets.nix): cada host tiene su clave age pública y solo los hosts autorizados pueden descifrar sus ficheros.

```bash
# Editar un secreto existente
agenix -e secrets/git_email.age

# Crear uno nuevo (cifrado automáticamente con las claves de secrets.nix)
agenix -e secrets/nuevo.age
```

Para declarar el secreto en un módulo:

```nix
age.secrets.mi_token = {
  file  = ./../../secrets/common.age;
  owner = "g4ng";
};
# Uso
services.foo.tokenFile = config.age.secrets.mi_token.path;
```

La clave age del host se genera con `ssh-to-age` a partir de `/etc/ssh/ssh_host_ed25519_key`. Para añadir un host nuevo hay que registrar su clave pública en `secrets.nix` y re-cifrar los secretos que necesite con `agenix -r`.

## Módulos destacados

### `modules/programs/media/davinci-resolve`
DaVinci Resolve funcional en GPUs RDNA 4 (RX 9070 XT) con dos workarounds:
- **Rusticl** como backend OpenCL (el driver oficial de AMD no soporta RDNA 4).
- **Stub de `libProResRAW.so`** para evitar segfaults por ABI incompatible con GCC bajo Rusticl.

### `modules/hardware/keyboard/tbk-mini`
Compila y empaqueta el firmware QMK propio para el TBK Mini Splinky (RP2040, Pro Micro clone). Incluye el helper `tbk-mini-flash` y la tarea `just tbk-flash` que espera automáticamente al volumen `RPI-RP2`, monta, copia el `.uf2` y desmonta.

### `modules/programs/keyboard/qmk`
Wrapper con opciones para declarar teclados QMK con VID/PID: añade udev rules específicas para que WebHID (VIA/Vial) funcione en Chromium, y gestiona el grupo `plugdev`.

### `modules/programs/gaming`
Activa Steam con Gamescope + GameMode + libs 32-bit y las optimizaciones de plataforma de nix-gaming. Opción: `misc.gaming.enable`.

### `modules/services/enshrouded`
Servidor dedicado de Enshrouded vía Wine con systemd. Gestiona instalación/actualización automática con SteamCMD, configuración declarativa en JSON y soporte para contraseña vía secreto agenix (nunca expuesta en el store).

### `modules/theming/stylix`
Tema unificado (colores base16 estilo Catppuccin Mocha, fuente IosevkaTerm Nerd Font, cursor Bibata) propagado a todos los programas integrados con Stylix: terminal, editor, compositor, GTK, etc.

### `modules/theming/qt`
Theming Qt vía Kvantum (`KvGnomeDark`), coherente con el esquema de Stylix.

## Inspiración

- [notthebee/nix-config](https://git.notthebe.ee/notthebee/nix-config)
