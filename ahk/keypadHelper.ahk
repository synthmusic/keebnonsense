#SingleInstance Force

A_MaxHotkeysPerInterval := 1000
RegularKeyboard := GetKeyState("ScrollLock", "T")
MouseMode := false
LayerDelta := false

;;;;;;;;;;;;;;;;;;;;;;;;;;;;; DIRECT KEY MAPS
; PrintScreen::CapsLock
Pause::CapsLock

^PrintScreen::{
    global RegularKeyboard := !RegularKeyboard
}

Enter & Space::AltTab
; Space & Enter::ShiftAltTab
; Space up::Send("{Space}")
; F15::Space

; LAlt::LShift 
; RAlt::RShift
; LShift::LAlt
; RShift::RAlt

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
    ChangeLayer("Delta")
}

F14::{
    ChangeLayer("Standard")
}

F15::{
    ChangeLayer("Phi")
}

;keypad mouse scroll
F21::Scroll("WU", "F21")
F22::Scroll("WD", "F22")

*F21::Scroll("WU", "F21")
*F22::Scroll("WD", "F22")
;F17::!Left
;F18::LButton
; !F18::!Left
;F19::RButton
; !F19::!Right
;F20::MButton

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; Enter combos
Enter & o::Return
Enter & p::^a
Enter & [::^x

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

Enter & i::Up
Enter & l::Right
Enter & k::Down
Enter & j::Left
Enter & o::End
Enter & u::Home

Enter & Backspace::Delete
Enter::Send("{Enter}")

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; Tab Combos
; Tab & a::^a

; Tab::Send("{Tab}")

; Space & Backspace::Delete
; Space::Send("{Space}")
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; phi
#HotIf LayerDelta

y::`
; u::]
i::[
o::]
p::\
h::-
j::=
k::;
l::'
n::{
}
m::/

e::Up
d::Down
s::Left
f::Right
w::Home
r::End
t::PgUp
g::PgDn
; ;tion keys

a::^a
z::^z
x::^x
c::^c
v::^v

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

F24 & 3::^f
F24 & 7::^s
F24 & F6::ChangeBrightness( -3 ) ; decrease brightness
F24 & F7::ChangeBrightness( 3 ) ; increase brightness
F24 & F8::Send("{Volume_Mute}")
F24 & F9::Send("{Volume_Down}")
F24 & F10::Send("{Volume_Up}")

F24 & F11::KeyHistory()
F24 & F12::Refresh()

;F24 & LShift::MouseNotMouse()
;'F24 & V::MouseNotMouse()

; F24 & 8::return
; F24 & 9::return
; F24 & 0::return

; left

; F24 & e::Send("{Blind}{Up}")
; F24 & d::Send("{Blind}{Down}")
; F24 & s::Send("{Blind}{Left}")
; F24 & f::Send("{Blind}{Right}")
; F24 & w::Send("{Blind}{Home}")
; F24 & r::Send("{Blind}{End}")

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
ChangeBrightness(change)
{
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

    }else { 
        SetScrollLockState(false)
        global LayerDelta := false

    }

}