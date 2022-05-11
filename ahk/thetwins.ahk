#SingleInstance Force

A_MaxHotkeysPerInterval := 1000
; RegularKeyboard := GetKeyState("ScrollLock", "T")
; MouseMode := false

; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; DIRECT KEY MAPS
; PrintScreen::CapsLock
; Pause::CapsLock

; ^PrintScreen::{
;     global RegularKeyboard := !RegularKeyboard
; }

; Enter & Space::AltTab
; ; Space & Enter::ShiftAltTab
; ; Space up::Send("{Space}")
; ; F13::Spacex

; ; LAlt::LShift 
; ; RAlt::RShift
; ; LShift::LAlt
; ; RShift::RAlt

; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; CAPS LOCK
; #HotIf GetKeyState("CapsLock", "T")
; -::Send("{Blind}{Shift down}-{Shift up}")
; #HotIf

; Offset := 20
; #HotIf MouseMode

; *e::MouseMove(0, -Offset, 0, "R")
; *d::MouseMove(0, Offset, 0, "R")
; *f::MouseMove(Offset, 0, 0, "R")
; *s::MouseMove(-Offset, 0, 0, "R")
; #HotIf

; ; #HotIf RegularKeyboard
; ; #HotIf

; ; ~^s::{
; ;     refresh()
; ; }
; 789
; ;;;;;;; pageup & pagedn for specialty
; F14::F2
; F15::Send(" ^b")

; ;keypad mouse scroll
; F21::Scroll("WU", "F21")
; F22::Scroll("WD", "F22")

; *F21::Scroll("WU", "F21")
; *F22::Scroll("WD", "F22")

; F17::!Left
; F18::LButton
; ; !F18::!Left
; F19::RButton
; ; !F19::!Right
; F20::MButton

; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; Enter combos
; Enter & o::Return
; Enter & p::^a
; Enter & [::^x
; Enter & F18::Return

; Enter & b::^v
; Enter & '::^c

; Enter & .::^s
; Enter & /::^z

; Enter & m::Return
; Enter & ,::Return

; Enter & e::Up
; Enter & f::Right
; Enter & d::Down
; Enter & s::Left
; Enter & r::End
; Enter & w::Home

; Enter & i::Up
; Enter & l::Right
; Enter & k::Down
; Enter & j::Left
; Enter & o::End
; Enter & u::Home

; Enter::Send("{Enter}")

; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; Tab Combos
; ; Tab & a::^a

; ; Tab::Send("{Tab}")

; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; phi
; ; #HotIf GetKeyState("F24") and !GetKeyState("F23")
; ; #HotIf

; ; #HotIf GetKeyState("Shift")
; ; F24 & y::]
; ; F24 & u::Send("{}}")
; ; F24 & i::Send("{)}")
; ; #HotIf

; ; right
; F24 & 3::^f
; F24 & 7::^s

; ; F24 & 8::return
; ; F24 & 9::return
; ; F24 & 0::return

; F24 & y::[
; F24 & u::+[ 
; F24 & i::+9
; F24 & o::+=

; F24 & p::\

; F24 & h::*
; F24 & j::=
; F24 & k::;
; F24 & l::+'

; F24 & n::-
; F24 & m::+/
; F24 & ,::,
; F24 & .::.

; ; left

; ; F24 & e::Send("{Blind}{Up}")
; ; F24 & d::Send("{Blind}{Down}")
; ; F24 & s::Send("{Blind}{Left}")
; ; F24 & f::Send("{Blind}{Right}")
; ; F24 & w::Send("{Blind}{Home}")
; ; F24 & r::Send("{Blind}{End}")

; F24 & e::Up
; F24 & d::Down
; F24 & s::Left
; F24 & f::Right
; F24 & w::Home
; F24 & r::End
; F24 & t::PgUp
; F24 & g::PgDn

; ; function keys

; F24 & F11::KeyHistory()
; F24 & F12::Refresh()

; F24 & F8::Send("{Volume_Mute}")
; F24 & F9::Send("{Volume_Down}")
; F24 & F10::Send("{Volume_Up}")

; F24 & F6::ChangeBrightness( -3 ) ; decrease brightness
; F24 & F7::ChangeBrightness( 3 ) ; increase brightness

; F24 & LShift::MouseNotMouse()
; F24 & V::MouseNotMouse()
; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; delta
; ; #HotIf GetKeyState("F23") and !GetKeyState("F24")
; ; #HotIf
; ;right

; F23 & y::]
; F23 & u::+]
; F23 & i::+0
; F23 & o::-
; F23 & p::+\

; F23 & h::/
; F23 & j::=
; F23 & k::+;
; F23 & l::'

; F23 & n::+=
; F23 & m::/
; F23 & ,::+,
; F23 & .::+.

; ;left
; F23 & e::Send("{Blind}^+{Up}")
; F23 & d::Send("{Blind}^+{Down}")
; F23 & s::Send("{Blind}^+{Left}")
; F23 & f::Send("{Blind}^+{Right}")
; F23 & w::Send("{Blind}^+{Home}")
; F23 & r::Send("{Blind}^+{End}")

; F23 & 1::F1
; F23 & 2::F2
; F23 & 3::F3
; F23 & 4::F4
; F23 & 5::F5
; F23 & 6::F6
; F23 & 7::F7
; F23 & 8::F8
; F23 & 9::F9
; F23 & 0::F10
; F23 & -::F11
; F23 & =::F12

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