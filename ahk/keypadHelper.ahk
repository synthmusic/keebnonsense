; Setup
#include TapHoldManager.ahk
#SingleInstance Force
Thread "interrupt", 0  ; Make all threads always-interruptible.
A_MaxHotkeysPerInterval := 1000
KeyHistory(500)
CoordMode "ToolTip", "Screen"

;;;;;;;;;;;;;;;;;;;;;;;;; consts
SINGLE_QUOTE := "sc028"

;;;;;;;;;;;;;;;;;;;;;;;;; "public" globals
IsStandardKeyboard := true

;;;;;;;;;;;;;;;;;;;;;;;;; "private" globals
HoldLayer := "Alpha"

;;;;;;;;;;;;;;;;;;;;;;;;; Keyboard setup

thm := TapHoldManager(0, 160, 1, "$*")
holdShiftList := "`` 1 2 3 4 5 6 7 8 9 0 - ="
                . " q w e r t y u i o p [ ]"
                . " a s d f g h j k l `;"
                . " z x c v n m , . /"

for str in StrSplit(holdShiftList, " ") {
    thm.Add(str, holdShift.Bind(str))
}

thm.AddRollingKeys(holdShiftList . " Enter")

holdShift(key, isHold, taps, state) {
    sendKey := ""
    switch GetLayer()
    {
        case "Delta":
            sendKey := MapDeltaKeys(key)
        case "DeltaDelta":
            sendKey := MapDeltaDeltaKeys(key)
        case "EntPair":
            sendKey := MapEntPairKeys(key)
        default:
            sendKey := MapAlphaKeys(key)
    }

    ; TempToolTip(key . "`n" . sendKey . "`n" . (state ? "down" : "up") . " " . (isHold ? "held" : "tap"))

    if (isHold && state)  {
        Send "{Blind}+" . sendKey
    } else if (!isHold) {
        Send "{Blind}" . sendKey
    }
}

thm.Add("CapsLock", thmCapsLock)
thmCapsLock(isHold, taps, state) {
    ; global HoldLayer := "Delta"
    if (isHold && !state)  {
        Send ("{CapsLock}")
    } else if (!isHold) {
        SetLayer "Delta"
    }
}



thm.Add("b", thmB)
thmB(isHold, taps, state) {
    TempToolTip("b`n" . (state ? "down" : "up") . " " . (isHold ? "held: " : "tap: ") . taps)
    if (isHold) {
        SetLayer "Alpha"
    } else if (!isHold) {
        SetLayer "Delta"
    }
}

thm.Add(";", thmSemi)
thmSemi(isHold, taps, state) {
    TempToolTip("b`n" . (state ? "down" : "up") . " " . (isHold ? "held: " : "tap: ") . taps)
    if (!isHold) {
        Send "{}"
    }
}

sendSpace := Send.Bind(" ")
thm.Add("Space", thmSpace)
thmSpace(isHold, taps, state) {
    ; TempToolTip("b`n" . (state ? "down" : "up") . " " . (isHold ? "held" : "tap"))
    if (isHold)  {
        if (state) {
            Send("{Space down}")
        } else {
            Send("{Space up}")
        }
    } else if (!isHold) {
        Send(" ")
    }
}

;;;;;;;;;;;;;;;;;;;;;;;;; layer related functions

SetLayer(name) {
    if (name == "Alpha"){
        ToolTip("A", 100, 100, 2)
        SetTimer () => ToolTip("",,,2), -4000
    } else if (name == "Delta") {
        ToolTip("SHIFTED`nSHIFTED", 25, 25, 2)
    }

    global HoldLayer := name
}

