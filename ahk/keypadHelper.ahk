Version := "2.0.5"

; Setup
#include TapHoldManager.ahk
#SingleInstance Force
;DllCall('SetProcessPriorityBoost', 'Ptr', DllCall('GetCurrentProcess'), 'Int', True)
; DllCall('SetPriorityClass', 'Ptr', DllCall('GetCurrentProcess'), 'Int', 0x00000080)
; Thread "interrupt", 0  ; Make all threads always-interruptible.
; A_MaxHotkeysPerInterval := 1000
KeyHistory(80)
; SendMode "Event"
CoordMode "ToolTip", "Screen"

;; DO NOT USE F24 OR F22 AS THEY INTERFERE WITH THE TOUCHPAD 3 AND 4 FINGER GESTURES
;;;;;;;;;;;;;;;;;;;;;;;;; consts
SINGLE_QUOTE := "sc028"
MOD_KEY_RHO := SINGLE_QUOTE
DO_NOT_USE_F22 := "F22"
DO_NOT_USE_F24 := "F24"
MOD_KEY_DELTA := "F16"
MOD_KEY_PHI := "F17"
MOD_KEY_RHO := "F18"

KEY_RESET := "F13"
KEY_CENTER_MOUSE := "F21"

;;;;;;;;;;;;;;;;;;;;;;;;; "public" globals
IsStandardKeyboard := false
ShowKeyTips := false
FunctionLock := false
DeltaCount := 0
phiKeys := Map()

;;;;;;;;;;;;;;;;;;;;;;;;; "private" globals
HoldLayer := "Alpha"
TempLayer := ""
ToggleDeltaNotificationState := true
toolTipNum := 5

;;;;;;;;;;;;;;;;;;;;;;;;; Keyboard setup

thm := TapHoldManager(0, 160, 1, "$*")
holdShiftList := "`` 1 2 3 4 5 6 7 8 9 0 - ="
    . " q w e r t y u i o p [ ] \"
    . " s d f g h j k l `; `'"
    . " z x c v b n m , . /"

for str in StrSplit(holdShiftList, " ") {
    thmStandardKey(str)
}
thm.Add("a", holdShift.Bind("a"), 0, 220)

thmStandardKey(key) {
    thm.Add(key, holdShift.Bind(key))
}

holdShift(key, held, taps, state, rolled, mods) {
    TempKeyTip(key, held, taps, state, rolled, mods)
    sendKey := ""
    switch GetLayer()
    {
    case "Delta":
        sendKey := MapDeltaKeys(key, held)
    case "Phi":
        sendKey := MapPhiKeys(key, held)
    case "Rho":
        sendKey := MapRhoKeys(key, held)
    default:
        sendKey := MapAlphaKeys(key, held)
    }

    if (!held) {
        Send "{Blind}" . mods . sendKey
    } else if (held && state) {
        Send "{Blind}+" . mods . sendKey
    }
}

thm.Add(MOD_KEY_RHO, thmRho.Bind(MOD_KEY_RHO),,,,,,,0,true)
thmRho(key, held, taps, state, rolled, mods) {
    ; TempKeyTip("`'", held, taps, state, rolled, mods)
    ; if (!held && state == -1) {
    ;     Send "{Blind}`'"
    ; }

    if (state == 1) {
        SetLayer ("Rho")
        KeyWait(key)
        SetLayer ("")
    }
}

