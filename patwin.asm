.include "window.inc"

;--------------------------------------
.proc drawpatwin
  rts
.endproc

;--------------------------------------
.proc handlepatkey
  rts
.endproc

;--------------------------------------
.proc drawpatline
  rts
@patline: 
.byte "00--- -- - --"
.endproc 

;--------------------------------------
id: .byte 0
patwin:
window 40,10,0,0,drawpatwin,handlepatkey
