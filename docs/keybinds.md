# Keybindings

## Niri (Window Manager)

`Mod` = Super/Windows. En el TBK Mini se obtiene manteniendo `F` o `J` (home-row mods, ver [tbk-mini.md](tbk-mini.md)).

Los atajos se definen en [`modules/programs/desktop/niri`](../modules/programs/desktop/niri/default.nix).

### Aplicaciones

| Keybind | Accion |
|---------|--------|
| `Mod + Return` | Abrir terminal (Ghostty) |
| `Mod + E` | Lanzador de apps (rofi drun) |
| `Mod + X` | Selector de directorios (`fsel` en `foot`) ¹ |
| `Mod + /` | Historial del portapapeles (`cliphist-select` en `foot`) ¹ |
| `Mod + Shift + /` | Borrar entrada del portapapeles (`cliphist-delete`) ¹ |

¹ `foot`, `fsel`, `cliphist`, `cliphist-select`/`cliphist-delete` y `wl-clipboard` no están
declarados en la configuración; estos atajos solo funcionan si se instalan aparte
(ver [known-issues](known-issues.md)).

El menú de energía está en el botón `󰐥` de waybar (apagar, reiniciar, hibernar, suspender, salir).

### Ventanas

| Keybind | Accion |
|---------|--------|
| `Mod + Backspace` | Cerrar ventana |
| `Mod + T` | Pantalla completa |
| `Mod + Shift + T` | Expandir columna al ancho disponible |
| `Mod + F` | Flotante on/off |
| `Mod + R` | Cambiar preset de ancho de columna |
| `Mod + Escape` | Toggle overview |
| `Mod + Shift + Backspace` | Salir de Niri |

### Navegacion (J=izq, K=arriba, L=abajo, Ñ=der)

Las columnas se recorren en horizontal (J/Ñ) y los workspaces en vertical (K/L).

| Keybind | Accion |
|---------|--------|
| `Mod + J` | Foco a columna izquierda |
| `Mod + ñ` | Foco a columna derecha |
| `Mod + K` | Foco a workspace arriba |
| `Mod + L` | Foco a workspace abajo |

### Mover ventanas

| Keybind | Accion |
|---------|--------|
| `Mod + Shift + J` | Mover columna a la izquierda |
| `Mod + Shift + ñ` | Mover columna a la derecha |
| `Mod + Shift + K` | Mover columna a workspace arriba |
| `Mod + Shift + L` | Mover columna a workspace abajo |

### Monitores

| Keybind | Accion |
|---------|--------|
| `Mod + Ctrl + J` | Foco a monitor izquierdo |
| `Mod + Ctrl + ñ` | Foco a monitor derecho |
| `Mod + Ctrl + Shift + J` | Mover columna a monitor izquierdo |
| `Mod + Ctrl + Shift + ñ` | Mover columna a monitor derecho |

### Workspaces

| Keybind | Accion |
|---------|--------|
| `Mod + 1-9` | Ir a workspace 1-9 |
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
| `Mod + Shift + S` | Captura de region (UI interactiva) |

Las capturas se guardan en `~/screenshots/`.

---

## Ghostty (Terminal)

| Keybind | Accion |
|---------|--------|
| `Super + Shift + Space` | Toggle terminal rapido (global, requiere soporte del compositor) |
| `Ctrl + =` | Aumentar tamaño de fuente |
| `Ctrl + -` | Disminuir tamaño de fuente |
| `Ctrl + .` | Aumentar fuente (alternativa base layer) |
| `Ctrl + ,` | Disminuir fuente (alternativa base layer) |
| `Ctrl + 0` | Resetear tamaño de fuente |
| `Ctrl + C` | Copiar |
| `Ctrl + V` | Pegar |

---

## Neovim (NVF)

`<leader>` = `Space`

### Modos

| Tecla | Modo |
|-------|------|
| `i` | Insert (antes del cursor) |
| `a` | Insert (despues del cursor) |
| `o` | Insert en linea nueva abajo |
| `O` | Insert en linea nueva arriba |
| `Esc` | Volver a Normal |
| `v` | Visual (caracter) |
| `V` | Visual (linea) |
| `Ctrl + v` | Visual (bloque/columna) |

### Navegacion — layout jklñ

| Tecla | Accion |
|-------|--------|
| `j` | ← izquierda |
| `k` | ↑ arriba |
| `l` | ↓ abajo |
| `ñ` | → derecha |
| `w` | Siguiente palabra |
| `b` | Palabra anterior |
| `e` | Final de palabra |
| `0` | Inicio de linea |
| `$` | Final de linea |
| `gg` | Inicio del archivo |
| `G` | Final del archivo |
| `Ctrl + d` | Scroll media pagina abajo |
| `Ctrl + u` | Scroll media pagina arriba |

### Seleccion y edicion

| Tecla | Accion |
|-------|--------|
| `v` + movimiento | Seleccionar |
| `viw` | Seleccionar palabra bajo cursor |
| `vi"` | Seleccionar dentro de comillas |
| `vi(` | Seleccionar dentro de parentesis |
| `y` | Copiar seleccion (al portapapeles del sistema) |
| `yy` | Copiar linea entera |
| `p` | Pegar despues del cursor |
| `P` | Pegar antes del cursor |
| `x` | Borrar caracter bajo el cursor |
| `dd` | Borrar linea entera |
| `dw` | Borrar desde cursor hasta fin de palabra |
| `diw` | Borrar palabra completa |
| `d$` | Borrar hasta fin de linea |
| `dl` | Borrar una linea abajo (d + movimiento) |
| `u` | Deshacer |
| `Ctrl + r` | Rehacer |
| `< / >` (visual) | Indentar izquierda/derecha y mantener seleccion |

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
| `Ctrl + j` | Ir a split izquierdo |
| `Ctrl + k` | Ir a split arriba |
| `Ctrl + l` | Ir a split abajo |
| `Ctrl + ñ` | Ir a split derecho |

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

### Git (Neogit / Telescope)

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
| `Alt + j` (normal) | Mover linea abajo |
| `Alt + k` (normal) | Mover linea arriba |
| `Alt + j` (visual) | Mover seleccion abajo |
| `Alt + k` (visual) | Mover seleccion arriba |

---

## TBK Mini (Teclado)

El keymap, las capas y el proceso de flasheo están documentados en [tbk-mini.md](tbk-mini.md).

Resumen rápido para usar los atajos anteriores:

- `Mod` = mantener `F` o `J`; `Ctrl` = mantener `S` o `L`; `Alt` = mantener `D`; `Shift` = mantener `A` o `;`.
- Números, F-keys, flechas (en `J K L ;`) y `- = [ ] \` en la capa SYM (pulgar izquierdo central).
- `Mod + 1-9` → mantener `F` + `SYM` + número.
- `Mod + -` / `Mod + =` → mantener `J` + `SYM` + tecla.
- Capa GAME (`SYM` + `N`) desactiva los home-row mods para jugar.
