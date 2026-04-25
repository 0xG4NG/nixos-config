#pragma once
#define TAPPING_TERM 400
#define PERMISSIVE_HOLD
#define TAPPING_FORCE_HOLD
#define DYNAMIC_KEYMAP_LAYER_COUNT 3

/* Vial — marcar features como gestionadas por Vial para que
   keymap_introspection.c no intente usar los arrays estáticos de QMK */
#define VIAL_KEYBOARD_UID {0xAB, 0x7C, 0x4E, 0xF2, 0x19, 0xD3, 0x80, 0x56}
#define VIAL_UNLOCK_COMBO_ROWS {0, 0}
#define VIAL_UNLOCK_COMBO_COLS {0, 5}
#define VIAL_COMBO_ENABLE
#define VIAL_TAP_DANCE_ENABLE
#define VIAL_KEY_OVERRIDE_ENABLE
