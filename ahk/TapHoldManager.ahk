; https://github.com/evilC/TapHoldManager/blob/master/lib/TapHoldManager.ahk
; https://www.autohotkey.com/boards/viewtopic.php?f=6&t=45116

class TapHoldManager {
	Bindings := Map()
	rollingKeys := Array()
	rollingKeysActive := true
	activeKeys := Map()

	__New(tapGap := -1, holdTime := -1, maxTaps := -1, prefixes := "$", window := ""){
		if (tapGap == -1)
			tapGap := 50
		if (holdTime == -1)
			holdTime := tapGap + 100
		this.tapGap := tapGap
		this.holdTime := holdTime
		this.maxTaps := maxTaps
		this.prefixes := prefixes
		this.window := window
	}

	Add(keyName, callback, tapGap := -1, holdTime := -1, maxTaps := -1, prefixes := -1, window := "", isRollingKey := 1, isRollale := 1, notifyTapDown := 0){    ; Add hotkey
		this.Bindings[keyName] := KeyManager(this, keyName, callback, tapGap, holdTime, maxTaps, prefixes, window, isRollingKey, isRollale, notifyTapDown)
	}

	RemoveHotkey(keyName){ ; to remove hotkey
		this.Bindings[keyName].SetHotState(0)
		this.Bindings[keyName] := {}

		this.Bindings.delete(keyName)
	}

	PauseHotkey(keyName) { ; to pause hotkey temprarily
		this.Bindings[keyName].SetHotState(0)
	}

	ResumeHotkey(keyName) { ; resume previously deactivated hotkey
		this.Bindings[keyName].SetHotState(1)
	}

	; AddRollingKeys(csvString) {
	; 	; there is only one hotkey per key, so check first and don't override
	; 	; if a thm key is added later, it will override this
	; 	; todo: deal with remove, pause and resume above
	; 	for str in StrSplit(csvString, " ") {
	; 		if (str != "") {
	; 			this.rollingKeys.Push(Trim(str))
	; 		}
	; 	}

	; 	for key in this.rollingKeys {
	; 		if (!this.Bindings.Has(key)) {
	; 			Hotkey this.prefixes key, this.RollingKeyDown.Bind(this, key)
	; 		}
	; 	}
	; }

	; RollingKeyDown(key := "", thisHotKey := "") {
	; 	this.RolledKeysUp(key)
	; 	Send "{Blind}{" key "}"
	; }

