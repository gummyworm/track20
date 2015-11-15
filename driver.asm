;--------------------------------------
; Vic-20 Player 2 : 4mat/Orb 2007. 
;
; Music driver.
;
; Use : jsr orgaddress   - init player.
;       jsr orgaddress+3 - player loop for each frame.
;
; There's possibly a bug with the song repeat command but I haven't 
; checked it 100%.  I've only heard it happen once in the 'Megademo Outro' 
; song, when it played through a few times.
;
dnote = $a0
instrument = dnote + $03 
instrloc = instrument + $03 
instrlen = instrloc + $03 
tempopat = instrlen + $03 
temponot = tempopat + $03 
transsng = temponot + $03 
delaysng = transsng + $03 
temptrans = delaysng + $03 
tempvol = temptrans+$03
voldelay = tempvol+$01
volwait = voldelay+$01
temp = volwait+$01 
tempvol2 = temp+$01

.export __driver_init
.export __driver_play

__driver_init:
	jmp playinit
__driver_play:
	jmp playit

	ldx #$22
	lda #$00
clearplay:
	sta dnote,x
	dex
	bpl clearplay
playit:
	ldx #$02
noteloop:
	lda ticks
	bpl  update

updatesong:
	dec temponot,x
	lda temponot,x
	bpl update

updatecont:
	ldy pattpos,x

patttab_loc_in_driver = *+1
	lda patttab,y
	cmp #$2f
	bcc justanote

instrumentfx:
	cmp #$f0
	and #$0f
	bcs newinstrument
	sta tempopat,x          ; new tempo, set tempo for pattern
	sta temponot,x          ; set tempo for note
firstupdate:
	inc pattpos,x
	jmp updatecont

newinstrument:
	sta instrument,x
	inc pattpos,x
	jmp updatecont

justanote:
 	sta dnote,x

	lda temptrans,x
	sta transsng,x
	lda tempopat,x
	sta temponot,x

	inc pattpos,x
	lda dnote,x
	beq update

	ldy instrument,x

	lda notelen,y
	and #$7f
	sta instrlen,x

	lda inststart,y
	sta instrloc,x
	dec instrloc,x

usualvolset:
	lda volbyte,y
	beq update
	lsr
	lsr
	lsr
bigwaiting:
	sta voldelay
	sta volwait

	lda volamount,y
	sta tempvol

	lda volbyte,y
	and #$0f
	sta tempvol2 

update:
	inc instrloc,x

	lda instrlen,x          ; get the frame ticks left to play note
	bne playing             ; >0, keep playing
	lda #$00                ; TODO: A already 0
	sta dnote,x
	sta $900a,x             ; turn off channel
	ldy instrument,x        ; get instrument being played
	lda notelen,y           ; is there a noise channel?
	bpl nodecing            ; nope
	lda #$00                ; yes, turn it off
	sta $900d 

playing:
	dec instrlen,x          ; decrement # of frameticks to play instrument for

nodecing:
	lda transsng,x
	sta temp

	lda dnote,x
	beq playnote

getinst:
	ldy instrument,x

	lda notelen,y
	bpl nonoise
	ldy instrloc,x
insttab_loc_in_driver = *+1
	lda insttab,y
	sta $900d
	inc instrloc,x
nonoise:
	ldy instrloc,x
	lda insttab,y
	and #$10
	beq nofancy2

	lda #$7f
	sta $900a,x
nofancy2:
	lda insttab,y
	cmp #$7f
	bcs playnote
	cmp #$5f
	bcc arpeggio
	and #$0f
	sbc instrloc,x
	eor #$ff
	sta instrloc,x
	jmp getinst

arpeggio:
	pha
	and #$0f 
	adc temp
	sta temp

	pla
	and #$10
	beq nofancyness

	lda masks,x 
	sta $900a,x

nofancyness:
	lda dnote,x
	clc
	adc temp
	tay
	lda freqtab,y
playnote:
	sta $900a,x

	dex
	bmi doneloop
	jmp noteloop 

doneloop:
	dec voldelay
	bpl volisgood
	lda volwait
	sta voldelay

	lda tempvol2
	sbc tempvol
	sta tempvol2

volisgood:
	lda $900e
	and #$f0
	ora tempvol2
	sta $900e

	lda ticks
	bmi istheend 

checkforend:
	ldx ticks
	dec ticks
	cpx #$03
	bcs outta
	ldy pattpos,x
	lda patttab,y
	cmp #$7f
	bne nonewone
	bpl getpat
nonewone:
	rts

istheend:
	inc tempotick           ; TODO: lda #$01:eor tempotick:sta tempotick ????
	lda tempotick
	and #$01
	sta tempotick
	tay
	lda tempo,y
	sta ticks
outta:
	rts

getsong0:
	inc songpos,x

getpat:
	ldy songpos,x
songtab_loc_in_driver = *+1
	lda songtab,y
	cmp #$ff
	bne  nopatreset

	lda songstart,x
	sta songpos,x
	bpl getpat 
nopatreset:
	cmp #$e0
	bcs songeffect
	sta pattpos,x
	dec delaysng,x
	bpl notnewpat
	inc songpos,x
notnewpat:
	rts

songeffect:
	cmp #$f0
	bcs setglobaltran
	and #$0f
	sta delaysng,x
	bpl getsong0
setglobaltran:
	and #$0f
	sta temptrans,x
	bpl getsong0

; Frequency Table. (Vic-20 only has 7bit range, which goes out of tune a lot.
;                   You may find it useful to tweak these values.)
freqtab:
.byte 0 
.byte 135,143,147,151,159,163,167,175,179,183,187,191 
.byte 195,199,201,203,207,209,212,215,217,219,221,223 
.byte 225,227,228,229,231,232,233,235,236,237,238,239 
.byte 240,241,242

; Mask settings for Wave fx on each channel.
masks: .byte $fe,$fd,$fb


