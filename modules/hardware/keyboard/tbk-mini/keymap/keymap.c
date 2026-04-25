#include QMK_KEYBOARD_H

enum layers { _BASE = 0, _SYM, _GAME, };

#define SYM  MO(_SYM)
#define GAME TG(_GAME)

#define HM_A  LSFT_T(KC_A)
#define HM_S  LCTL_T(KC_S)
#define HM_D  LALT_T(KC_D)
#define HM_F  LGUI_T(KC_F)
#define HM_J  RGUI_T(KC_J)
#define HM_K  RALT_T(KC_K)
#define HM_L  RCTL_T(KC_L)
#define HM_SC RSFT_T(KC_SCLN)

#define M_NTIL RALT(KC_N)
#define M_AA   RALT(KC_A)
#define M_EA   RALT(KC_E)
#define M_IA   RALT(KC_I)
#define M_OA   RALT(KC_O)
#define M_UA   RALT(KC_U)
#define M_COPY LCTL(KC_C)
#define M_PAST LCTL(KC_V)

const uint16_t PROGMEM keymaps[][MATRIX_ROWS][MATRIX_COLS] = {

[_BASE] = LAYOUT_split_3x6_3(
     KC_ESC,  KC_Q,  KC_W,  KC_E,  KC_R,  KC_T,       KC_Y,  KC_U,    KC_I,    KC_O,   KC_P,  KC_ENT,
    KC_CAPS,  HM_A,  HM_S,  HM_D,  HM_F,  KC_G,       KC_H,  HM_J,    HM_K,    HM_L,  HM_SC, KC_QUOT,
   C(KC_C),  KC_Z,  KC_X,  KC_C,  KC_V,  KC_B,       KC_N,  KC_M,  KC_COMM,  KC_DOT, KC_SLSH, KC_RSFT,
                          KC_TAB,  SYM, KC_SPC,    KC_BSPC, KC_RALT, KC_ENT
),

[_SYM] = LAYOUT_split_3x6_3(
    EE_CLR,  KC_1,   KC_2,   KC_3,   KC_4,   KC_5,       KC_6,    KC_7,   KC_8,    KC_9,    KC_0,  KC_ENT,
    KC_TAB, KC_F1,  KC_F2,  KC_F3,  KC_F4,  KC_F5,      KC_F6, KC_LEFT,  KC_UP, KC_DOWN, KC_RGHT, M_NTIL,
   KC_LSFT,  M_AA,   M_EA,   M_IA,   M_OA,   M_UA,       GAME, KC_MINS,  KC_EQL, KC_LBRC, KC_RBRC, KC_BSLS,
                          KC_TAB,   SYM, KC_SPC,    KC_BSPC, KC_RALT,  KC_ENT
),

[_GAME] = LAYOUT_split_3x6_3(
    KC_TRNS, KC_TRNS, KC_TRNS, KC_TRNS, KC_TRNS, KC_TRNS,    KC_TRNS, KC_TRNS, KC_TRNS, KC_TRNS, KC_TRNS, KC_TRNS,
    KC_TRNS,   KC_A,    KC_S,    KC_D,    KC_F,  KC_TRNS,    KC_TRNS,   KC_J,    KC_K,    KC_L, KC_SCLN, KC_TRNS,
    KC_TRNS, KC_TRNS, KC_TRNS, KC_TRNS, KC_TRNS, KC_TRNS,    KC_TRNS, KC_TRNS, KC_TRNS, KC_TRNS, KC_TRNS, KC_TRNS,
                             KC_TRNS,   SYM, KC_TRNS,    KC_TRNS, KC_TRNS, KC_TRNS
),

};
