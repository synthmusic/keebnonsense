; ; Setup
; #include TapHoldManager.ahk
#SingleInstance Force
SendMode Input
; ; Thread  interrupt , 0  ; Make all threads always-interruptible.
; A_MaxHotkeysPerInterval := 1000

; CoordMode  ToolTip ,  Screen


; thm := TapHoldManager 0, 160, 1,  $*

; thm.Add  s , thmZ.Bind  s  ,200,600,1,,,,true,true
; thm.Add  d , thmZ.Bind  d  ,200,600,1,,,,true,true
; thm.Add  f , thmZ.Bind  f  ,200,600,1,,,,true,true
; thm.Add  j , thmZ.Bind  j  ,200,600,1,,,,false,true
; thm.Add  k , thmZ.Bind  k  ,200,600,1,,,,false,true
; thm.Add  l , thmZ.Bind  l  ,200,600,1,,,,false,true
; thmZ key, held, taps, state, rolled, mods  {
;     TempKeyTip key, held, taps, state, rolled, mods
; }
; u::{
; 		Send  {F5}

;         rrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrr :=  wwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwww

; }
; TempKeyTip key, held, taps, state, rolled, mods  {
; 		Send key . held . taps . state . rolled . mods .  `n
; }

hotkey  $*j , Send1,  On
hotkey  $*j Up , Send2,  On
hotkey  $*k , Send3,  On
hotkey  $*k Up , Send4,  On

Send1:
    Send  1
    ; Send  11111
    ; Send key
return
Send2:
    Send  2
    ; Send  22222
    ; Send key
return
Send3:
    Send  3
    ; Send  33333
    ; Send key
return
Send4:
    Send  4
    ; Send  44444
    ; Send key
return
