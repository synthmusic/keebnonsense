; Setup
#include TapHoldManager.ahk
#SingleInstance Force
DllCall('SetProcessPriorityBoost', 'Ptr', DllCall('GetCurrentProcess'), 'Int', True)
DllCall('SetPriorityClass', 'Ptr', DllCall('GetCurrentProcess'), 'Int', 0x00000080)
Thread "interrupt", 0  ; Make all threads always-interruptible.
A_MaxHotkeysPerInterval := 1000
KeyHistory(100)
SendMode "Event"
CoordMode "ToolTip", "Screen"

;;;;;;;;;;;;;;;;;;;;;;;;; consts
SINGLE_QUOTE := "sc028"

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
                . " q w e r t y u i o p [ ]"
                . " a s d f g h j k l `;"
                . " z x c v n m , . /"

for str in StrSplit(holdShiftList, " ") {
    thm.Add(str, holdShift.Bind(str))
}

; thm.Add("z", thmZ,200,600,1,,,,false,true)
; thmZ(held, taps, state, rolled, mods) {
;     TempKeyTip("z", held, taps, state, rolled, mods)
; }


holdShift(key, held, taps, state, rolled, mods) {
    TempKeyTip(key, held, taps, state, rolled, mods)
    sendKey := ""
    switch GetLayer()
    {
        case "Delta":
            sendKey := MapDeltaKeys(key, held)
        case "DeltaDelta":
            sendKey := MapDeltaDeltaKeys(key, held)
        case "EntPair":
            sendKey := MapEntPairKeys(key, held)
        default:
            sendKey := MapAlphaKeys(key, held)
    }

    if (!held) {
        Send "{Blind}" . mods . sendKey
    } else if (held && state)  {
        Send "{Blind}+" . mods . sendKey
    }
}

thm.Add("b", thmB,200,600,2,,,,false,true)
thmB(held, taps, state, rolled, mods) {
    TempKeyTip("b", held, taps, state, rolled, mods)
    if (!held) {
        if (taps == 1){
            SetLayer "Alpha"
        } else if (taps == 2) {
            SetLayer "Delta"
        }
    } else {
        SetLayer "Alpha"
    }

    if (state == 1) {
        SetLayer "DeltaDelta"
    } else {
        SetLayer ""
    }
}

thm.Add("`'", thmQuote,,,,,,,,true)
thmQuote(held, taps, state, rolled, mods) {
    TempKeyTip("`'", held, taps, state, rolled, mods)
    if (!held && state == -1) {
        Send "'"
    }

    if (state == 1) {
        SetLayer "EntPair"
        KeyWait("`'")
        SetLayer ""
        TempToolTip("entpair")
    }
}

thm.Add("Enter", thmEnter.Bind("{Enter}"),,,,,,,0,true)
thm.Add("CapsLock", thmEnter.Bind("{Enter}"),,,,,,,0,true)
thm.Add("Tab", thmEnter.Bind("{Tab}"),,,,,,,0,true)
thmEnter(key, held, taps, state, rolled, mods) {
    TempKeyTip("Ent/CL", held, taps, state, rolled, mods)
    if (!held && state == -1) {
        Send mods . key
    }

    if (state == 1) {
        SetLayer "EntPair"
    } else {
        SetLayer ""
    }
}

sendSpace  := Send.Bind("{Space down}")
thm.Add("Space", thmSpace)
thmSpace(held, taps, state, rolled, mods) {
    if("space")
    TempKeyTip("Sp", held, taps, state, rolled, mods)

    if (held)  {
        if (state) {
            Send("{Space down}")
        } else {
            Send("{Space up}")
        }
    } else if (!held) {
        Send("{Space}")
    }
}

; thm.rollingKeysActive := false
; thm.AddRollingKeys(holdShiftList . " Enter")
; thm.AddRollingKeys("Space")

;;;;;;;;;;;;;;;;;;;;;;;;; layer related functions


