.import "bitmap.inc"

cursorw:     .byte 1 ; the width of the cursor (in characters) 
cursorflags: .byte 0 ; current cursor flags
curstate:    .byte 0 ; the current state of the cursor.

;--------------------------------------
; off turns on the cursor regardless of its current state.
.export __cur_on
.proc __cur_on
;

.endproc 

;--------------------------------------
; off turns off the cursor regardless of its current state.
.export __cur_off
.proc __cur_off
;

.endproc 

;--------------------------------------
; setw sets the width of the cursor to .A characters.
.export __cur_setw
.proc __cur_setw
;
  sta cursorw 
  rts
.endproc 

;--------------------------------------
; setflags sets the flags of the cursor to those given in .A.
.export __cur_setflags
.proc __cur_setflags
;
 
;--------------------------------------
; update updates the cursor- call this each frame.
.export __cur_update
.proc __cur_update
;

.endproc 
