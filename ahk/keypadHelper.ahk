#include TapHoldManager.ahk
#SingleInstance Force

A_MaxHotkeysPerInterval := 1000
RegularKeyboard := GetKeyState("ScrollLock", "T")
MouseMode := false
LayerDelta := false
LayerPhi := false

; `;::Send("{Blind}b")
; *b::F22

KeyWaitCombo(Options:="")
{
    ih := InputHook(Options)
    ; if !InStr(Options, "V")
    ;     ih.VisibleNonText := false
    ih.KeyOpt("{All}", "E")  ; End
    ; Exclude the modifiers
    ih.KeyOpt("{LCtrl}{RCtrl}{LAlt}{RAlt}{LWin}{RWin}", "-E")
    ih.Start()
    ih.Wait()
    Send("r{LShift up}")
    return ih.EndMods . ih.EndKey  ; Return a string like <^<+Esc
}

; LShift::{
;     Send("{Blind}{LShift down}")
;     KeyWaitCombo("V L1")
; }

; LShift up::{

; }

thm := TapHoldManager(0, 150, 1, "$*")
holdShiftList := ("1 2 3 4 5 6 7 8 9 0 q w e r t y u i o p a s d f g h j k l b z x c v n m , . /")

for str in StrSplit(holdShiftList, " ") {
    thm.Add(str, holdShift.Bind(str))
}

; thm.Add("Space", longSpace)

longSpace(isHold, taps, state) {
    if (isHold) {
        if (state) {
            thm.SetRollingKeysActive(false)
            Send("{Blind}{LShift down}")
        } else {
        Send("{Blind}{LShift up}")
            thm.SetRollingKeysActive(true)
        }
    } else {
        Send("{Blind}{Space}")
    }
}

holdShift(key, isHold, taps, state) {
        ; Send(key isHold taps state "`n")

    if (isHold && state)  {
        ; if (taps == 1){
            Send "{blind}+" key
        ; }
    } else if (!isHold) {
        Send "{blind}" key
    }
}

thm.AddRollingKeys("1 2 3 4 5 6 7 8 9 0 q w e r t y u i o p a s d f g h j k l b z x c v n m , . / Space Enter")

logKey(isHold, taps, state){
	Send (isHold ? "HOLD" : "TAP") " Taps: " taps " State: " state "`n"
}

;;;;;;;;;;;;;;;;;;;;;;;;;;;;; DIRECT KEY MAPS
; PrintScreen::CapsLock
Pause::CapsLock

^PrintScreen::{
    global RegularKeyboard := !RegularKeyboard
}

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; CAPS LOCK
#HotIf GetKeyState("CapsLock", "T")
-::Send("{Blind}{Shift down}-{Shift up}")
#HotIf

Offset := 20
; #HotIf MouseMode

; *e::MouseMove(0, -Offset, 0, "R")
; *d::MouseMove(0, Offset, 0, "R")
; *f::MouseMove(Offset, 0, 0, "R")
; *s::MouseMove(-Offset, 0, 0, "R")
; #HotIf

; #HotIf RegularKeyboard
; #HotIf

; ~^s::{
;     refresh()
; }

;;;;;;; pageup & pagedn for specialty
F13::{
    ChangeLayer("Alpha")
}

F14::{
    ChangeLayer("Delta")
}

F15::{
    ChangeLayer("Phi")
}

;keypad mouse scroll
F20::Scroll("WU", "F20")
F21::Scroll("WD", "F21")

*F20::Scroll("WU", "F20")
*F21::Scroll("WD", "F21")
;F17::!Left
;F18::LButton
; !F18::!Left
;F19::RButton
; !F19::!Right
;F20::MButton

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; Enter combos
Enter & o::Return
Enter & |::^a
Enter & p::^a
Enter & SC01A::^x

Enter & ?::^v
Enter & b::^v
Enter & '::^c

Enter & .::^s
Enter & /::^z
Enter & F18::^z

Enter & m::Return
Enter & ,::Return

Enter & e::Up
Enter & f::Right
Enter & d::Down
Enter & s::Left
Enter & r::End
Enter & w::Home
Enter & t::PgUp
Enter & g::PgDn

Enter & v::AltTab

Enter & i::Up
Enter & l::Right
Enter & k::Down
Enter & j::Left
Enter & o::End
Enter & u::Home

Enter & Backspace::Delete
Enter & Space::AltTab

