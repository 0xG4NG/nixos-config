# Referencia de módulos

Leyenda de la columna **Tipo**: `NixOS` = se importa desde un host; `HM` = módulo home-manager, se importa desde `users/g4ng/dots/*.nix`.

Columna **Activación**: `opción` = se activa con `enable`; `import` = se aplica con solo importarlo.

## Índice

| Módulo | Tipo | Activación | Usado en |
|--------|------|------------|----------|
| [system/audio](#systemaudio) | NixOS | `misc.audio.enable` | toledo, laptop |
| [system/boot](#systemboot) | NixOS | `misc.boot-systemd.enable` | todos |
| [system/bluetooth](#systembluetooth) | NixOS | `misc.bluetooth.enable` | toledo, laptop |
| [system/desktop-base](#systemdesktop-base) | NixOS | `misc.desktop-base.enable` | toledo, laptop |
| [system/locale-es](#systemlocale-es) | NixOS | `misc.locale-es.enable` | todos |
| [network](#network) | NixOS | siempre (vía `_common`) | todos |
| [hardware/ddcutil](#hardwareddcutil) | NixOS | `misc.ddcutil.enable` | toledo |
| [hardware/keyboard/tbk-mini](#hardwarekeyboardtbk-mini) | NixOS | `hardware.tbk-mini.enable` | toledo |
| [programs/keyboard/qmk](#programskeyboardqmk) | NixOS | `hardware.qmk.enable` | toledo |
| [programs/keyboard/vial](#programskeyboardvial) | NixOS | `misc.vial.enable` | toledo |
| [programs/gaming](#programsgaming) | NixOS | `misc.gaming.enable` | toledo |
| [programs/gaming/heroic.nix](#programsgamingheroicnix) | NixOS | `misc.heroic.enable` | toledo |
| [programs/gaming/ddo.nix](#programsgamingddonix) | NixOS | `misc.ddo.enable` | toledo |
| [programs/virtualisation](#programsvirtualisation) | NixOS | `misc.virtualisation.enable` | toledo |
| [programs/browser/tor-browser](#programsbrowsertor-browser) | NixOS | `misc.tor-browser.enable` | toledo |
| [programs/browser/firefox](#programsbrowserfirefox) | HM | import | toledo, laptop |
| [programs/desktop/kde](#programsdesktopkde) | NixOS | `misc.kde.enable` | toledo |
| [programs/desktop/sddm](#programsdesktopsddm) | NixOS | import | toledo |
| [programs/desktop/bitwarden](#programsdesktopbitwarden) | NixOS | import | toledo |
| [programs/desktop/file-manager](#programsdesktopfile-manager) | NixOS | `misc.file-manager.enable` | toledo |
| [programs/desktop/orca-slicer](#programsdesktoporca-slicer) | NixOS | `misc.orca-slicer.enable` | toledo |
| [programs/desktop/niri](#programsdesktopniri) | HM | import | toledo, laptop |
| [programs/desktop/waybar](#programsdesktopwaybar) | HM | import | toledo, laptop |
| [programs/desktop/swaync](#programsdesktopswaync) | HM | `misc.swaync.enable` | toledo, laptop |
| [programs/desktop/rofi](#programsdesktoprofi) | HM | `misc.rofi.enable` | toledo, laptop |
| [programs/desktop/ghostty](#programsdesktopghostty) | HM | `misc.ghostty.enable` | toledo, laptop |
| [programs/desktop/cosmic](#programsdesktopcosmic) | HM | import | toledo, laptop |
| [programs/desktop/vscode](#programsdesktopvscode) | HM | import | toledo, laptop |
| [programs/cli/zsh](#programsclizsh) | HM | import | todos |
| [programs/cli/nvf](#programsclinvf) | HM | import | todos |
| [programs/cli/fastfetch · cava · cmatrix](#programsclifastfetch--cava--cmatrix) | HM | import | todos |
| [programs/media/davinci-resolve](#programsmediadavinci-resolve) | NixOS | import | toledo |
| [programs/media/mpv · imv](#programsmediampv--imv) | HM | import | toledo, laptop |
| [services/syncthing](#servicessyncthing) | NixOS | `misc.syncthing.enable` | toledo |
| [services/sunshine](#servicessunshine) | NixOS | `misc.sunshine.enable` | toledo |
| [services/enshrouded](#servicesenshrouded) | NixOS | `services.enshrouded.enable` | ninguno |
| [theming/stylix](#themingstylix) | NixOS | import | todos |
| [theming/qt](#themingqt) | HM | import | toledo, laptop |

---

## Sistema

### system/audio

Pipewire con ALSA (+32 bit), PulseAudio, JACK y rtkit.

| Opción | Default | Descripción |
|--------|---------|-------------|
| `misc.audio.enable` | `false` | Activa el módulo |
| `misc.audio.lowLatency` | `true` | `services.pipewire.lowLatency` de nix-gaming |

### system/boot

systemd-boot sobre EFI (`canTouchEfiVariables = true`).

| Opción | Default |
|--------|---------|
| `misc.boot-systemd.enable` | `false` |
| `misc.boot-systemd.configurationLimit` | `10` |
| `misc.boot-systemd.timeout` | `5` |

### system/bluetooth

`misc.bluetooth.enable` → bluez (encendido al arrancar) + blueman.

### system/desktop-base

Base para escritorios Wayland: `xdg.portal` con `xdg-desktop-portal-gtk`, `xdg-utils`.

| Opción | Default | Descripción |
|--------|---------|-------------|
| `misc.desktop-base.enable` | `false` | |
| `misc.desktop-base.gnomeKeyring` | `true` | gnome-keyring + desbloqueo PAM al entrar por SDDM |

### system/locale-es

Locale `es_ES.UTF-8` (más `en_US.UTF-8` soportado), zona horaria y teclado XKB; la consola usa el mismo layout (`console.useXkbConfig`).

| Opción | Default |
|--------|---------|
| `misc.locale-es.enable` | `false` |
| `misc.locale-es.timeZone` | `"Europe/Madrid"` |
| `misc.locale-es.keyboard.layout` | `"es"` |
| `misc.locale-es.keyboard.variant` | `""` |

### network

Sin opciones: la configuración sale de la tabla `profiles` indexada por `hostName`. Detalle en [architecture.md → Red](architecture.md#4-red).

---

## Hardware y teclado

### hardware/ddcutil

`misc.ddcutil.enable` → `hardware.i2c.enable` + paquete `ddcutil` (controlar brillo/entrada del monitor: `ddcutil setvcp 10 50`). El usuario necesita estar en el grupo `i2c` para usarlo sin sudo.

### hardware/keyboard/tbk-mini

Importado por el flake en **todos** los hosts. `hardware.tbk-mini.enable` instala el firmware compilado y el script `tbk-mini-flash`. Ver [tbk-mini.md](tbk-mini.md).

### programs/keyboard/qmk

| Opción | Tipo | Descripción |
|--------|------|-------------|
| `hardware.qmk.enable` | bool | Instala `qmk` y sus reglas udev genéricas |
| `hardware.qmk.users` | `listOf str` | Usuarios añadidos al grupo `plugdev` (se crea) |
| `hardware.qmk.devices` | `listOf { name, vid, pid }` | Genera reglas udev `hidraw`/`usb` con `TAG+="uaccess"` para que VIA/Vial funcionen vía WebHID en Chromium. VID/PID en hex minúscula sin `0x` |

### programs/keyboard/vial

Envuelve `vial` con `QT_SCALE_FACTOR` para pantallas HiDPI.

| Opción | Default |
|--------|---------|
| `misc.vial.enable` | `false` |
| `misc.vial.qtScaleFactor` | `2` (entero) |

---

## Gaming

### programs/gaming

`misc.gaming.enable`:

- Steam con sesión Gamescope y `platformOptimizations` de nix-gaming.
- Gamescope con `capSysNice`, GameMode.
- `hardware.graphics` con soporte 32 bit (mesa + vulkan-loader en ambas arquitecturas).
- `security.unprivilegedUsernsClone = true` (sandbox de Steam/Proton).

Recuerda añadir `steam`, `steam-original`, `steam-run`, `steam-unwrapped` a `misc.allowUnfreeNames`.

### programs/gaming/heroic.nix

`misc.heroic.enable` → Heroic Games Launcher (Epic, GOG, Amazon).

### programs/gaming/ddo.nix

Lanzador de Dragon's Dogma Online con Wine staging (WoW64) + DXVK.

| Opción | Descripción |
|--------|-------------|
| `misc.ddo.enable` | Activa el módulo |
| `misc.ddo.gamePath` | Ruta absoluta a `ddo_launcher.exe` (obligatoria) |

El comando `ddo` (y su `.desktop`) crea en el primer arranque un prefijo `~/.wine-ddo` (o `$WINEPREFIX`) en 32 bit, instala DXVK y .NET Desktop Runtime 9 con winetricks, y lanza el juego. Instala fuentes japonesas (`ipafont`, Noto CJK).

---

## Virtualización y red privada

### programs/virtualisation

| Opción | Descripción |
|--------|-------------|
| `misc.virtualisation.enable` | podman, libvirtd con swtpm (TPM virtual para Windows 11), virt-manager |
| `misc.virtualisation.user` | Usuario añadido al grupo `libvirtd` (obligatoria) |

### programs/browser/tor-browser

| Opción | Default | Descripción |
|--------|---------|-------------|
| `misc.tor-browser.enable` | `false` | Instala Tor Browser |
| `misc.tor-browser.enableTorService` | `true` | Daemon `tor` con cliente SOCKS5 en `127.0.0.1:9050` (útil para `torsocks` u otras apps) |

### programs/browser/firefox (HM)

Perfil `default` con:

- Extensiones de NUR: Bitwarden, uBlock Origin, Surfingkeys.
- VA-API, WebRender, selector de ficheros por portal.
- Pestañas compactas, sin barra de marcadores, `uidensity = 1`, sin botón de nueva pestaña (`userChrome`).
- Protección de rastreo, sin telemetría ni contenido patrocinado.
- Stylix tematiza el perfil `default`.

---

## Escritorio

### programs/desktop/kde

`misc.kde.enable` → Plasma 6 como sesión adicional; excluye `elisa` y `khelpcenter`.

### programs/desktop/sddm

Se aplica al importarlo. SDDM (en X11, `wayland.enable = false`) con el tema `sddm-astronaut-theme`; fuerza `pkgs.kdePackages.sddm` con `mkForce` porque Plasma 6 también define el paquete.

### programs/desktop/bitwarden

Se aplica al importarlo. Instala Bitwarden desktop + CLI y habilita `security.pam.sshAgentAuth`: `sudo` acepta la clave del agente SSH (p. ej. el agente SSH de Bitwarden) y conserva `SSH_AUTH_SOCK`.

### programs/desktop/file-manager

`misc.file-manager.enable` → Thunar, thunar-volman, tumbler (miniaturas) y gvfs (montaje automático, papelera, red).

### programs/desktop/orca-slicer

`misc.orca-slicer.enable` → OrcaSlicer envuelto para forzar X11 (`GDK_BACKEND=x11`, `QT_QPA_PLATFORM=xcb`), desactivar el renderer dmabuf de WebKit y los portales GTK, y exponer plugins de GStreamer y esquemas GSettings. Soluciona cuelgues y ventanas en blanco en Wayland.

### programs/desktop/niri (HM)

Genera `~/.config/niri/config.kdl`:

- Salidas `DP-1` (3840×2160@144, escala 1.5, x=0) y `DP-2` (x=2560); la tableta gráfica se mapea a `DP-2`. Específico de `toledo`.
- Layout XKB leído de `osConfig.services.xserver.xkb`.
- Al arrancar: `swaybg` con el wallpaper de Stylix, `cliphist` vigilando el portapapeles y `waybar`.
- Huecos de 32 px, columna única centrada, anchos predefinidos 1/2 · 2/3 · 1, borde 2 px (`#CBA6F7` activo), sin focus ring, esquinas rectas.
- Animaciones spring.
- Ventanas flotantes: `launcher`, `mpv`, `swayimg`, diálogos de Thunar.
- Atajos con navegación **J/K/L/Ñ** (ver [keybinds.md](keybinds.md)).
- Capturas en `~/screenshots/`.

### programs/desktop/waybar (HM)

Barra superior flotante (26 px, bordes redondeados): workspaces de niri a la izquierda; CPU, memoria, volumen (clic = mute), reloj (clic alterna formato, tooltip con calendario), bandeja y botón de apagado a la derecha. El botón abre `waybar-power-menu` (rofi dmenu: apagar, reiniciar, hibernar, suspender, salir de niri). Colores vía variables `@baseXX` de Stylix.

### programs/desktop/swaync (HM)

`misc.swaync.enable` → centro de notificaciones arriba a la derecha con widgets de inhibidores, título, no molestar, notificaciones y MPRIS.

### programs/desktop/rofi (HM)

`misc.rofi.enable` → lanzador `drun`/`run` con iconos Papirus, terminal ghostty y tema propio (ventana 500 px, borde de acento `base0E`). Desactiva el target de Stylix para usar el suyo.

### programs/desktop/ghostty (HM)

`misc.ghostty.enable` → sin decoraciones, padding 15 px, fuente 16 engrosada, cursor bloque, directorio inicial `~/nixos-config`, quick terminal global y atajos de zoom.

### programs/desktop/cosmic (HM)

Escribe la configuración de panel superior y dock de COSMIC en `~/.config/cosmic/`. Los cambios hechos desde la UI se pierden en el siguiente rebuild. Ningún host activa actualmente el escritorio COSMIC, por lo que solo deja ficheros de configuración.

### programs/desktop/vscode (HM)

VS Code con Stylix, extensiones `material-icon-theme` y `nix`, zoom 1 y ajustes para la extensión de Claude Code.

---

## CLI (HM)

### programs/cli/zsh

zsh con autosugerencias, resaltado de sintaxis, keymap emacs, completado insensible a mayúsculas y prompt **starship** (directorio, rama, estado git, duración).

Alias:

| Alias | Comando |
|-------|---------|
| `nfu` | `cd ~/nixos-config && nix flake update` |
| `nfc` | `cd ~/nixos-config && nix flake check` |
| `nse` | `nix search nixpkgs` |
| `nsh` | `nix shell nixpkgs#` |
| `ndev` | `nix develop` |
| `nrpl` | `nix repl '<nixpkgs>'` |
| `ngc` / `ngco` | `sudo nix-collect-garbage -d` / `nix-collect-garbage` |
| `ngen` | Lista generaciones del sistema |

Función `gcai`: genera un mensaje de commit con `claude --print` a partir de `git diff --cached` y abre el editor para confirmarlo.

### programs/cli/nvf

Neovim declarativo con nvf:

- Tema base16 (colores de Stylix), portapapeles del sistema, números de línea.
- LSP, formateo y treesitter para Nix, Bash, Lua, Markdown (sin formateo), TOML, YAML y JSON.
- lualine, telescope, nvim-cmp, neo-tree, gitsigns + neogit, indent-blankline, devicons.
- Movimiento remapeado a **j/k/l/ñ** (izquierda/arriba/abajo/derecha), también dentro de neo-tree. Atajos en [keybinds.md](keybinds.md#neovim-nvf).

### programs/cli/fastfetch · cava · cmatrix

- **fastfetch**: logo NixOS coloreado con la paleta de Stylix y módulos de sistema/hardware.
- **cava**: degradado de 4 colores (`base0D → base0A`).
- **cmatrix**: alias `cmatrix -C blue`.

### users/g4ng/git.nix y ssh.nix

- git: usuario `0xg4ng`, rama inicial `main`, `push.autoSetupRemote`.
- ssh: bloque `github.com` con la clave del secreto agenix `github_ssh` (solo existe en `laptop`; ver [known-issues](known-issues.md)).

---

## Media

### programs/media/davinci-resolve

Se aplica al importarlo. Hace funcionar DaVinci Resolve (gratuito) en RDNA 4:

- **OpenCL vía Rusticl** (`RUSTICL_ENABLE=radeonsi`, `mesa.opencl`) además de ROCm (`rocmPackages.clr`, `HSA_OVERRIDE_GFX_VERSION=11.0.0`, enlace `/opt/rocm/hip`).
- **Stub de `libProResRAW.so`**: la librería incluida exporta símbolos con un ABI antiguo de GCC que provocan segfaults bajo Rusticl; un wrapper antepone una versión vacía en `LD_LIBRARY_PATH`.
- Scripts auxiliares (la versión gratuita no decodifica H.264/H.265/AAC en Linux):
  - `davinci-import <ficheros…>` → transcodifica a DNxHR HQ + PCM (`.dnxhr.mov`).
  - `davinci-export <renders…>` → convierte el render a MP4 H.264 CRF 18 + AAC 192k.
- Incluye `clinfo` para depurar OpenCL.

Requiere `davinci-resolve` en `misc.allowUnfreeNames`.

### programs/media/mpv · imv (HM)

- **mpv**: perfil `high-quality`, `gpu-next`, decodificación por hardware segura, recuerda la posición. Asociado a los tipos de vídeo y audio comunes.
- **imv**: visor de imágenes con fondo negro, asociado a JPEG, PNG, GIF, WebP, AVIF, JXL, BMP, TIFF y SVG.

---

## Servicios

### services/syncthing

Envoltorio de `services.syncthing` con rol cliente/servidor.

| Opción | Default | Descripción |
|--------|---------|-------------|
| `misc.syncthing.enable` | `false` | |
| `misc.syncthing.role` | `"client"` | `server` abre los puertos por defecto y expone la GUI en `0.0.0.0:8384` (+ firewall); `client` la deja en `127.0.0.1:8384` |
| `misc.syncthing.user` | — | Usuario del servicio |
| `misc.syncthing.dataDir` | — | Directorio de datos |
| `misc.syncthing.overrideDevices` | `true` | Borra dispositivos no declarados |
| `misc.syncthing.overrideFolders` | `true` | Borra carpetas no declaradas |
| `misc.syncthing.devices.<nombre>` | `{}` | `{ id; autoAcceptFolders ? false; }` |
| `misc.syncthing.folders.<id>` | `{}` | `{ path; devices ? []; type ? "sendreceive"; }` |

### services/sunshine

| Opción | Default | Descripción |
|--------|---------|-------------|
| `misc.sunshine.enable` | `false` | Servidor de streaming para Moonlight con `capSysAdmin` (captura KMS) |
| `misc.sunshine.openFirewall` | `true` | Abre los puertos de Moonlight |

La GUI de emparejamiento está en `https://localhost:47990`.

### services/enshrouded

Servidor dedicado de Enshrouded bajo Wine, gestionado por systemd. No lo activa ningún host.

| Opción | Default | Descripción |
|--------|---------|-------------|
| `services.enshrouded.enable` | `false` | |
| `dataDir` | `/var/lib/enshrouded` | Instalación, partidas, logs y prefijo Wine |
| `user` / `group` | `enshrouded` | Usuario de sistema creado automáticamente |
| `serverName` | `"Enshrouded NixOS Server"` | |
| `password` | `""` | Texto plano (acaba en el store; evitar) |
| `passwordFile` | `null` | Fichero con la contraseña (p. ej. secreto agenix); se inyecta con `jq` en el arranque |
| `slotCount` | `16` | 1–16 |
| `gamePort` / `queryPort` | `15636` / `15637` | UDP |
| `openFirewall` | `true` | |
| `autoUpdate` | `true` | Ejecuta SteamCMD (app 2278520) antes de cada arranque |

El JSON de configuración se **copia** (no se enlaza) en cada arranque porque el servidor lo reescribe. El servicio corre con `ProtectSystem=strict`, `ProtectHome`, `PrivateTmp` y `NoNewPrivileges`.

---

## Theming

### theming/stylix

Ver [architecture.md → Theming](architecture.md#5-theming). Desactiva el target `kmscon` (usa opciones eliminadas de nixpkgs).

### theming/qt (HM)

Qt con Kvantum (`KvGnomeDark`), forzando `QT_QPA_PLATFORMTHEME` y `QT_STYLE_OVERRIDE`.
