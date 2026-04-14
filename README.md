# nixos-config

Configuración de NixOS gestionada con flakes. Auto-descubre hosts y centraliza módulos reutilizables para expandirse a un pequeño homelab.

## Hardware

| Host | Rol | CPU | GPU |
|------|-----|-----|-----|
| `toledo` | Escritorio principal | AMD Ryzen 9 7950X | AMD Radeon RX 9070 XT |
| `laptop` | Portátil (WIP) | — | NVIDIA (Optimus) |
| `servidor` | Homelab (WIP) | — | headless |

Base: `nixos-unstable` + `home-manager` + `stylix` + `sops-nix`.

## Estructura

```
nixos-config/
├── flake.nix                     # Inputs, auto-descubrimiento de hosts, devShell
├── justfile                      # Tareas comunes (switch, deploy, fmt, secret...)
├── .sops.yaml                    # Claves age por host y reglas de cifrado
│
├── hosts/
│   ├── _common/                  # Config compartida por todos los hosts
│   ├── toledo/                   # Escritorio (activo)
│   ├── laptop/                   # Portátil
│   └── servidor/                 # Servidor
│
├── modules/
│   ├── hardware/
│   │   └── tbk-mini/             # Firmware QMK para TBK Mini Splinky (RP2040)
│   ├── programs/
│   │   ├── browser/firefox/
│   │   ├── cli/{zsh,nvf,fastfetch,cava,cmatrix}/
│   │   ├── desktop/{ghostty,niri,noctalia,rofi,cosmic,vscode,sddm,bitwarden}/
│   │   ├── keyboard/qmk/         # Opciones hardware.qmk (udev, plugdev…)
│   │   └── media/davinci-resolve/  # Workarounds RDNA 4 (Rusticl + stub)
│   ├── services/
│   │   └── syncthing/            # Wrapper con role = client|server
│   ├── system/
│   │   ├── audio/                # Pipewire + rtkit + low-latency
│   │   ├── boot/                 # systemd-boot + EFI
│   │   ├── bluetooth/            # bluez + blueman
│   │   ├── desktop-base/         # xdg.portal + gnome-keyring
│   │   └── locale-es/            # es_ES.UTF-8 + teclado us-acentos
│   └── theming/
│       └── stylix/               # Esquema base16, fuentes, cursor, wallpaper
│
├── users/
│   └── g4ng/
│       ├── default.nix           # Usuario NixOS (uid, grupos, shell, hashedPassword)
│       ├── git.nix               # Config git (email vía sops)
│       └── dots/
│           ├── common.nix        # Home-Manager base (CLI)
│           └── desktop.nix       # Home-Manager escritorio (GUI)
│
└── secrets/
    ├── common.yaml               # Secretos compartidos (hashedPassword…)
    └── toledo.yaml               # Secretos específicos de toledo
```

## Hosts

Los hosts se auto-descubren: cualquier subdirectorio en `hosts/` que no sea `_common` se registra automáticamente como `nixosConfiguration`. Para añadir un host basta con crear `hosts/<nombre>/default.nix`.

## Flujo de trabajo

```bash
nix develop               # Entra al devShell (just, nh, sops, age, deadnix, nixfmt…)

just switch               # Aplica la configuración al host actual
just dry-run              # Build sin aplicar
just diff                 # Diff entre la generación actual y la nueva
just deploy <host> <tgt>  # Deploy remoto vía SSH
just install <host> <tgt> # Instalación nueva con nixos-anywhere
just fmt                  # deadnix + nixfmt
just clean                # GC + store optimise
just update               # nix flake update
just secret <name>        # Edita secrets/<name>.yaml con sops
```

## Secretos (sops-nix)

Todos los secretos viven cifrados en `secrets/*.yaml`. Las reglas de cifrado están en [`.sops.yaml`](.sops.yaml): cada host tiene su clave age y solo los hosts autorizados pueden descifrar su fichero.

```bash
# Editar un secreto existente
sops secrets/toledo.yaml

# Crear uno nuevo (automáticamente cifrado con las claves de .sops.yaml)
sops secrets/nuevo.yaml

# Declarar el secreto en un módulo
sops.secrets.mi_token = {
  sopsFile = ./../../secrets/common.yaml;
};
# Uso
services.foo.tokenFile = config.sops.secrets.mi_token.path;
```

La clave age del host debe estar en `/etc/age/keys.txt` (derivada de `/etc/ssh/ssh_host_ed25519_key` con `ssh-to-age`).

## Módulos destacados

### `modules/programs/media/davinci-resolve`
DaVinci Resolve funcional en GPUs RDNA 4 (RX 9070 XT) con dos workarounds:
- **Rusticl** como backend OpenCL (el driver oficial de AMD no soporta RDNA 4).
- **Stub de `libProResRAW.so`** para evitar segfaults por ABI incompatible con GCC bajo Rusticl.

### `modules/hardware/tbk-mini`
Compila y empaqueta el firmware QMK propio para el TBK Mini Splinky (RP2040, Pro Micro clone). Incluye un helper `tbk-mini-flash` que localiza el `.uf2` y da instrucciones para el flasheo por bootloader.

### `modules/programs/keyboard/qmk`
Wrapper con opciones para declarar teclados QMK con VID/PID: añade udev rules específicas necesarias para que WebHID (VIA) funcione en Chromium, y gestiona el grupo `plugdev`.

### `modules/theming/stylix`
Tema unificado (colores base16, fuente Iosevka Nerd Font, cursor Bibata) propagado a todos los programas integrados con Stylix: terminal, editor, compositor, GTK, etc.

## Inspiración

- [notthebee/nix-config](https://git.notthebe.ee/notthebee/nix-config)