Enter::Send("{Enter}")
; Esc::Send("{Esc}")

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; Tab Combos
; Tab & a::^a

; Tab::Send("{Tab}")

; Space & Backspace::Delete
; Space::Send("{Space}")
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; phi
#HotIf LayerDelta

; y::`
; ; u::]
; i::[
; o::]
; p::\
; h::-
; j::=
; k::;
; l::'
; n::{
; }
; m::/

; e::Up
; d::Down
; s::Left
; f::Right
; w::Home
; r::End
; t::PgUp
; g::PgDn
; ;tion keys

;a::^a
;z::^z
;x::^x
;c::^c
;v::^v

;1::F1
;2::F2
;3::F3
;4::F4
;5::F5
;6::F6
;7::F7
;8::F8
;9::F9
;0::F10
;-::F11
;=::F12

#HotIf

F22 & 1::F1
F22 & 3::^f
F22 & 7::^s
F22 & F6::ChangeBrightness( -3 ) ; decrease brightness
F22 & F7::ChangeBrightness( 3 ) ; increase brightness
F22 & F8::Send("{Volume_Mute}")
F22 & F9::Send("{Volume_Down}")
F22 & F10::Send("{Volume_Up}")

F22 & F11::KeyHistory()
F22 & F12::Refresh()

;F24 & LShift::MouseNotMouse()
;F24 & V::MouseNotMouse()

; F24 & 8::return
; F24 & 9::return
; F24 & 0::return

; left

F22 & e::Send("{Blind}{Up}")
F22 & d::Send("{Blind}{Down}")
F22 & s::Send("{Blind}{Left}")
F22 & f::Send("{Blind}{Right}")
F22 & w::Send("{Blind}{Home}")
F22 & r::Send("{Blind}{End}")

F22 & i::Send("{Blind}{{}}")

F22 & h::Send("{Blind}`"")
F22 & j::Send("{Blind}=")
F22 & k::Send("{Blind};")
F22 & l::Send("{Blind}:")

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; delta
; #HotIf GetKeyState("F23") and !GetKeyState("F24")
; #HotIf
;right

;left
; F23 & q::F1

; F23 & e::Send("{Blind}^+{Up}")
; F23 & d::Send("{Blind}^+{Down}")
; F23 & s::Send("{Blind}^+{Left}")
; F23 & f::Send("{Blind}^+{Right}")
; F23 & w::Send("{Blind}^+{Home}")
; F23 & r::Send("{Blind}^+{End}")

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; Functions
ChangeBrightness(change) {
    brightness := Min(Max(GetCurrentBrightness() + change, 0), 100)
    timeout := 1

    ToolTip (brightness)

    For property in ComObjGet( "winmgmts:\\.\root\WMI" ).ExecQuery( "SELECT * FROM WmiMonitorBrightnessMethods" )
        property.WmiSetBrightness( timeout, brightness )
}

GetCurrentBrightness()
{

    For property in ComObjGet( "winmgmts:\\.\root\WMI" ).ExecQuery( "SELECT * FROM WmiMonitorBrightness" )
        currentBrightness := property.CurrentBrightness

    return currentBrightness
}

ShowWindowData()
{
    ; WinGetPos &X, &Y, &W, &H, "A"
    MonitorGetWorkArea 1, &X, &Y, &W, &H
    MsgBox "The primary is at " X " , " Y " - " W " x " H
}

Refresh()
{
    ; this reloads the script
    Send("^s")
    Sleep (100)
    Run "C:\Users\John\Documents\exec\keypadHelper.bat"
}

Scroll(dir, key)
{
    Click(dir)
    Sleep(2)
    While GetKeyState(key) {
        Click(dir)
        Sleep(2)
    }

}

MouseNotMouse() {
    global MouseMode := !MouseMode
}

ChangeLayer(layerName) {
    if (layerName == "Delta") {
        SetScrollLockState(true)
        global LayerDelta := true
        global LayerPhi := false

    }else if (layerName == "Phi") {
        SetScrollLockState(true)
        global LayerDelta := false
        global LayerPhi := true

    }
    else {
        SetScrollLockState(false)
        global LayerDelta := false
        global LayerPhi := false

    }
}

Repeat(key, str, initialWait := 120, repeatWait := 30) {
    Send(str)
    Sleep(initialWait)
    While GetKeyState(key) {
        Send(str)
        Sleep(repeatWait)
    }
}