.include "conf.inc"
.include "flags.inc"

.struct Window
  w       .byte ; the width in characters
  h       .byte ; the height in characters 
  minw    .byte ; the minimum width in characters     
  minh    .byte ; the minimum height in characters     
  update  .word ; the update function
  draw    .word ; the render function
  onkey   .word ; the keyboard handler function
  flags   .byte ; window flags
.endstruct 

numwins: .byte 0
wins:    .res NUM_WINS * 2

;--------------------------------------
; draw the window of ID .A
.export __window_draw
.proc __window_draw
  rts
.endproc

;--------------------------------------
; show the window of ID .A
.export __window_show
.proc __window_show
  rts
.endproc

;--------------------------------------
; hide the window of ID .A
.export __window_hide
.proc __window_hide
  rts
.endproc

;--------------------------------------
; update all windows
.export __window_update
.proc __window_update
  lda numwins 
  pha

@l0:
  lda wins,x 
  sta @w
  clc
  adc #Window::update
  lda wins+1,x
  adc #$00
  sta @w+1

@w=*+1
  jsr $0000
  pla
  sec
  sbc #$01
  bne @l0
  rts
.endproc

;--------------------------------------
.export __window_handlekey
.proc __window_handlekey
  
.endproc

