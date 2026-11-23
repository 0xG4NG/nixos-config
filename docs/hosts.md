# Hosts

Cada host vive en `hosts/<nombre>/` y se compone de:

| Fichero | Propósito |
|---------|-----------|
| `default.nix` | Qué módulos importa/activa, paquetes, servicios, home-manager, `stateVersion` |
| `disk.nix` / `disko.nix` | Layout de disco declarativo con disko |
| `hardware-configuration.nix` / `hardware.nix` | Módulos de kernel y microcódigo (generado por `nixos-generate-config`) |

---

## toledo

Escritorio principal. AMD Ryzen 9 7950X, Radeon RX 9070 XT (RDNA 4), dos monitores 4K@144 Hz (`DP-1`, `DP-2`, escala 1.5).

### Disco

[`disk.nix`](../hosts/toledo/disk.nix) usa `disko.enableConfig = false`: el layout está **solo documentado** (ESP 1 G vfat + raíz ext4 1829 G + swap con el resto en `/dev/nvme0n1`), y los montajes reales salen de `hardware-configuration.nix` con UUIDs. Así se puede reinstalar con disko sin que cambie el sistema actual.

### Red

NetworkManager con perfil estático `static-eth` → `192.168.1.101/24`.

### Escritorio

- **Niri** (`programs.niri.enable`) como compositor principal, con waybar, swaync, rofi y ghostty (vía home-manager).
- **KDE Plasma 6** como sesión alternativa (`misc.kde.enable`), seleccionable desde **SDDM** (tema `sddm-astronaut`, SDDM en X11).
- Xserver con `amdgpu`, `amdgpu` en initrd, gobernador `schedutil`.
- Thunar + gvfs (`misc.file-manager`), Flatpak, Bitwarden con autenticación sudo vía agente SSH.

### Módulos activados

