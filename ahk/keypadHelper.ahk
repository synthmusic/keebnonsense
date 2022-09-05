; Setup
#include TapHoldManager.ahk
#SingleInstance Force
;DllCall('SetProcessPriorityBoost', 'Ptr', DllCall('GetCurrentProcess'), 'Int', True)
DllCall('SetPriorityClass', 'Ptr', DllCall('GetCurrentProcess'), 'Int', 0x00000080)
Thread "interrupt", 0  ; Make all threads always-interruptible.
A_MaxHotkeysPerInterval := 1000
KeyHistory(100)
SendMode "Event"
CoordMode "ToolTip", "Screen"

;;;;;;;;;;;;;;;;;;;;;;;;; consts
SINGLE_QUOTE := "sc028"
TEENSY_BACKSPACE := "F22"
TEENSY_TAB := "F23"

;;;;;;;;;;;;;;;;;;;;;;;;; "public" globals
IsStandardKeyboard := true
ShowKeyTips := false

;;;;;;;;;;;;;;;;;;;;;;;;; "private" globals
HoldLayer := "Alpha"
TempLayer := ""
HotLeftArrows := 0
HotRightArrows := 0
ToggleDeltaViewState := true
CtrlTabState := false

;;;;;;;;;;;;;;;;;;;;;;;;; Keyboard setup

thm := TapHoldManager(0, 160, 1, "$*")
holdShiftList := "`` 1 2 3 4 5 6 7 8 9 0 -"
                . " Tab q w e r t y u i o p"
                . " a s d f g h j k l `;"
                . " z x c v n m , ."

for str in StrSplit(holdShiftList, " ") {
    thm.Add(str, holdShift.Bind(str))
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
    } else if (held && state)  {
        Send "{Blind}+" . mods . sendKey
    }
}

thm.Add("b", thmB,,,,,,,,true)
thmB(held, taps, state, rolled, mods) {
    if (state == 1) {
        SetLayer "Phi"
        KeyWait("b")
        SetLayer ""
    }
}

thm.Add("`'", thmQuote,,,,,,,0,true)
thmQuote(held, taps, state, rolled, mods) {
    ; TempKeyTip("`'", held, taps, state, rolled, mods)
    if (!held && state == -1) {
        Send "`'"
    }

    if (state == 1) {
        SetLayer "Rho"
        KeyWait("`'")
        SetLayer ""
    }
}
thm.Add("CapsLock", thmDeltaHold.Bind("{Enter}"),,,,,,,0,true)
thm.Add("Enter", thmDeltaHold.Bind("{Enter}"),,,,,,,0,true)
thm.Add(TEENSY_TAB, thmDeltaHold.Bind("{Tab}"),,,,,,,0,true)
thm.Add(TEENSY_BACKSPACE, thmDeltaHold.Bind("{Backspace}"),,,,,,,0,true)
thmDeltaHold(key, held, taps, state, rolled, mods) {
    TempKeyTip("Ent/CL", held, taps, state, rolled, mods)
    if (!held && state == -1) {
        Send "{Blind}" . mods . key
    }

    if (state == 1) {
        SetLayer "Delta"
    } else {
        SetLayer "Alpha"
    }
}

thm.Add("Space", thmSpace,,160,,,,,0,false)
thmSpace(held, taps, state, rolled, mods) {
    ; TempKeyTip("Sp", held, taps, state, rolled, mods)

    if (held)  {
        if (state) {
            TimedTip("-----------------------DELTA-----------------------", 300)
            SetLayer("Delta")
            KeyWait("Space")
            SetLayer("Alpha")
        }
    } else if (!held) {
        Send("{Space}")
    }
}

;;;;;;;;;;;;;;;;;;;;;;;;; layer related functions


