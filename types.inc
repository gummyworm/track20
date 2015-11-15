;------------------------------------------------------------------------------
;examples
; 03:-- 5 e
;
.struct songnode 
        pattern         .word   ; "00"-"df" which pattern is to be played
        patternoffset   .word   ; "00"-"df" offset of that pattern to start playing at
        repeat          .byte   ; '0'-'f'   times to repeat the pattern
        transpose       .byte   ; '0'-'e'   transpose the song by this many semitones
.endstruct


;------------------------------------------------------------------------------
;examples
; WAVE:xx
; LOP3:7A
;
.struct instline 
        command         .word   ; ' OFF'            off
                        .word   ; 'NOTE'            note
                                ; 'WAVE'            wave
                                ; 'WAV'($0-$f)      wave
                                ; 'L0P'($1-$f)      loopback
                                ; 'ARP'($1-$f)      arpegio
                                ; ' C#3'            any note - ignore transpose
        noise           .word   ; $00-$7f or 'xx'   noise amount - xx = disabled
.endstruct
;------------------------------------------------------------------------------
;examples:
; CN1 f f
.struct pattline 
        note            .word   ; 'DN4'             the note to play or RST (rest)
        notelen         .byte   ; '0'-'F'           amount to change note length by
        instrument      .byte   ; '0'-'F'           instrument to change to 
.endstruct

;------------------------------------------------------------------------------
; a drawable window 
;
.struct window 
        xpos            .byte   ; the 4x8 char that this window begins at horizontally
        ypos            .byte   ; the 4x8 char that this window begins at vertically
        width           .byte   ; the width of the window in 4x8 chars
        height          .byte   ; the height of the window in 4x8 chars
.endstruct
