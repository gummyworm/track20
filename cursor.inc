;--------------------------------------
; cursor constants
CUR_SPEED = 5 ; the # of cursor updates between each blink


;--------------------------------------
; cursor flags
CUR_BLINK = 1

;--------------------------------------
.import __cur_on
.import __cur_off
.import __cur_setw
.import __cur_setflags
.import __cur_update

.scope cur
  on       = __cur_on
  off      = __cur_off
  setw     = __cur_setw
  setflags = __cur_setflags
  update   = __cur_update
.endscope

