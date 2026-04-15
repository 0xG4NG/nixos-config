# Keybindings

## Niri (Window Manager)


`Mod` = Super/Windows key

### Aplicaciones

| Keybind | Accion |
|---------|--------|
| `Mod + Return` | Abrir terminal (Ghostty) |
| `Mod + E` | Toggle launcher (Noctalia) |
| `Mod + X` | Selector de directorios (fsel) |
| `Mod + /` | Portapapeles (cliphist) |
| `Mod + Shift + /` | Borrar entrada del portapapeles |

### Ventanas

| Keybind | Accion |
|---------|--------|
| `Mod + Q` | Cerrar ventana |
| `Mod + T` | Pantalla completa |
| `Mod + Shift + T` | Expandir columna al ancho disponible |
| `Mod + F` | Flotante on/off |
| `Mod + R` | Cambiar preset de ancho de columna (40%/60%) |
| `Mod + Escape` | Toggle overview |

### Navegacion (J=izq, K=arriba, L=abajo, ;=der)

| Keybind | Accion |
|---------|--------|
| `Mod + J` | Foco a columna izquierda |
| `Mod + ;` | Foco a columna derecha |
| `Mod + K` | Foco a workspace arriba |
| `Mod + L` | Foco a workspace abajo |

### Mover ventanas

| Keybind | Accion |
|---------|--------|
| `Mod + Shift + J` | Mover columna a la izquierda |
| `Mod + Shift + ;` | Mover columna a la derecha |
| `Mod + Shift + K` | Mover columna a workspace arriba |
| `Mod + Shift + L` | Mover columna a workspace abajo |

### Monitores

| Keybind | Accion |
|---------|--------|
| `Mod + Ctrl + J` | Foco a monitor izquierdo |
| `Mod + Ctrl + ;` | Foco a monitor derecho |
| `Mod + Ctrl + Shift + J` | Mover columna a monitor izquierdo |
| `Mod + Ctrl + Shift + ;` | Mover columna a monitor derecho |

### Workspaces

| Keybind | Accion |
|---------|--------|
| `Mod + 1-9` | Ir a workspace 1-9 (requiere chord L1 en TBK) |
| `Mod + Shift + 1-9` | Mover ventana a workspace 1-9 |

### Redimensionado

| Keybind | Accion |
|---------|--------|
| `Mod + -` | Columna mas estrecha (-10%) |
| `Mod + =` | Columna mas ancha (+10%) |
| `Mod + Ctrl + -` | Ventana mas baja (-10%) |
| `Mod + Ctrl + =` | Ventana mas alta (+10%) |

### Audio

| Keybind | Accion |
|---------|--------|
| `Mod + ,` | Bajar volumen 5% |
| `Mod + .` | Subir volumen 5% |
| `Mod + M` | Mute toggle |
| `XF86AudioRaiseVolume` | Subir volumen (teclados externos) |
| `XF86AudioLowerVolume` | Bajar volumen (teclados externos) |
| `XF86AudioMute` | Mute (teclados externos) |

### Capturas de pantalla

| Keybind | Accion |
|---------|--------|
| `Mod + S` | Captura de pantalla completa |
| `Mod + Shift + S` | Captura de region |

### Sesion

| Keybind | Accion |
|---------|--------|
| `Mod + P` | Menu de energia (rofi) |
| `Mod + Shift + Q` | Salir de Niri |

---

## Ghostty (Terminal)

| Keybind | Accion |
|---------|--------|
| `Cmd + Shift + Space` | Toggle terminal rapido (global) |
| `Ctrl + =` | Aumentar tamaño de fuente |
| `Ctrl + -` | Disminuir tamaño de fuente |
| `Ctrl + .` | Aumentar fuente (alternativa base layer) |
| `Ctrl + ,` | Disminuir fuente (alternativa base layer) |
| `Ctrl + 0` | Resetear tamaño de fuente |

---

## Noctalia Shell (Menu de sesion)

Dentro del menu de power:

| Keybind | Accion |
|---------|--------|
| `1` | Bloquear |
| `2` | Suspender |
| `3` | Hibernar |
| `4` | Reiniciar |
| `5` | Cerrar sesion |
| `6` | Apagar |
| `7` | Reiniciar a UEFI |

---

## Neovim (NVF)

`<leader>` = `Space`

### Explorador de archivos (Neo-tree)

| Keybind | Accion |
|---------|--------|
| `Space + e` | Toggle explorador |
| `Space + o` | Foco al explorador |

### Telescope (buscador)

| Keybind | Accion |
|---------|--------|
| `Space + ff` | Buscar archivos |
| `Space + fg` | Buscar texto (grep) |
| `Space + fb` | Buscar buffers |
| `Space + fh` | Buscar ayuda |
| `Space + fr` | Archivos recientes |
| `Space + fd` | Buscar diagnosticos |

### Buffers

| Keybind | Accion |
|---------|--------|
| `Space + x` | Cerrar buffer |
| `Tab` | Buffer siguiente |
| `Shift + Tab` | Buffer anterior |

### Ventanas / Splits

| Keybind | Accion |
|---------|--------|
| `Space + sv` | Split vertical |
| `Space + sh` | Split horizontal |
| `Space + sx` | Cerrar split |
| `Ctrl + j/k/l/;` | Navegar entre splits (izq/arriba/abajo/der) |

### LSP

