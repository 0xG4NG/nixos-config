# nixos-config

Configuración de NixOS gestionada con flakes. Actualmente gestiona un único host de escritorio (`toledo`), con estructura preparada para expandirse a un homelab.
 
## Hardware

| Componente | Modelo |
|------------|--------|
| CPU | AMD Ryzen 9 7950X |
| GPU | AMD Radeon RX 9070 XT |
| OS | NixOS (nixos-unstable) |

## Estructura

```
nixos-config/
├── flake.nix                     # Entrypoint: inputs, auto-descubrimiento de hosts, devShell
├── justfile                      # Tareas comunes (switch, build, deploy, fmt...)
├── hosts/
│   ├── _common/                  # Configuración compartida por todos los hosts
│   └── toledo/                   # Host principal (escritorio)
│       ├── default.nix
│       ├── disk.nix              # Particionado declarativo (disko)
│       └── hardware-configuration.nix
├── modules/
│   ├── davinci-resolve/          # DaVinci Resolve con workarounds para RDNA 4
│   ├── stylix/                   # Tema global (colores, fuentes, cursor)
│   ├── dots/                     # Dotfiles como módulos de Home Manager
│   │   ├── ghostty/              # Terminal
│   │   ├── niri/                 # Compositor Wayland
│   │   ├── nvf/                  # Neovim
│   │   ├── vscode/               # VSCode
│   │   ├── zen-browser/          # Navegador
│   │   ├── fastfetch/
│   │   ├── noctalia/
│   │   ├── obsidian/
│   │   └── tmux/
│   └── misc/
│       ├── agenix/               # Gestión de secretos
│       └── ryzen-undervolting/   # Límites de TDP via ryzenadj
├── users/
│   └── g4ng/
│       ├── default.nix           # Definición NixOS del usuario (uid, grupos, shell)
│       ├── dots.nix              # Imports de Home Manager (dotfiles + configuración base)
│       ├── git.nix               # Configuración de git
│       └── keys.nix              # Claves SSH públicas
└── secrets/
    └── secrets.nix               # Declaración de secretos para agenix
```

## Hosts

Los hosts se auto-descubren: cualquier subdirectorio en `hosts/` que no sea `_common` se registra automáticamente como `nixosConfiguration`. Para añadir un host nuevo basta con crear su directorio.

| Host | Descripción | Estado |
|------|-------------|--------|
| `toledo` | Escritorio principal | ✅ Activo |
| `nas` | NAS del homelab | 🔜 Planificado |
| `router` | Router/firewall | 🔜 Planificado |
| `laptop` | Portátil | 🔜 Planificado |

## Módulos destacados

### `modules/misc/ryzen-undervolting`

Ajuste de límites de TDP en CPUs AMD Ryzen via `ryzenadj`. Configurado para el 7950X con 65 W sostenidos y 88 W de boost.

```nix
misc.ryzen-undervolting.enable = true;

# Opciones con sus defaults:
# stapLimit = 65000;  # mW sostenido
# fastLimit = 88000;  # mW boost
# slowLimit = 65000;  # mW largo plazo
# tctlTemp  = 85;     # °C límite térmico
```

### `modules/davinci-resolve`

DaVinci Resolve funcional en GPUs RDNA 4 (RX 9070 XT). Incluye dos workarounds:
- **Rusticl** como backend OpenCL (en lugar del driver oficial de AMD, no compatible con RDNA 4)
- **Stub de `libProResRAW.so`** para evitar segfaults por incompatibilidad de ABI con GCC al usar Rusticl

### `modules/misc/agenix`

Wrapper para declarar secretos por host usando [agenix](https://github.com/ryantm/agenix). Los secretos se cifran con claves SSH y se guardan como ficheros `.age` en `secrets/`. Las claves públicas de usuario se centralizan en `users/g4ng/keys.nix`.

### `modules/stylix`

Tema unificado para todo el sistema vía [Stylix](https://github.com/danth/stylix): esquema de colores oscuro personalizado, fuente JetBrainsMono Nerd Font, cursor Bibata.

## Flujo de trabajo

Entra en el entorno de desarrollo para tener las herramientas disponibles:

```bash
nix develop
```

Esto proporciona: `just`, `nh`, `deadnix`, `nixfmt-rfc-style` y `agenix`.

### Tareas disponibles

```bash
just switch          # Aplica la configuración en el host actual
just dry-run         # Preview de cambios sin aplicar
just deploy <host>   # Aplica en un host remoto por SSH
just fmt             # Formatea el código Nix
just clean           # Elimina generaciones antiguas
just diff            # Muestra diferencias entre la generación actual y la nueva
just update          # Actualiza todos los inputs del flake
just update-input <input>  # Actualiza un input concreto
just secret <nombre> # Crea un nuevo secreto cifrado con agenix
```

## Secretos con agenix

1. Rellena tus claves públicas en `users/g4ng/keys.nix` y la clave del host en `secrets/secrets.nix`
2. Declara el secreto en `secrets/secrets.nix`
3. Créalo cifrado: `just secret nombre-del-secreto`
4. Referencíalo en el módulo: `config.age.secrets.nombre-del-secreto.path`

## Theming

El tema se gestiona íntegramente desde `modules/stylix/`. Cambiando el wallpaper o el esquema `base16` se propaga automáticamente a todos los programas integrados con Stylix (terminal, editor, compositor, etc.).

## Inspiración

- [notthebee/nix-config](https://git.notthebe.ee/notthebee/nix-config)