	; we have built the assumption that this executes before the current key is put in the list
	; RolledKeysUp(thisHotKey := "") {
	RolledKeysUp() {
		if(this.rollingKeysActive) {
			for key, keyMgr in this.activeKeys {
				; if (key != thisHotKey && keyMgr.isRollale) {
				if (keyMgr.isRollale) {
					keyMgr.KeyUp(key, true)
				}
			}
		}
	}

	SetRollingKeysActive(state) {
		this.rollingKeysActive := state
	}
}

/*
keyName					The name of the key to declare a hotkey to

*/
class KeyManager {
	state := 0					; Current state of the key
	sequence := 0				; Number of taps so far

	holdWatcherState := 0		; Are we potentially in a hold state?
	tapWatcherState := 0		; Has a tap release occurred and another could possibly happen?

	holdActive := 0				; A hold was activated and we are waiting for the release
	downMods := ""

	__New(manager, keyName, Callback, tapGap := -1, holdTime := -1, maxTaps := -1, prefixes := -1, window := "", isRollingKey := 1, isRollale := 1, notifyTapDown := 0){
		this.manager := manager
		this.Callback := Callback
		if (tapGap == -1){
			this.tapGap := manager.tapGap
		} else {
			this.tapGap := tapGap
		}

		if (holdTime == -1){
			this.holdTime := manager.holdTime
		} else {
			this.holdTime := holdTime
		}

		if (maxTaps == -1){
			this.maxTaps := manager.maxTaps
		} else {
			this.maxTaps := maxTaps
		}

		if (prefixes == -1){
			this.prefixes := manager.prefixes
		} else {
			this.prefixes := prefixes
		}

		if (window){ ; if window criteria is passed-in
			this.window := window
		} else { ; if no window criteria passed-in
			this.window := manager.window
		}

		this.lastTickCount := 0

		this.keyName := keyName
		this.isRollingKey := isRollingKey
		this.isRollale := isRollale
		this.notifyTapDown := notifyTapDown

		this.HoldWatcherBound := this.HoldWatcher.Bind(this)
		this.TapWatcherBound := this.TapWatcher.Bind(this)
		this.JoyButtonReleaseBound := this.JoyButtonRelease.Bind(this)
		this.JoyButtonWatcherBound := this.JoyButtonWatcher.Bind(this)
		this.KeyDownBound := this.KeyDown.Bind(this)
		this.KeyUpBound := this.KeyUp.Bind(this)
		this.FireCallbackBound := this.FireCallback.Bind(this)

		this.DeclareHotkeys()
	}

	DeclareHotkeys(){
		if (this.window)
			HotIfWinActive this.window ; sets the hotkey window context if window option is passed-in

		hotkey this.prefixes this.keyName, this.KeyDownBound, "On" ; On option is important in case hotkey previously defined and turned off.
		if (SubStr(this.keyName, 2, 3) == "joy"){
			hotkey this.keyName " up", this.JoyButtonReleaseBound, "On"
		} else {
			hotkey this.prefixes this.keyName " up", this.KeyUpBound, "On"
		}

		if (this.window)
			HotIfWinActive ; retrieves hotkey window context to default
	}

	SetHotState(hotState){ ; turns On/Off hotkeys (should be previously declared) // hotState is either "1: On" or "0: Off"
		; "hotState" under this method context refers to whether the hotkey will be turned on or off, while in other methods context "state" refers to the current activity on the hotkey (whether it's pressed or released (after a tap or hold))
		if (this.window)
			HotIfWinActive this.window ; sets the hotkey window context if window option is passed-in

		hotkey this.prefixes this.keyName, (hotState ? "On" : "Off")

		if (SubStr(this.keyName, 2, 3) == "joy"){
			hotkey this.keyName " up", (hotState ? "On" : "Off")
		} else {
			hotkey this.prefixes this.keyName " up", (hotState ? "On" : "Off")
		}

		if (this.window)
			HotIfWinActive ; sets the hotkey window context if window option is passed-in
	}

	JoyButtonRelease(key){
		SetTimer this.JoyButtonWatcherBound, 10
	}

	JoyButtonWatcher(){
		if (!GetKeyState(this.keyName)){
			SetTimer this.JoyButtonWatcherBound, 0
			this.KeyUp(this.keyName)
		}
	}

	KeyDown(thisHotKey){
		() => key := "down"
		if (this.state == 1)
			return	; Suppress Repeats

		; we have built the assumption that this executes before the current key is put in the list

		if (this.isRollingKey)
			this.manager.RolledKeysUp()

		this.state := 1
		this.sequence++
		this.manager.activeKeys[this.keyName] := this

		this.downMods :=
			(GetKeyState("Shift") ? "+" : "") .
			(GetKeyState("Ctrl") ? "^" : "") .
			(GetKeyState("Alt") ? "!" : "") .
			(GetKeyState("LWin") ? "#" : "")

		this.SetHoldWatcherState(1)
		if (this.sequence > 1) {
			this.SetTapWatcherState(0)
		}
		if (this.notifyTapDown){
			this.FireCallback(false, this.sequence, 1, false, this.downMods)
		}
	}

	KeyUp(thisHotKey, rolled := 0){
		() => key := "up"
		; Send("up " thisHotKey this.sequence this.state "`n" )
		if (this.state == 0)
			return	; Suppress if rolling keys already released it
		this.state := 0



		this.SetHoldWatcherState(0)

		if (this.holdActive){
			this.FireCallback(true, this.sequence, 0, rolled, this.downMods)
			this.ResetSequence()
		} else if (this.Sequence == this.maxTaps){
			this.FireCallback(false, this.sequence, -1, rolled, this.downMods)
			this.ResetSequence()
		} else  {
			this.SetTapWatcherState(1)
		}


		; Send("up " thisHotKey this.sequence this.state "`n" )
	}

	ResetSequence(){
		() => key := "reset"
		this.SetHoldWatcherState(0)
		this.SetTapWatcherState(0)
		this.sequence := 0
		this.holdActive := 0
		this.manager.activeKeys.delete(this.keyName)
		this.downMods := ""
	}

	; When a key is pressed, if it is not released within hold, then it is considered a hold
	SetHoldWatcherState(state){
		() => key := "SetHoldWatcherState"
		; Send("hold" state "`n")
		this.holdWatcherState := state
		SetTimer this.HoldWatcherBound, (state ? -this.holdTime : 0)
	}

	; When a key is released, if it is re-pressed within tapGap, the sequence increments
	SetTapWatcherState(state){
		() => key := "SetTapWatcherState"
		; Send("tap" state "`n")
		this.tapWatcherState := state
		SetTimer this.TapWatcherBound, (state ? -this.tapGap : 0)
	}

	; If this function fires, a key was held for longer than the tap timeout, so engage hold mode
	HoldWatcher(){
		() => key := "HoldWatcher"
		if (this.sequence > 0 && this.state == 1){
			; Got to end of tapGap after first press, and still held.
			; HOLD PRESS
			this.FireCallback(true, this.sequence, 1)
			this.holdActive := 1
		}
	}

	; If this function fires, a key was released and we got to the end of the tap timeout, but no press was seen
	TapWatcher(){
		() => key := "TapWatcher"
		if (this.sequence > 0 && this.state == 0){
			; TAP
			this.FireCallback(false, this.sequence)
			this.ResetSequence()
		}
	}

	FireCallback(isHold, seq, state := -1, rolled := 0, mods := ""){
		() => key := "FireCallback"
		; Send(isHold . seq . state . rolled . mods . "`n")

		cb := this.Callback.Bind(isHold, seq, state, rolled, mods)
		SetTimer(cb, -1)
		; cb()

		; this.Callback.Call(state != -1, seq, state)
	}
}