.include "zp.inc"
;--------------------------------------
.export __str_len
.proc __str_len
  stx zp::addr0
  sty zp::addr0+1
  ldy #$ff
@l0:
  iny
  lda ($f0),y
  bne @l0
  iny
  tya
  rts
.endproc 

;--------------------------------------
; Append the string in (<.X, >.Y) to the one in (<tmp0, >tmp1)
.export __str_append
.proc __str_append
  stx zp::addr0
  sty zp::addr0+1
  jsr __str_len
  clc
  adc zp::addr0
  sta zp::addr0
  lda #$00
  tay
  adc zp::addr1
  sta zp::addr1
@l0:
  lda (zp::addr0),y
  beq @done
  sta (zp::tmp0),y
  iny 
  bne @l0
@done:
  rts
.endproc

;--------------------------------------
; return the value of .A as its ASCII hex-representation
.export __str_hex2asc 
.proc __str_hex2asc
  cmp #9
  bcs @0
  adc #'0'
  rts
@0:
  adc #'a'-1
  rts
.endproc

