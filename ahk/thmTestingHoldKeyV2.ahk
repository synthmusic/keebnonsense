; v2 - v2.0-beta.7
; DllCall('SetPriorityClass', 'Ptr', DllCall('GetCurrentProcess'), 'Int', 0x00000080)

hotkey("$1", testSend)
hotkey("2", testSend)
hotkey("$3", testSendEvent)
hotkey("$4", testSendInput)
hotkey("$5", testSendPlay)
hotkey("$6", testSendText)
hotkey("$7", testControlSend)
hotkey("$8", testNoSend)
testSend(key) {
    Send(".")
}
testSendInput(key) {
    SendInput(".")
}
testSendPlay(key) {
    SendPlay(".")
}
testSendEvent(key) {
    SendEvent(".")
}
testSendText(key) {
    SendText(".")
}
testControlSend(key) {
    ControlSend(".",,)
}
testNoSend(key) {
}