GetLayer() {
    ; global TrackLayer := "Delta"
    layer := HoldLayer

    ; return LayerDelta || GetKeyState("Enter", "P")||
    if GetKeyState("Enter", "P") || GetKeyState(SINGLE_QUOTE, "P") {
        layer := "EntPair"
    }

    if GetKeyState("b", "P") {
        layer := "DeltaDelta"
    }

    ; TempToolTip(layer)
    return layer
}

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; CAPS LOCK
#HotIf GetKeyState("CapsLock", "T")
-::Send("{Blind}{Shift down}-{Shift up}")
#HotIf

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; ALL
\::CapsLock

PrintScreen::
^+BackSpace::{
    global IsStandardKeyboard := !IsStandardKeyboard
}

F16::{
    global IsStandardKeyboard := false
}

=::{
    global HoldLayer := "Alpha"
}

F14::{
    global HoldLayer := "Delta"
}

F20::Scroll("WU", "F20")
F21::Scroll("WD", "F21")

*F20::Scroll("WU", "F20")
*F21::Scroll("WD", "F21")
; thm.Add("Space", longSpace)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; Alpha
MapAlphaKeys(key) {
    switch key
    {
        case ";": return "b"
        ; case "q": return "{Esc}"
        ; case "``": return "q"
        default: return key
    }
}


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; Delta

MapDeltaKeys(key) {
    switch key
    {
        case "q": return "``"

        case "y": return "\"
        case "u": return "-"
        case "i": return "["
        case "o": return "]"

        case "j": return "="
        case "k": return ";"
        case "l": return "'"

        case "n": return "/"

        case "1": return "{F1}"
        case "2": return "{F2}"
        case "3": return "{F3}"
        case "4": return "{F4}"
        case "5": return "{F5}"
        case "6": return "{F6}"
        case "7": return "{F7}"
        case "8": return "{F8}"
        case "9": return "{F9}"
        case "0": return "{F10}"
        case "[": return "{F11}"
        case "]": return "{F12}"
        default: return key
    }
}

#HotIf GetLayer() == "Delta"

    *a::Send("{Blind}{LShift Down}{LCtrl Down}")
    *a Up::Send("{Blind}{LShift Up}{LCtrl Up}")

    e::Up
    d::Down
    s::Left
    f::Right
    w::Home
    r::End
    t::PgUp
    g::PgDn
#HotIf

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; Ent Pair

MapEntPairKeys(key) {
    switch key
    {
        case "o": return "^s"
        case "p": return "^x"
        case "l": return "^v"
        case ";": return "^c"
        case ".": return "^z"
        case "/": return "^a"
        default: return key
    }
}

#HotIf GetLayer() == "EntPair"
    sc028 & v::AltTab
    Enter & v::AltTab
    sc028 & Space::AltTab
    Enter & Space::AltTab

    sc028 & Backspace::Delete
    Enter & Backspace::Delete
#HotIf

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; Delta Delta

MapDeltaDeltaKeys(key) {
    key := MapDeltaKeys(key)
    return key

}
#HotIf GetLayer() == "DeltaDelta"
    [::KeyHistory()
    ]::Refresh()
    Space::{
        global HoldLayer := "Alpha"
    }
#HotIf

;;;;;;;;;;;;;;;;;;;;;;;;;;;;; DIRECT KEY MAPS
; PrintScreen::CapsLock
; Pause::CapsLock