SetLayer(name) {
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

ToggleDeltaMessage() {
    if (ToggleDeltaViewState) {
        ToolTip("`n`nSHIFTED", 25, 5, 2)
    } else {
        ToolTip("",,,2)
    }
    global ToggleDeltaViewState := !ToggleDeltaViewState
}

GetLayer() {

    if GetKeyState("b", "P") {
        return "Phi"
    }

    ; if GetKeyState("F23", "P") || GetKeyState("F22", "P") || GetKeyState("CapsLock", "P") || GetKeyState("Enter", "P") {
    ;     return "Delta"
    ; }

    if GetKeyState(SINGLE_QUOTE, "P") {
        return "Rho"
    }

    return HoldLayer
}

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; CAPS LOCK
#HotIf GetKeyState("CapsLock", "T")
-::Send("{Blind}{Shift down}-{Shift up}")
#HotIf

[::Backspace
/::Up
=::Enter

ThisGivesMeAReferencePointInTheLogsandthenwellkeepgoingsoitreallyreallystandsoutinthelogs() {

}
~RAlt::{
    ThisGivesMeAReferencePointInTheLogsandthenwellkeepgoingsoitreallyreallystandsoutinthelogs()
    ClearTips()
}

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; Alpha
MapAlphaKeys(key, held) {
    switch key
    {
        case "Tab": return "{Tab}"
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
        case ";": return "b"
        case "z": return "z"
        case "x": return "x"
        case "c": return "c"
        case "v": return "v"
        case "b": return "b"
        case "n": return "n"
        case "m": return "m"

        default: return key
    }
}

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; Delta

MapDeltaKeys(key, held) {
    ; TempToolTip(key)
    if (!held) {
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
            case "p": return "{F11}"
            case "`;": return "{F12}"
        }
    }

    switch key
    {
        case "Tab": return "{Esc}"
        case "q": return "``"

        case "y": return "j"
        case "u": return "\"
        case "i": return "["
        case "o": return "]"

        case "h": return "/"
        case "j": return "="
        case "k": return ";"
        case "l": return "'"


        default: return key
    }
}

#HotIf GetLayer() == "Delta"

    *a::Send("{Blind}{LShift Down}{LAlt Down}")
    *a Up::Send("{Blind}{LShift Up}{LAlt Up}")

    e::Up
    d::Down
    s::Left
    f::Right
    w::Home
    r::End
    t::PgUp
    g::PgDn

    v::LShift
    c::LAlt

    n::LShift
    m::LAlt

    Backspace::Delete
    [::Delete

    Up::PgUp
    Down::PgDn
    Left::Home
    Right::End
#HotIf


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; Rho

MapRhoKeys(key, held) {
    switch key
    {
        case "o": return "^a"
        case "p": return "^x"
        case "l": return "^v"
        case ";": return "^c"
        case ",": return "^s"
        case ".": return "^z"

        default: return key
    }
}

; #HotIf GetLayer() == "Rho"

; #HotIf

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; Phi

MapPhiKeys(key, held) {
    switch key
    {

        case "r": return "^{Tab}"
        case "w": return "^+{Tab}"

        case "o": return "^{Tab}"
        case "u": return "^+{Tab}"

        case "k": return "!{Left}"
        case "i": return "!{Right}"

        case "d": return "!{Left}"
        case "e": return "!{Right}"

        case "a": return "{CapsLock}"

        case "v": return "{Space}"
        case "t": return "^{F4}"

        case "h": return "^{z}"
        case "y": return "!{F4}"
        case "n": return "{Enter}"
        default: return key
    }
}

#HotIf GetLayer() == "Phi"
    b & f::AltTab

    b & l::AltTab

    b & s::ShiftAltTab

    b & j::ShiftAltTab

    8::KeyHistory()
    9::Refresh()

    6::{
        Send "{F6}{F6}{Right}{Space}"
    }

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

toolTipNum := 5
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
TempToolTip(text) {
    ToolTip(text,100,70*(toolTipNum-5),toolTipNum)

    ; SetTimer UnToolTip.Bind(toolTipNum), -6000
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
    TempToolTip(key . " state " . state . "`n" . (held ? "held: " : "tap: ") . taps . " " . GetLayer() . "`n" . mods . " " . (rolled ? "rolled" : ""))
}
