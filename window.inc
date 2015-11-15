.import __window_draw
.import __window_hide
.import __window_show

.macro window w,h,minw,minh,drawfunc,keyfunc
  .byte w
  .byte h
  .byte minw
  .byte minh
  .word drawfunc
  .word keyfunc
.endmacro

.import __window_draw
.import __window_show
.import __window_hide
.import __window_update
.import __window_handlekey

.scope win
  draw      = __window_draw
  show      = __window_show
  hide      = __window_hide
  update    = __window_update
  handlekey = __window_handlekey
.endscope