; Offset := 20
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
;keypad mouse scroll
;F17::!Left
;F18::LButton
; !F18::!Left
;F19::RButton
; !F19::!Right
;F20::MButton

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; Enter combos
; Enter & i::Return
; Enter & o::^a
; Enter & P::^x
; Enter & k::Return
; Enter & l::^v
; Enter & b::^c
; Enter & `;::^c
; Enter & ,::^s
; Enter & .::^z
; Enter & /::Return

; Enter & e::Up
; Enter & f::Right
; Enter & d::Down
; Enter & s::Left
; Enter & r::End
; Enter & w::Home
; Enter & t::PgUp
; Enter & g::PgDn


; ; Enter & i::Up
; ; Enter & l::Right
; ; Enter & k::Down
; ; Enter & j::Left
; ; Enter & o::End
; ; Enter & u::Home

; Enter::Send("{Enter}")
; ; Esc::Send("{Esc}")


; Enter::{
;     global EnterPaired := false
;     global EnterDown := true
; }
; sc028 Up::
; Enter Up::{
;     if (!EnterPaired)    {
;         Send("{Blind}{Enter}")
;     }
; }



;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; Tab Combos
; Tab & a::^a

; Tab::Send("{Tab}")

; Space & Backspace::Delete
; Space::Send("{Space}")
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; phi



; #HotIf GetKeyState("F22")
;     1::F1
;     3::^f
;     7::^s
;     F6::ChangeBrightness( -3 ) ; decrease brightness
;     F7::ChangeBrightness( 3 ) ; increase brightness
;     F8::Send("{Volume_Mute}")
;     F9::Send("{Volume_Down}")
;     F10::Send("{Volume_Up}")

;     F11::{
;         KeyHistory(500)
;         KeyHistory()
;         }
;     F12::Refresh()

;     e::Send("{Blind}{Up}")
;     d::Send("{Blind}{Down}")
;     s::Send("{Blind}{Left}")
;     f::Send("{Blind}{Right}")
;     w::Send("{Blind}{Home}")
;     r::Send("{Blind}{End}")

;     i::Send("{Blind}{{}}")

;     h::Send("{Blind}`"")
;     j::Send("{Blind}=")
;     k::Send("{Blind};")
;     l::Send("{Blind}:")
; #HotIf

; F22 & 1::F1
; F22 & 3::^f
; F22 & 7::^s
; F22 & F6::ChangeBrightness( -3 ) ; decrease brightness
; F22 & F7::ChangeBrightness( 3 ) ; increase brightness
; F22 & F8::Send("{Volume_Mute}")
; F22 & F9::Send("{Volume_Down}")
; F22 & F10::Send("{Volume_Up}")


; ;F24 & LShift::MouseNotMouse()
; ;F24 & V::MouseNotMouse()

; ; F24 & 8::return
; ; F24 & 9::return
; ; F24 & 0::return

; ; left

; F22 & e::Send("{Blind}{Up}")
; F22 & d::Send("{Blind}{Down}")
; F22 & s::Send("{Blind}{Left}")
; F22 & f::Send("{Blind}{Right}")
; F22 & w::Send("{Blind}{Home}")
; F22 & r::Send("{Blind}{End}")

; F22 & i::Send("{Blind}{{}}")

; F22 & h::Send("{Blind}`"")
; F22 & j::Send("{Blind}=")
; F22 & k::Send("{Blind};")
; F22 & l::Send("{Blind}:")

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

StartRepeat(key, actionFn, initialWait := 120, repeatWait := 30) {
    SetTimer(() => SetTimer(actionFn, repeatWait), -initialWait)
}

StopRepeat(actionFn) {
    SetTimer(actionFn, 0)
}

TempToolTip(text) {
    ToolTip(text)
    SetTimer () => ToolTip(""), -2000
}

LayerTip() {

}

logKey(isHold, taps, state){
	TempToolTip   (isHold ? "HOLD" : "TAP") " Taps: " taps " State: " state "`n"
}

; KeyWaitCombo(Options:="")
; {
;     ih := InputHook(Options)
;     ; if !InStr(Options, "V")
;     ;     ih.VisibleNonText := false
;     ih.KeyOpt("{All}", "E")  ; End
;     ; Exclude the modifiers
;     ih.KeyOpt("{LCtrl}{RCtrl}{LAlt}{RAlt}{LWin}{RWin}", "-E")
;     ih.Start()
;     ih.Wait()
;     Send("r{LShift up}")
;     return ih.EndMods . ih.EndKey  ; Return a string like <^<+Esc
; }

; LShift::{
;     Send("{Blind}{LShift down}")
;     KeyWaitCombo("V L1")
; }'.....'

; LShift up::{
; }

