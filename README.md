# nixos-config

Configuración declarativa de NixOS para un pequeño parque de máquinas personales (escritorio, portátil y un nodo de homelab), gestionada con **flakes**, **home-manager** y **agenix**.

- Los hosts se **auto-descubren**: cada carpeta en `hosts/` (salvo `_common`) se convierte en una `nixosConfiguration`.
- Casi todos los módulos son **opt-in** mediante opciones `misc.<módulo>.enable`, de modo que cada host elige lo que necesita.
- Tema unificado con **Stylix** (base16 oscuro, Iosevka Nerd Font, cursor Bibata) aplicado a terminal, editor, compositor, GTK y Qt.
- Incluye firmware **QMK/Vial** propio para el teclado split TBK Mini, compilado de forma reproducible con Nix.

## Hosts

| Host | Rol | Hardware | Escritorio | Estado |
|------|-----|----------|------------|--------|
| [`toledo`](docs/hosts.md#toledo) | Escritorio principal | AMD Ryzen 9 7950X · Radeon RX 9070 XT (RDNA 4) · 2× 4K@144 | Niri (Wayland) + KDE Plasma 6 | Activo |
| [`laptop`](docs/hosts.md#laptop) | Portátil | Intel (UHD) + NVIDIA RTX 3060 (PRIME offload) · LUKS + btrfs | KDE Plasma 6 | Activo |
| [`router`](docs/hosts.md#router) | Nodo homelab headless | NVMe, IP estática `192.168.1.100` | — (solo SSH) | WIP |

## Stack

| Input | Uso |
|-------|-----|
| `nixpkgs` (`nixos-unstable`) | Paquetes y módulos base |
| `home-manager` | Dotfiles del usuario `g4ng` |
| `disko` | Particionado declarativo (usado por `nixos-anywhere`) |
| `stylix` | Theming global |
| `nvf` | Neovim declarativo |
| `agenix` | Secretos cifrados con age |
| `nix-gaming` | Optimizaciones de plataforma, Pipewire low-latency, `mo2installer` |
| `NUR` | Extensiones de Firefox (`rycee.firefox-addons`) |

## Inicio rápido

```bash
git clone git@github.com:0xg4ng/nixos-config.git ~/nixos-config
cd ~/nixos-config
nix develop        # just, nh, agenix, age, deadnix, nixfmt, nixos-anywhere
just switch        # aplica la configuración del host actual (nh os switch)
```

`nh` detecta el host por `hostname`, así que el nombre de la máquina debe coincidir con la carpeta de `hosts/`.

Comandos más usados (lista completa en [docs/workflow.md](docs/workflow.md)):

```bash
just dry-run                         # build sin aplicar
just deploy router 192.168.1.100     # aplica en un host remoto por SSH
just install router root@192.168.1.100  # instalación desde cero con nixos-anywhere
just update                          # nix flake update
just fmt                             # deadnix + nixfmt
just tbk-flash                       # flashea una mitad del TBK Mini
```

## Estructura

```
nixos-config/
├── flake.nix          # Inputs, mkHost, auto-descubrimiento de hosts, paquete firmware, devShell
├── flake.lock
├── justfile           # Tareas: switch, deploy, install, fmt, update, tbk-flash…
├── secrets.nix        # Destinatarios age de cada secreto (agenix)
├── secrets/           # *.age cifrados
├── docs/              # Documentación (ver índice abajo)
├── hosts/
│   ├── _common/       # Base de todos los hosts + opciones misc.allowUnfreeNames / allowInsecureNames
│   ├── toledo/        # Escritorio
│   ├── laptop/        # Portátil
│   └── router/        # Homelab headless
├── modules/
│   ├── hardware/      # ddcutil, firmware TBK Mini
│   ├── network/       # Perfiles de red por host (NM o estática) + /etc/hosts
│   ├── programs/      # browser, cli, desktop, gaming, keyboard, media, virtualisation
│   ├── services/      # syncthing, sunshine, enshrouded
│   ├── system/        # audio, boot, bluetooth, desktop-base, locale-es
│   └── theming/       # stylix, qt (Kvantum)
└── users/g4ng/        # Usuario del sistema + perfiles home-manager (common / desktop)
```

## Documentación

| Documento | Contenido |
|-----------|-----------|
| [docs/architecture.md](docs/architecture.md) | Cómo se construye un host: flake, `mkHost`, capas, patrones de módulo, NixOS vs home-manager |
| [docs/hosts.md](docs/hosts.md) | Cada host en detalle y guía para añadir uno nuevo |
| [docs/modules.md](docs/modules.md) | Referencia de todos los módulos y sus opciones |
| [docs/secrets.md](docs/secrets.md) | Gestión de secretos con agenix |
| [docs/workflow.md](docs/workflow.md) | devShell, recetas de `just`, instalación y despliegue remoto, mantenimiento |
| [docs/tbk-mini.md](docs/tbk-mini.md) | Firmware QMK/Vial del TBK Mini: compilación, keymap y flasheo |
| [docs/keybinds.md](docs/keybinds.md) | Atajos de Niri, Ghostty y Neovim |
| [docs/known-issues.md](docs/known-issues.md) | Problemas detectados en la configuración actual y cosas pendientes |
