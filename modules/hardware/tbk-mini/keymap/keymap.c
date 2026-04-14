#include QMK_KEYBOARD_H

enum layers {
    _BASE = 0,
    _LOWER,
    _RAISE,
    _ADJUST,
};

#define LOWER  MO(_LOWER)
#define RAISE  MO(_RAISE)
#define ADJUST MO(_ADJUST)

// Homerow mods (GACS) — iguales a los del keymap VIA original
#define HM_A  LGUI_T(KC_A)
#define HM_S  LALT_T(KC_S)
#define HM_D  LCTL_T(KC_D)
#define HM_F  LSFT_T(KC_F)
#define HM_J  RSFT_T(KC_J)
#define HM_K  RCTL_T(KC_K)
#define HM_L  RALT_T(KC_L)
#define HM_SC RGUI_T(KC_SCLN)

// Macros VIA originales expresadas con modificadores QMK directos.
// Los acentos dependen de console.keyMap = "us-acentos" + RALT como
// compose key (configuración actual en hosts/toledo).
#define M_NTIL RALT(KC_N)       // ñ
#define M_AA   RALT(KC_A)       // á
#define M_EA   RALT(KC_E)       // é
#define M_IA   RALT(KC_I)       // í
#define M_OA   RALT(KC_O)       // ó
#define M_UA   RALT(KC_U)       // ú
#define M_COPY LCTL(KC_C)
#define M_PAST LCTL(KC_V)

const uint16_t PROGMEM keymaps[][MATRIX_ROWS][MATRIX_COLS] = {

/*
 * BASE
 * ,-----------------------------------------.                    ,-----------------------------------------.
 * | ESC  |  Q  |  W  |  E  |  R  |  T  |                          |  Y  |  U  |  I  |  O  |  P  | BSPC |
 * |------+-----+-----+-----+-----+-----|                          |-----+-----+-----+-----+-----+------|
 * | TAB  |  A  |  S  |  D  |  F  |  G  |                          |  H  |  J  |  K  |  L  |  ;  | QUOT |
 * |------+-----+-----+-----+-----+-----|                          |-----+-----+-----+-----+-----+------|
 * | LSFT |  Z  |  X  |  C  |  V  |  B  |                          |  N  |  M  |  ,  |  .  |  /  | RSFT |
 * `------+-----+-----+-----+-----+-----+-------.        ,---------+-----+-----+-----+-----+-----+------'
 *                           | LGUI|LOWER| SPC  |        |  ENT  |RAISE| LCTL|
 *                           `-----+-----+------'        `-------+-----+-----'
 */
[_BASE] = LAYOUT_split_3x6_3(
     KC_ESC,    KC_Q,    KC_W,    KC_E,    KC_R,    KC_T,                         KC_Y,    KC_U,    KC_I,    KC_O,    KC_P, KC_BSPC,
     KC_TAB,    HM_A,    HM_S,    HM_D,    HM_F,    KC_G,                         KC_H,    HM_J,    HM_K,    HM_L,   HM_SC, KC_QUOT,
    KC_LSFT,    KC_Z,    KC_X,    KC_C,    KC_V,    KC_B,                         KC_N,    KC_M, KC_COMM,  KC_DOT, KC_SLSH, KC_RSFT,
                                    LOWER,  KC_SPC, KC_LGUI,    KC_LCTL, KC_ENT,  RAISE
),

/*
 * LOWER — números, navegación, copy/paste
 */
[_LOWER] = LAYOUT_split_3x6_3(
     KC_GRV,    KC_1,    KC_2,    KC_3,    KC_4,    KC_5,                         KC_6,    KC_7,    KC_8,    KC_9,    KC_0,  KC_DEL,
    KC_TRNS, KC_TRNS, KC_TRNS, KC_TRNS, KC_TRNS, KC_TRNS,                       KC_LEFT, KC_DOWN,   KC_UP, KC_RGHT, KC_TRNS, KC_TRNS,
    KC_TRNS, KC_TRNS, KC_TRNS,  M_COPY,  M_PAST, KC_TRNS,                       KC_HOME, KC_PGDN, KC_PGUP,  KC_END, KC_TRNS, KC_TRNS,
                                  KC_TRNS, KC_TRNS, KC_TRNS,    KC_RALT, KC_TRNS, ADJUST
),

/*
 * RAISE — funciones, símbolos, acentos (compose con RALT)
 */
[_RAISE] = LAYOUT_split_3x6_3(
    KC_TRNS,   KC_F1,   KC_F2,    M_EA,   KC_F4,   KC_F5,                        KC_F6,    M_UA,    M_OA,    M_IA,  KC_F10,  KC_F11,
    KC_TRNS,    M_AA, S(KC_2), S(KC_3), S(KC_4), S(KC_5),                      S(KC_6), S(KC_7), S(KC_8), S(KC_9), S(KC_0),  KC_F12,
    KC_TRNS, KC_TRNS, KC_TRNS, KC_TRNS, KC_TRNS, KC_TRNS,                       M_NTIL, KC_MINS,  KC_EQL, KC_LBRC, KC_RBRC, KC_BSLS,
                                   ADJUST, KC_TRNS, KC_TRNS,    KC_TRNS, KC_TRNS, KC_TRNS
),

/*
 * ADJUST — boot, RGB, media
 */
[_ADJUST] = LAYOUT_split_3x6_3(
    QK_BOOT, XXXXXXX, XXXXXXX, XXXXXXX, XXXXXXX, XXXXXXX,                      RM_TOGG, RM_NEXT, XXXXXXX, XXXXXXX, XXXXXXX, XXXXXXX,
    XXXXXXX, XXXXXXX, XXXXXXX, XXXXXXX, XXXXXXX, XXXXXXX,                      RM_HUEU, RM_HUED, RM_SATU, RM_SATD, RM_VALU, RM_VALD,
    XXXXXXX, XXXXXXX, XXXXXXX, XXXXXXX, XXXXXXX, XXXXXXX,                      KC_MUTE, KC_VOLD, KC_VOLU, KC_MPRV, KC_MPLY, KC_MNXT,
                                  KC_TRNS, KC_TRNS, KC_TRNS,    KC_TRNS, KC_TRNS, KC_TRNS
),

};