thm.Add("CapsLock", thmDeltaHold.Bind("{Enter}"),,,,,,,0,true)
thm.Add("Enter", thmDeltaHold.Bind("{Enter}"),,,,,,,0,true)
thm.Add("Tab", thmDeltaHold.Bind("{Tab}"),,,,,,,0,true)
thm.Add("Backspace", thmDeltaHold.Bind("{Backspace}"),,,,,,,0,true)
thm.Add("F24", thmDeltaHold.Bind(""),,,,,,,0,true)
thmDeltaHold(key, held, taps, state, rolled, mods) {
    TempKeyTip("Ent/CL", held, taps, state, rolled, mods)
    if (!held && state == -1) {
        if (key == "{Tab}") {
            if GetKeyState("Enter", "P") || GetKeyState("Backspace", "P") || GetKeyState("Space", "P") {
                ; if GetLayer() == "Delta" {
                key := "{Esc}"
            }
        }
        if (key == "{Backspace}") {
            if GetKeyState("Enter", "P") || GetKeyState("Tab", "P") || GetKeyState("Space", "P") {
                key := "{Delete}"
            }
        }
        Send "{Blind}" . mods . key
    }
    if (state == 1 && !held) {
        global DeltaCount := DeltaCount + 1
        SetLayer "Delta"
    } else if (state != 1) {
        global DeltaCount := DeltaCount - 1
        if (DeltaCount == 0) {
            SetLayer "Alpha"
        }
    }
}

thm.Add("Space", thmSpace,,160,,,,,0,false)
thmSpace(held, taps, state, rolled, mods) {
    ; TempKeyTip("Sp", held, taps, state, rolled, mods)
    if (GetLayer() == "Delta") {
        holdShift("Space", held, taps, state, rolled, mods)
        return
    }

    if (held) {
        if (state) {
            TimedTip("⬛⬛⬛⬛⬛⬛⬛⬛⬛⬛ DELTA ⬛⬛⬛⬛⬛⬛⬛⬛⬛⬛`n⬛⬛⬛⬛⬛⬛⬛⬛⬛⬛⬛⬛⬛⬛⬛⬛⬛⬛⬛⬛⬛⬛⬛⬛", 350)
            SetLayer("Delta")
            KeyWait("Space")
            SetLayer("Alpha")
        }
    } else if (!held) {
        Send("{Blind}{Space}")
    }
}

SetStandardKeyboard(false)

;;;;;;;;;;;;;;;;;;;;;;;;; layer related functions

SetLayer(name) {
    ; ToolTipRotator(name)
    switch(name)
    {
    case "Alpha":
        global HoldLayer := name
    case "Delta":
        global HoldLayer := name
    case "Phi":
        global TempLayer := name
    case "Rho":
        global TempLayer := name
    default:
        global TempLayer := ""
    }
}

GetLayer() {
    if TempLayer != "" {
        return TempLayer
    }
    ;;;;;;;;;;;;; This is here because the key is also bound to the alt tab so we don't get a key down event
    For phiKey in phiKeys{
        if GetKeyState(phiKey, "P") {
            return "Phi"
        }
    }

    return HoldLayer
}

SetStandardKeyboard(isStandard) {
    global IsStandardKeyboard := isStandard
    TimedTip("Standard Keyboard: " . IsStandardKeyboard, 3000)
    if (isStandard){
        addPhiKey("``")
        addPhiKey("]")
    } else {
        addPhiKey(MOD_KEY_PHI)
        removePhiKey("``")
        removePhiKey("]")
    }
}

#HotIf IsStandardKeyboard
RAlt::RCtrl
RCtrl::RAlt
#HotIf

addPhiKey(key) {
    phiKeys[key] := true
    mapAltTab(key)
}
removePhiKey(key) {
    if (phiKeys.Has(key)){
        phiKeys.Delete(key)
        unmapAltTab(key)
    }
}
mapAltTab(key) {
    HotKey(key . " & e", "AltTab")
    HotKey(key . " & i", "AltTab")
    HotKey(key . " & d", "ShiftAltTab")
    HotKey(key . " & k", "ShiftAltTab")
}

unmapAltTab(key) {
    HotKey(key . " & e", "Off")
    HotKey(key . " & i", "Off")
    HotKey(key . " & d", "Off")
    HotKey(key . " & k", "Off")
}
;KEY_RESET
*F13::{
    SetStandardKeyboard(false)
    ClearAll()
    Refresh()
}
;KEY_CENTER_MOUSE
; F14::CenterMouse()

Insert::{
    SetStandardKeyboard(true)
    ClearAll()
}

ThisGivesMeAReferencePointInTheLogsandthenwellkeepgoingsoitreallyreallystandsoutinthelogs() {

}
; ~RAlt::{
;     ThisGivesMeAReferencePointInTheLogsandthenwellkeepgoingsoitreallyreallystandsoutinthelogs()
;     ClearTips()
; }

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; CAPS LOCK
#HotIf GetKeyState("CapsLock", "T")
-::Send("{Blind}{Shift down}-{Shift up}")
#HotIf

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; Alpha
MapAlphaKeys(key, held) {
    if (FunctionLock) {
        FunctionTest := FunctionKeys(key)
        if (FunctionTest) {
            return FunctionTest
        }
    }
    switch key
    {
    case "1": return "1"
    case "2": return "2"
    case "3": return "3"
    case "4": return "4"
    case "5": return "5"
    case "6": return "6"
    case "7": return "7"
    case "8": return "8"
    case "9": return "9"
    case "0": return "0"
    case "-": return "-"
    case "=": return "="
    case "q": return "q"
    case "w": return "w"
    case "e": return "e"
    case "r": return "r"
    case "t": return "t"
    case "y": return "y"
    case "u": return "u"
    case "i": return "i"
    case "o": return "o"
    case "p": return "p"
    case "a": return "a"
    case "s": return "s"
    case "d": return "d"
    case "f": return "f"
    case "g": return "g"
    case "h": return "h"
    case "j": return "j"
    case "k": return "k"
    case "l": return "l"
    case "z": return "z"
    case "x": return "x"
    case "c": return "c"
    case "v": return "v"
    case "b": return "b"
    case "n": return "n"
    case "m": return "m"
    case ",": return ","
    case ".": return "."

    default: return key
    }
}

FunctionKeys(key) {
    switch key
    {
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
    case "-": return "{F11}"
    case "=": return "{F12}"
    default: return ""
    }
}
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; Delta

MapDeltaKeys(key, held) {
    ; ToolTipRotator(key)

    if (IsStandardKeyboard) {
        switch key
        {
        case "Tab": return "{Esc}"
        case "Backspace": return "{Delete}"

        ;  right half
        case "y": return "``"
        case "u": return "["
        case "i": return "]"
        case "o": return "\"
        case "h": return "-"
        case "j": return "="
        case "k": return ";"
        case "l": return "'"

        case "m": return "^{z}"
        case ",": return "/"

        default: return key
        }
    }
    ; else
    switch key
    {
    case "Tab": return "{Esc}"
    case "Backspace": return "{Delete}"

    ;  right half
    case "y": return ""
    case "u": return "7"
    case "i": return "8"
    case "o": return "9"
    case "h": return ""
    case "j": return "4"
    case "k": return "5"
    case "l": return "6"

    case "n": return "0"
    case "m": return "1"
    case ",": return "2"
    case ".": return "3"

    case "Space": return "0"

    default: return key
    }

}

#HotIf GetLayer() == "Delta" || GetLayer() == "Rho"

q::LShift
w::Home
e::Up
r::End
t::PgUp

*a::{
    Send("{Blind}{LShift Down}{LAlt Down}")
    KeyWait("a")
    Send("{Blind}{LShift Up}{LAlt Up}")
}
s::Left
d::Down
f::Right
g::PgDn

; z::
; x::
; c::
v::LAlt
b::LCtrl

Up::PgUp
Down::PgDn
Left::Home
Right::End
#HotIf

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; Rho

MapRhoKeys(key, held) {
    switch key
    {
    case "i": return "^a"
    case "o": return "^x"
    case "j": return "{Enter}"
    case "k": return "^v"
    case "l": return "^c"
    case "m": return "^s"
    case ",": return "^z"

    case "h": ShowWindowData(true)
    case "n": ShowWindowData(false)

    default: return key
    }
}

#HotIf GetLayer() == "Rho"
-::{
    SetStandardKeyboard(!IsStandardKeyboard)
}
BackSpace::BackSpace
Space::Space
#HotIf

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; Phi

MapPhiKeys(key, held) {
    FunctionTest := FunctionKeys(key)
    if (FunctionTest) {
        return FunctionTest
    }

    switch key
    {

    case "w": return "^+{Tab}"
    case "r": return "^{Tab}"

    case "j": return "!{Left}"
    case "l": return "!{Right}"

    case "o": return "^{Tab}"
    case "u": return "^+{Tab}"

    case "s": return "!{Left}"
    case "f": return "!{Right}"

    case "a": return "{CapsLock}"

    case "g": return "{Space}"
    case "t": return "^{F4}"

    case "m": return "!{F4}"

    default: return key
    }
}

#HotIf GetLayer() == "Phi"
;;;;;;;;;;;;;;;;;;;; IF you bind MOD keys here, you MUST modify the getlayer section!!
; MOD_KEY_PHI

q::{
    global FunctionLock := !FunctionLock
    TimedTip("Function Lock: " . FunctionLock, 3000)
}
Up::KeyHistory()
.::{
    Send("^s")
    Refresh()
}

; n::CenterMouse()

Tab::Esc
Backspace::Delete
Space::Enter
Enter::Space

#HotIf

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

ShowWindowData(monitor)
{
    if (monitor)
        MonitorGetWorkArea 1, &X, &Y, &W, &H
    else
        WinGetPos &X, &Y, &W, &H, "A"
    MsgBox "Pos: " X " , " Y " - w/h: " W " x " H
}

; CenterMouse()
; {
;     WinGetPos &X, &Y, &W, &H, "A"
;     ; MouseMove X + (W/2), Y - (H/2)
;     MouseMove w/2, h/2
; }

Refresh()
{
    ; this reloads the script
    Sleep (100)
    Run "C:\Users\synth\Documents\exec\keebnonsense\ahk\keypadHelper.ahk"
}

ToggleDeltaMessage() {
    if (ToggleDeltaNotificationState) {
        ToolTip("`n`nSHIFTED", 25, 5, 2)
    } else {
        ToolTip("",,,2)
    }
    global ToggleDeltaNotificationState := !ToggleDeltaNotificationState
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

StartRepeat(key, actionFn, initialWait := 120, repeatWait := 30) {
    SetTimer(() => SetTimer(actionFn, repeatWait), -initialWait)
}

StopRepeat(actionFn) {
    SetTimer(actionFn, 0)
}

ResetToolTip() {
    global toolTipNum := 5
}
UnToolTip(num) {
    ToolTip("",,,num)
}
ClearTips() {
    i := 1
    while (i <= 20) {
        UnToolTip(i)
        i := i + 1
    }
}
ToolTipRotator(text) {
    ToolTip(text,100,70*(toolTipNum-5),toolTipNum)

    SetTimer UnToolTip.Bind(toolTipNum), -6000
    ; SetTimer ResetToolTip, -4000
    global toolTipNum := toolTipNum > 19 ? 5 : toolTipNum + 1
    ToolTip("",,,toolTipNum)
}
TimedTip(text, time) {
    ToolTip(text)
    SetTimer ToolTip.Bind(""), -time
}
TempKeyTip(key, held, taps, state, rolled, mods) {
    if (!showKeyTips)
        return
    ToolTipRotator(key . " state " . state . "`n" . (held ? "held: " : "tap: ") . taps . " " . GetLayer() . "`n" . mods . " " . (rolled ? "rolled" : ""))
}
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; No Layer functions
PrintScreen::{

}

ClearAll() {
    ; if GetKeyState("CapsLock", "T") {
    ;     Send("{CapsLock}")
    ; }
    SetLayer("")
    SetLayer("Alpha")
    global DeltaCount := 0
    SetCapsLockState(0)
    Sleep(70)
    Send("{LWin}")
    Sleep(70)
    Send("{Shift down}")
    Send("{Alt down}")
    Send("{Ctrl down}")
    Sleep(70)
    Send("{Shift up}")
    Send("{Alt up}")
    Send("{Ctrl up}")
    Sleep(70)
    Send("{LShift down}")
    Send("{LAlt down}")
    Send("{LCtrl down}")
    Sleep(70)
    Send("{LShift up}")
    Send("{LAlt up}")
    Send("{LCtrl up}")
    Sleep(70)
    Send("{RShift down}")
    Send("{RAlt down}")
    Send("{RCtrl down}")
    Sleep(70)
    Send("{RShift up}")
    Send("{RAlt up}")
    Send("{RCtrl up}")
    Sleep(270)
    Send("{LWin}")
    Sleep(70)
    ; Send("{RWin down}")
    ; Sleep(70)
    ; Send("{RWin up}")
    ; Sleep(70)
}
