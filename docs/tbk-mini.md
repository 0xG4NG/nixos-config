# TBK Mini (firmware QMK/Vial)

Teclado split de 42 teclas (3×6 + 3 pulgares por mitad) de Bastard Keyboards con controlador **Splinky v3** (RP2040). VID:PID `a8f8:1828`.

El firmware se compila de forma reproducible desde [vial-qmk](https://github.com/vial-kb/vial-qmk) con el keymap de este repo, de modo que se puede reconfigurar en vivo con **Vial** sin reflashear.

## Ficheros

```
modules/hardware/keyboard/tbk-mini/
├── default.nix           # Opción hardware.tbk-mini.enable → instala firmware + tbk-mini-flash
├── nix/
│   ├── firmware.nix      # Derivación que compila el .uf2
│   └── flash.nix         # Script tbk-mini-flash
├── keymap/               # Se copia a keyboards/bastardkb/tbkmini/keymaps/g4ng
│   ├── keymap.c          # Capas por defecto del firmware
│   ├── config.h          # Tapping, nº de capas, UID y combo de desbloqueo de Vial
│   ├── rules.mk          # VIA/Vial activados; LTO, mousekeys, consola y command desactivados
│   └── vial.json         # Definición de matriz/layout para Vial
└── via/                  # Copias de seguridad de configuraciones (no se usan en la compilación)
    ├── vialconfig.vil    # Export de Vial (estado guardado en la EEPROM en algún momento)
    ├── tbk_mini.layout.json
    └── tbk_mini.layout4.json
```

La integración con el sistema (reglas udev para WebHID/Vial y grupo `plugdev`) está en [`modules/programs/keyboard/qmk`](../modules/programs/keyboard/qmk/default.nix); el wrapper HiDPI de Vial, en [`modules/programs/keyboard/vial`](../modules/programs/keyboard/vial/default.nix).

## Compilación

`nix/firmware.nix` es una función `{ keymapSrc }: { pkgs }: derivation`:

1. Descarga `vial-kb/vial-qmk` en un commit fijado (con submódulos).
2. Copia `keymap/` como keymap `g4ng` de `bastardkb/tbkmini`.
3. Compila `make bastardkb/tbkmini/v2/splinky_3:g4ng` con `gcc-arm-embedded-13`.
4. Instala los `.uf2`/`.hex`/`.bin` producidos en `$out`.

```bash
nix build .#firmware      # → result/*.uf2
```

Para actualizar vial-qmk: cambia `qmkRev`, pon `qmkHash = lib.fakeHash` (o una cadena vacía), compila y copia el hash que muestra el error.

## Flasheo

1. Pon una mitad en modo bootloader: doble pulsación del botón de reset del Splinky. Aparece un volumen USB `RPI-RP2`.
2. Elige un método:

   | Método | Qué hace |
   |--------|----------|
   | `tbk-mini-flash` | Se relanza con sudo, espera hasta 30 s a `RPI-RP2`, copia el `.uf2`, espera a que se desmonte y repite con la **segunda mitad** |
   | `just tbk-flash` | Flashea **una** mitad (espera 30 s, monta en `/mnt/rpi`, copia, `sync`). Repetir para la otra |

   Manual: copiar `result/*.uf2` al volumen `RPI-RP2`.
3. La mitad se reinicia sola al terminar la copia.

Tras un flasheo, Vial puede mantener el keymap antiguo guardado en EEPROM. Para volver al de `keymap.c`, usa la tecla `EE_CLR` (capa SYM, esquina superior izquierda) y reconecta.

## Ajustes (`config.h`)

| Ajuste | Valor | Efecto |
|--------|-------|--------|
| `TAPPING_TERM` | 400 ms | Tiempo para distinguir pulsación de mantener (home-row mods) |
| `PERMISSIVE_HOLD` | on | Si otra tecla se pulsa y suelta dentro de la tecla dual, cuenta como mantener |
| `TAPPING_FORCE_HOLD` | on | Pulsar-y-mantener rápido no autorrepite; siempre activa el modificador |
| `DYNAMIC_KEYMAP_LAYER_COUNT` | 3 | Capas editables en Vial |
| `VIAL_UNLOCK_COMBO` | filas `{0,0}`, columnas `{0,5}` | Para desbloquear Vial: mantener **Esc + T** |
| `VIAL_*_ENABLE` | combo, tap dance, key override | Gestionados desde Vial |

## Keymap por defecto (`keymap.c`)

### Capa 0 — BASE (QWERTY con home-row mods)

```
 ESC    Q    W    E    R    T   │   Y    U    I    O    P   ENT
CAPS  A/⇧  S/⌃  D/⌥  F/◆   G   │   H  J/◆  K/⌥  L/⌃  ;/⇧   '
^C     Z    X    C    V    B   │   N    M    ,    .    /   RSFT
               TAB  SYM  SPC   │ BSPC RALT ENT
```

- **Home-row mods**: mantener `A`=Shift, `S`=Ctrl, `D`=Alt, `F`=Super, y en espejo `J`=Super, `K`=AltGr (RAlt), `L`=Ctrl, `;`=Shift.
- `Mod` de niri = mantener **F** (o **J**). Ejemplo: `F`(mantener) + `Enter` abre la terminal.
- `^C` (esquina inferior izquierda) envía `Ctrl+C`.
- `SYM` = `MO(1)`: capa SYM mientras se mantiene.
- `RALT` en el pulgar derecho: AltGr.

### Capa 1 — SYM (mantener `SYM`)

```
EE_CLR  1    2    3    4    5   │   6    7    8    9    0   ENT
 TAB   F1   F2   F3   F4   F5   │  F6    ←    ↑    ↓    →    ñ*
LSFT   á*   é*   í*   ó*   ú*   │ GAME   -    =    [    ]    \
               TAB  SYM  SPC    │ BSPC RALT ENT
```

- Flechas en `J K L ;` siguiendo la misma lógica **j/k/l/ñ** que niri y Neovim (izquierda, arriba, abajo, derecha).
- `*` = combinaciones `RAlt+N/A/E/I/O/U`. Generan `ñ á é í ó ú` con el layout XKB `us` variante `altgr-intl`. Con el layout `es` (el que configura `misc.locale-es` por defecto) la `ñ` ya sale directamente en la tecla `;` de la capa base y estas combinaciones no producen acentos.
- `GAME` = `TG(2)`: activa o desactiva la capa GAME.
- `EE_CLR`: borra la EEPROM (restaura el keymap compilado en Vial).

### Capa 2 — GAME (conmutada con `GAME`)

Igual que BASE pero `A S D F J K L ;` son teclas normales, sin home-row mods, para que mantener `WASD` en juegos no active modificadores. `SYM` sigue disponible para salir (`SYM` + `GAME`).

### Configuración guardada en Vial

`via/vialconfig.vil` es un export de Vial y **no coincide** exactamente con `keymap.c` (por ejemplo, la capa 1 tiene F-keys con home-row mods y la capa 2 flechas). Se puede cargar en Vial con *File → Load saved layout*. Si cambias algo en Vial y quieres conservarlo, expórtalo aquí o pásalo a `keymap.c`.
