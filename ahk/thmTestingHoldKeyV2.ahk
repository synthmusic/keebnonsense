; v2 - v2.0-beta.7
DllCall('SetPriorityClass', 'Ptr', DllCall('GetCurrentProcess'), 'Int', 0x00000080)

hotkey("$1", test)
hotkey("*2", test)
hotkey("3", test)
test(key) {
    Send(".")
}