SetLayer(name) {
    switch(name)
    {
        case "Alpha":
            ToolTip("A", 200, 300, 2)
            SetTimer () => ToolTip("",,,2), -3000
            SetTimer ToggleDeltaMessage, 0
            global HoldLayer := name
        case "Delta":
            global ToggleDeltaViewState := true
            SetTimer ToggleDeltaMessage, 400
            global HoldLayer := name
        ; case "Phi":
        ;     ToolTip("Phi", 300, 200, 2)
        ;     SetTimer () => ToolTip("",,,2), -3000
        ;     SetTimer ToggleDeltaMessage, 0
        ;     global HoldLayer := name
        case "DeltaDelta":
            global TempLayer := name
        case "EntPair":
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
    ; return TempLayer ? TempLayer : HoldLayer

    if GetKeyState("b", "P") || GetKeyState("F23", "P") {
        return "DeltaDelta"
    }

    if GetKeyState("Enter", "P") || GetKeyState(SINGLE_QUOTE, "P") || GetKeyState("Tab", "P") || GetKeyState("CapsLock", "P") {
        return "EntPair"
    }

    ; return LayerDelta || GetKeyState("Enter", "P")||
    ; if GetKeyState("F24", "P") {
    ;     return "Phi"
    ; }

    ; TempToolTip(layer)
    return HoldLayer
}

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; CAPS LOCK
#HotIf GetKeyState("CapsLock", "T")
-::Send("{Blind}{Shift down}-{Shift up}")
#HotIf

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; ALL
; PrintScreen::
; ^+BackSpace::{
;     global IsStandardKeyboard := !IsStandardKeyboard
; }

F16::{
    global IsStandardKeyboard := false
}

F23::{
    SetLayer "Delta"
}

`::
F24::{
    SetLayer "Phi"
}

F20::Scroll("WU", "F20")
F21::Scroll("WD", "F21")
=::Scroll("WU", "=")
[::Scroll("WD", "[")
]::Scroll("WD", "]")

*F20::Scroll("WU", "F20")
*F21::Scroll("WD", "F21")
*=::Scroll("WU", "=")
*[::Scroll("WD", "[")
*]::Scroll("WD", "]")

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
        case ";": return "b"
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
        case "/": return "{Up}"

        default: return key
    }
}

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; Delta

MapDeltaKeys(key, held) {
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
        case "q": return "``"

        case "y": return "-"
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

#HotIf GetLayer() == "Delta" || GetLayer() == "DeltaDelta" || GetLayer() == "Phi"

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

    ; v::LShift
    ; c::LAlt

    ; n::LShift
    ; m::LAlt
#HotIf

; #HotIf GetLayer() == "Phi"

;     i::Up
;     k::Down
;     j::Left
;     l::Right
;     u::Home
;     o::End
;     y::PgUp
;     h::PgDn

; #HotIf

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; Ent Pair

MapEntPairKeys(key, held) {
    switch key
    {
        case "o": return "^a"
        case "p": return "^x"
        case "l": return "^v"
        case ";": return "^c"
        case ",": return "^s"
        case ".": return "^z"

        ; case "m": return "!{Left}"
        ; ; case ",": return "!{Right}"

        ; case "r": return "^{Tab}"
        ; case "w": return "^+{Tab}"
        ; case "i": return "^{Tab}"
        ; case "u": return "^+{Tab}"
        ; case "x": return "!{Left}"
        ; case "v": return "!{Right}"
        ; case "a": return "{CapsLock}"
        default: return key
    }
}
#HotIf GetLayer() == "EntPair"
    Enter & f::AltTab
    ' & f::AltTab
    CapsLock & f::AltTab
    Tab & f::AltTab
    Enter & d::ShiftAltTab
    ' & d::ShiftAltTab
    CapsLock & d::ShiftAltTab
    Tab & d::ShiftAltTab
    Enter & s::ShiftAltTab
    ' & s::ShiftAltTab
    CapsLock & s::ShiftAltTab
    Tab & s::ShiftAltTab
    Enter & j::ShiftAltTab
    ' & j::ShiftAltTab
    CapsLock & j::ShiftAltTab
    Tab & j::ShiftAltTab
    Enter & k::AltTab
    ' & k::AltTab
    CapsLock & k::AltTab
    Tab & k::AltTab
    Enter & Space::AltTab
    ' & Space::AltTab
    CapsLock & Space::AltTab
    Tab & Space::AltTab

    t::{
        Send "{F6}{F6}{Right}{Space}"
    }

    ; r::{
    ;     if (!CtrlTabState) {
    ;         global CtrlTabState := true
    ;         Send "{Ctrl down}"
    ;     }
    ;     Send "{Tab}"
    ; }
    ; r up::
    ; e up::{
    ;     global CtrlTabState := false
    ;     Send "{Ctrl up}"
    ; }

    Backspace::Delete
#HotIf

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; Delta Delta

MapDeltaDeltaKeys(key, held) {
    key := MapDeltaKeys(key, held)
    return key
}

#HotIf GetLayer() == "DeltaDelta"
    F20::KeyHistory()
    =::KeyHistory()
    F21::Refresh()
    [::Refresh()
    ]::Refresh()
    Space::{
        SetLayer "Delta"
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

TempKeyTip(key, held, taps, state, rolled, mods) {
    if (!showKeyTips)
        return
    TempToolTip(key . " state " . state . "`n" . (held ? "held: " : "tap: ") . taps . " " . GetLayer() . "`n" . mods . " " . (rolled ? "rolled" : ""))
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