| Área | Módulos |
|------|---------|
| Sistema | `misc.audio`, `misc.bluetooth`, `misc.desktop-base`, `misc.locale-es`, `misc.boot-systemd` (10 generaciones, timeout 15 s) |
| Gaming | `misc.gaming` (Steam + Gamescope + GameMode), `misc.heroic`, `misc.ddo` (Dragon's Dogma Online vía Wine), caché `nix-gaming.cachix.org`, `mo2installer` |
| Media | DaVinci Resolve (con workarounds RDNA 4), OBS, darktable |
| Streaming | `misc.sunshine` (Moonlight, firewall abierto) |
| Virtualización | `misc.virtualisation` (podman, libvirtd + swtpm, virt-manager), distrobox |
| Hardware | `misc.ddcutil` (brillo del monitor por DDC/CI), `hardware.qmk` (udev para el TBK Mini `a8f8:1828`), `hardware.tbk-mini` (firmware + `tbk-mini-flash`), `misc.vial` |
| Privacidad | `misc.tor-browser` (Tor Browser + daemon tor SOCKS5 en `127.0.0.1:9050`) |
| 3D | `misc.orca-slicer` (wrapper X11), LycheeSlicer, FreeCAD |
| Sync | `misc.syncthing` en rol `client`: carpeta `~/Documents` ↔ dispositivo `proxmox` |

Otros: `programs.nix-ld` con libs básicas (para binarios no Nix), OpenSSH sin contraseña y sin abrir firewall, `electron-39.8.10` permitido como paquete inseguro.

Paquetes sueltos: `nixos-anywhere`, `agenix`, `btop-rocm`, `obsidian`, `vesktop`, `chromium`, `freecad`, `claude-code`, `ilspycmd`, `ffmpeg`, `unzip`…

### Secretos

- `g4ng_password` (vía `users/g4ng`).
- Declara `git_email` y un activation script que genera `/run/secrets/gitconfig`, pero ese secreto ya no existe en el repo (ver [known-issues](known-issues.md)).

`stateVersion = "25.11"`.

---

## laptop

Portátil con Intel UHD (`PCI:0:2:0`) + NVIDIA RTX 3060 (`PCI:1:0:0`).

### Disco

[`disko.nix`](../hosts/laptop/disko.nix): disko **gestiona** los montajes.

```
/dev/nvme0n1 (GPT)
├── ESP   1G   vfat → /boot (umask=0077)
└── luks  100% → cryptroot (allowDiscards)
    └── btrfs (compress=zstd, noatime)
        ├── @root → /
        ├── @home → /home
        ├── @nix  → /nix
        ├── @log  → /var/log
        └── @swap → /.swapvol (swapfile 16G)
```

`passwordFile = "/tmp/secret.key"` solo se usa durante la instalación (`nixos-anywhere --disk-encryption-keys /tmp/secret.key <fichero>`); en cada arranque se pide la contraseña de LUKS.

### Gráficos

Driver NVIDIA estable **abierto** (Ampere), modesetting, PRIME **offload** (`nvidia-offload <app>` para usar la dGPU) y `powerManagement.finegrained` para apagar la 3060 cuando no se usa. `power-profiles-daemon` para la batería.

### Escritorio

SDDM (Wayland) + KDE Plasma 6 configurados directamente en el host (no usa `misc.kde` ni el módulo `sddm`). Home-manager carga también el perfil `desktop.nix` (niri, waybar…), aunque el host no habilita `programs.niri`.

### Módulos y extras

`misc.audio`, `misc.bluetooth`, `misc.desktop-base`, `misc.locale-es`, `misc.boot-systemd`. Steam, Firefox, podman y `nix-ld` activados directamente.

### Secretos

- `age.identityPaths` añade la clave SSH del host (se fusiona con la lista de `_common`).
- `g4ng_password` y `github_ssh` (clave privada SSH de GitHub, propiedad de `g4ng`, referenciada en `~/.ssh/config` por `users/g4ng/ssh.nix`).
- Es el único host cuya clave está en [`secrets.nix`](../secrets.nix).

`stateVersion = "26.05"`.

---

## router

Nodo headless del homelab (antes `xeon`/`servidor`). Estado WIP.

- `hardware-configuration.nix` es un placeholder vacío: se debe generar en la primera instalación (`nixos-anywhere --generate-hardware-config nixos-generate-config ./hosts/router/hardware-configuration.nix`).
- [`disk.nix`](../hosts/router/disk.nix): ESP 1 G + raíz ext4 en `/dev/nvme0n1`, gestionado por disko.
- Red estática en `eno1` → `192.168.1.100/24` sin NetworkManager.
- OpenSSH con `PasswordAuthentication = false`, `PermitRootLogin = "prohibit-password"` y puerto 22 abierto.
- Solo `misc.locale-es` y `misc.boot-systemd` (timeout 3 s). Sin audio, bluetooth ni escritorio.
- Home-manager solo con `dots/common.nix`. Importa Stylix porque nvf necesita los colores base16.

`stateVersion = "25.11"`.

---

## Añadir un host nuevo

1. **Crear la carpeta** `hosts/<nombre>/` con al menos `default.nix`. Plantilla mínima:

   ```nix
   { ... }:
   {
     imports = [
       ./hardware-configuration.nix
       ./disk.nix
       ../../users/g4ng
       ../../modules/theming/stylix   # necesario si usas nvf (dots/common.nix)
     ];

     misc.locale-es.enable = true;
     misc.boot-systemd.enable = true;

     home-manager = {
       useGlobalPkgs       = true;
       useUserPackages     = true;
       backupFileExtension = "backup";
       users.g4ng.imports  = [ ../../users/g4ng/dots/common.nix ];
     };

     system.stateVersion = "26.05";
   }
   ```

2. **Perfil de red**: añadir una entrada en `profiles` de [`modules/network/default.nix`](../modules/network/default.nix) (`type = "networkmanager"` o `"static"` con `address`, `iface`, `prefix`, `gateway`).
3. **Disco**: escribir `disk.nix` para disko (revisa el dispositivo con `lsblk`).
4. **Secretos**: obtener la clave pública SSH del host (`ssh-keyscan <ip>` o `/etc/ssh/ssh_host_ed25519_key.pub`), añadirla en [`secrets.nix`](../secrets.nix) a los secretos que necesite y recifrar con `agenix -r`. Ver [secrets.md](secrets.md).
5. **Instalar**: `just install <nombre> root@<ip>` (ver [workflow.md](workflow.md#instalación-desde-cero)).
6. `git add` la carpeta nueva: los flakes ignoran los ficheros no rastreados por git.