| Keybind | Accion |
|---------|--------|
| `gd` | Ir a definicion |
| `gr` | Ver referencias |
| `K` | Hover info |
| `Space + ca` | Code actions |
| `Space + rn` | Renombrar simbolo |
| `Space + dn` | Siguiente diagnostico |
| `Space + dp` | Anterior diagnostico |

### Git

| Keybind | Accion |
|---------|--------|
| `Space + gg` | Abrir Neogit |
| `Space + gb` | Git branches |
| `Space + gc` | Git commits |
| `Space + gs` | Git status |

### Utilidades

| Keybind | Accion |
|---------|--------|
| `Space + w` | Guardar |
| `Space + q` | Salir |
| `Space + h` | Quitar highlight de busqueda |
| `Alt + j/k` | Mover linea arriba/abajo |
| `Alt + j/k` (visual) | Mover seleccion arriba/abajo |
| `< / >` (visual) | Indentar y mantener seleccion |

---

## VSCode

Sin keybindings personalizados. Usa los defaults de VSCode.

---

## TBK Mini (Teclado)

Split 42 teclas (3x6 + 3 pulgares por lado). Layout físico y capas definidas
en el repo [tbk-mini-keymap](https://github.com/0xg4ng/tbk-mini-keymap) (`tbk_mini.layout.json`).

### Layer 0 — Base (QWERTY)

```
 ESC    Q  W  E  R  T  │  Y  U  I  O  P   BSPC
 TAB    A  S  D  F  G  │  H  J  K  L  ;   '
LSFT    Z  X  C  V  B  │  N  M  ,  .  /   RSFT
           GUI  L1 SPC │ ENT L2 CTL
```

- `GUI` (thumb izq exterior) = `Mod` de niri
- `CTL` (thumb der exterior) = Control
- `L1` / `L2` = `MO(1)` / `MO(2)` (mantener para cambiar de capa)
- Sostener `L1` + `L2` simultaneamente → capa adjust (L3)

### Layer 1 — Numeros / Navegacion (mantener `L1`)

```
  `    1  2  3  4  5  │  6    7    8   9   0    DEL
 TAB   .  .  .  .  .  │  ←    ↓    ↑   →   .    .
LSFT   .  .  C  V  .  │ HOME PGDN PGUP END .    .
           .  L1  SPC │ ENT  L3  RALT
```

- `C` / `V` en posiciones base de C/V → macros `Ctrl+C` / `Ctrl+V`
- `RALT` (AltGr) queda en el thumb derecho exterior al estar en L1
- `L3` en thumb der medio cuando se sostiene L1 (para llegar al layer adjust)

### Layer 2 — Simbolos / F-keys / Acentos (mantener `L2`)

```
  .    F1 F2 é  F4 F5  │  F6  ú  í  ó  F10 F11
 TAB    á  @  #  $  %  │   ^   &  *  (  )  F12
LSFT    .  .  .  .  .  │   ñ   -  =  [  ]   \
           .  L3 SPC   │ ENT  .   .
```

- `ñ` esta en la posicion base de `N` (layer 2 + N = macro `RALT+N`)
- Vocales acentuadas en sus posiciones base: `L2 + A/E/I/O/U` = `á/é/í/ó/ú`
  (funciona gracias al xkb variant `altgr-intl`)
- Perdidas aceptadas: `!` (usar `Shift+1`), `F3`, `F7`, `F8`, `F9`
- `L3` en thumb izq medio cuando se sostiene L2

### Layer 3 — Adjust (L1 + L2 o tri-layer)

```
 RST    .  .  .  .  .  │  .    .    .   . MOD  TOG
  .     .  .  .  .  .  │ V-    V+   S- S+ H-   H+
  .     .  .  .  .  .  │ ⏭    ⏯    ⏮  🔊 🔉  🔇
```

- `RST` en la esquina superior izquierda = reset del firmware (bootloader)
- Fila superior derecha: controles RGB
- Fila inferior derecha: media (XF86AudioNext/Play/Prev/VolumeUp/Down/Mute)

### Macros definidas

| Slot | Contenido | Uso |
|------|-----------|-----|
| `MACRO(0)` | `RALT + N` | ñ (via xkb `us` variant `altgr-intl`) |
| `MACRO(1)` | `Ctrl + C` | Copiar |
| `MACRO(2)` | `Ctrl + V` | Pegar |
| `MACRO(3)` | `Ctrl + Shift + C` | Copiar (terminal) |
| `MACRO(4)` | `Ctrl + Shift + V` | Pegar (terminal) |
| `MACRO(5)` | `RALT + A` | á |
| `MACRO(6)` | `RALT + E` | é |
| `MACRO(7)` | `RALT + I` | í |
| `MACRO(8)` | `RALT + O` | ó |
| `MACRO(9)` | `RALT + U` | ú |

### Notas ergonomicas

- **Numeros en workspaces**: `Mod + N` requiere sostener `GUI + L1 + N` (tres teclas).
  Para saltar de workspace rapido es mejor usar `Mod + J` / `Mod + K`.
- **Resize de columna**: `Mod + -` / `Mod + =` requiere `GUI + L2 + tecla` (chord),
  aceptable porque se usa poco.
- **Audio**: `Mod + , / . / M` estan todos en capa base → acceso directo sin chord.
- **`Mod + Ctrl + Shift + H/L`** (mover columna entre monitores) requiere 4 teclas;
  usar ambas manos (thumb izq `GUI`, thumb der `CTL`, pinky `LSFT`, indice `H/L`).
