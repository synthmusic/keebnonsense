-- keys:  https://docs.microsoft.com/en-us/windows/win32/inputdev/virtual-key-codes?redirectedfrom=MSDN


--work new
lmc_device_set_name('MACRO_RIGHT', 'D7729F4')   
lmc_device_set_name('MACRO_LEFT', '164E1D07')
lmc_device_set_name('NUMPAD', '2D63D1DA')

--home new
lmc_device_set_name('MACRO_LEFT', '2E46EFCA')
lmc_device_set_name('MACRO_RIGHT', '498555C')
lmc_device_set_name('NUMPAD', '185EFF4E')


lmc.minimizeToTray = true
lmc_minimize()

pressedLog = {}
isRightNumpad = false



-- val2 = {1,2, ""}
-- print(#val2)
-- print(table.remove(val2,2))
-- print(#val2)
-- for k,v in ipairs(val2) do 
--     print(k,v)
-- end

clear()



kc = {
    Backspace = {0x08,0x0},
    Del = {0x2E,0x0},

    F3 = {0x72,0x0},
    F4 = {0x73,0x0},
    F13 = {0x7C,0x0},  --space
    F14 = {0x7D,0x0},
    F15 = {0x7E,0x0},
    F16 = {0x7F,0x0},
    F17 = {0x80,0x0},
    F18 = {0x81,0x0},
    F19 = {0x82,0x0},
    F20 = {0x83,0x0},
    F21 = {0x84,0x0},
    F22 = {0x85,0x0},
    F23 = {0x86,0x0},  --delta
    F24 = {0x87,0x0},  --phi
    Enter = {0x0D,0x0},
    Esc = {0x1B,0x0},
    Space = {0x20,0x0},
    Tab = {0x09,0x0},

    Shift = {0xA1,0x0},
    LWin = {0x5B,0x0},
    Ctrl = {0xA2,0x0},
    Alt = {0x12,0x0},
    LWin = {0x5B,0x0},

    f = {0x46,0x0},
    p = {0x50,0x0},
    t = {0x54,0x0},
    z = {0x5a,0x0},


    NumpadDot = {0x6E,0x0},
    NumpadDel = {0x0,0x0},
    Numpad0 = {0x60,0x0},
    NumpadIns = {0x0,0x0},
    Numpad1 = {0x61,0x0},
    NumpadEnd = {0x0,0x0},
    Numpad2 = {0x62,0x0},
    NumpadDown = {0x0,0x0},
    Numpad3 = {0x63,0x0},
    NumpadPgDn = {0x0,0x0},
    Numpad4 = {0x64,0x0},
    NumpadLeft = {0x0,0x0},
    Numpad5 = {0x65,0x0},
    NumpadClear = {0x0,0x0},
    Numpad6 = {0x66,0x0},
    NumpadRight = {0x0,0x0},
    Numpad7 = {0x67,0x0},
    NumpadHome = {0x0,0x0},
    Numpad8 = {0x68,0x0},
    NumpadUp = {0x0,0x0},
    Numpad9 = {0x69,0x0},
    NumpadPgUp = {0x0,0x0},

    NumpadTab = {0x09,0x0},
    NumpadDiv = {0x6F,0x0},
    NumpadMult = {0x6A,0x0}, 
    NumpadBackspace = {0x08,0x0},
    NumpadSub = {0x6D,0x0},
    NumpadAdd = {0x6B,0x0},
    NumpadEnter = {0x0D,0x0},

}

numpadKeys = {
    [110] = "NumpadDot",
    [0x2e] = "NumpadDel",
    [96]  = "Numpad0",
    [0x2d] = "NumpadIns",

    [97]  = "Numpad1",
    [0x23] = "NumpadEnd",
    [98]  = "Numpad2",
    [40]  = "NumpadDown",
    [99]  = "Numpad3",
    [34]  = "NumpadPgDn",
    [100] = "Numpad4",
    [0x25] = "NumpadLeft",
    [101] = "Numpad5",
    [0x0c] = "NumpadClear",
    [102] = "Numpad6",
    [0x27] = "NumpadRight",
    [103] = "Numpad7",
    [0x24] = "NumpadHome",
    [104] = "Numpad8",
    [0x26] = "NumpadUp",
    [105] = "Numpad9",
    [0x21] = "NumpadPgUp",

    [0x09] = "NumpadTab",
    [0x6F] = "NumpadDiv",
    [0x6A] = "NumpadMult",
    [0x08] = "NumpadBackspace",

    [0x6D] = "NumpadSub",
    [0x6B] = "NumpadAdd",
    [0x0D] = "NumpadEnter",


}

left = {
    NumpadDot = kc[""],
    NumpadDel = kc[""],
    Numpad0 = kc["Del"],
    NumpadIns = kc["Del"],
    Numpad1 = kc["Enter"],
    NumpadEnd = kc["Enter"],
    Numpad2 = kc["Shift"],
    NumpadDown = kc["Shift"],
    Numpad3 = kc["Tab"],
    NumpadPgDn = kc["Tab"],
    Numpad4 = kc["F24"],
    NumpadLeft = kc["F24"],
    Numpad5 = kc["F23"],
    NumpadClear = kc["F23"],
    Numpad6 = kc["Esc"],
    NumpadRight = kc["Esc"],
    Numpad7 = kc["LWin"],
    NumpadHome = kc["LWin"],
    Numpad8 = kc[""],
    NumpadUp = kc[""],
    Numpad9 = kc[""],
    NumpadPgUp = kc[""],

    NumpadTab = {kc["Ctrl"],kc["Shift"],kc["t"]},
    NumpadDiv = {kc["Ctrl"],kc["F4"]},
    NumpadMult = {kc["Alt"],kc["F4"]}, 
    NumpadBackspace = kc[""],
    NumpadSub = kc[""],
    NumpadAdd = kc[""],
    NumpadEnter = kc["F13"],
}

right = {
    NumpadDot = kc["Backspace"],
    NumpadDel = kc["Backspace"],
    Numpad0 = kc["Enter"],
    NumpadIns = kc["Enter"],
    Numpad1 = kc[""],
    NumpadEnd = kc[""],
    Numpad2 = {kc["Ctrl"],kc["z"]},
    NumpadDown = {kc["Ctrl"],kc["z"]},
    Numpad3 = kc["Shift"],
    NumpadPgDn = kc["Shift"],
    Numpad4 = kc[""],
    NumpadLeft = kc[""],
    Numpad5 = kc[""],
    NumpadClear = kc[""],
    Numpad6 = kc["F23"],
    NumpadRight = kc["F23"],
    Numpad7 = kc[""],
    NumpadHome = kc[""],
    Numpad8 = kc[""],
    NumpadUp = kc[""],
    Numpad9 = {kc["Ctrl"], kc["p"]},
    NumpadPgUp = {kc["Ctrl"], kc["p"]},

    NumpadTab = "|isRightNumpadToggle",
    NumpadDiv = {kc["Ctrl"], kc["f"]},
    NumpadMult = kc["F3"], 
    NumpadBackspace = kc["F21"],
    NumpadSub = kc["F22"],
    NumpadAdd = kc["F24"],
    NumpadEnter = kc["F13"],
}

numpad = {
    NumpadDot = kc[""],
    NumpadDel = kc["NumpadDot"],
    Numpad0 = kc[""],
    NumpadIns = kc["Numpad0"],
    Numpad1 = kc[""],
    NumpadEnd = kc["Numpad1"],
    Numpad2 = kc[""],
    NumpadDown = kc["Numpad2"],
    Numpad3 = kc[""],
    NumpadPgDn = kc["Numpad3"],
    Numpad4 = kc[""],
    NumpadLeft = kc["Numpad4"],
    Numpad5 = kc[""],
    NumpadClear = kc["Numpad5"],
    Numpad6 = kc[""],
    NumpadRight = kc["Numpad6"],
    Numpad7 = kc[""],
    NumpadHome = kc["Numpad7"],
    Numpad8 = kc[""],
    NumpadUp = kc["Numpad8"],
    Numpad9 = kc[""],
    NumpadPgUp = kc["Numpad9"],

    NumpadTab = "|isRightNumpadToggle",
    NumpadDiv = kc["NumpadDiv"],
    NumpadMult = kc["NumpadMult"], 
    NumpadBackspace = kc["NumpadBackspace"],
    NumpadSub = kc["NumpadSub"],
    NumpadAdd = kc["NumpadAdd"],
    NumpadEnter = kc["Enter"],  

}


handleRight = function(button, direction)
    print('R  ' .. numpadKeys[button] .. '     DIR: ' .. direction .. (isRightNumpad and '   num mode' or '   macro mode'))
    if (isRightNumpad) then
        action = numpad[numpadKeys[button]]
    else
        action = right[numpadKeys[button]]
    end

    -- print(tostring(action))
    runAction(action, direction)
end

handleLeft = function(button, direction)
    print('L  ' .. numpadKeys[button] .. '     DIR: ' .. direction)
    action = left[numpadKeys[button]]
    print(tostring(action[1]))
    runAction(action, direction)
end

handleNumpad = function(button, direction)
    print('KP ID: ' .. numpadKeys[button] .. '     DIR: ' .. direction)
    action = numpad[numpadKeys[button]]
    -- print(tostring(action[1]))
    runAction(action, direction)
end

printKey = function(key, dir) 
    print('vk  ' .. string.format("%x", key[1]) .. '  -  sc  ' .. string.format("%x", key[2]) .. '  -  D: ' .. dir)
end

-- we just send the downstroke for keys, and special handlers start with "|"
runAction = function(action, direction)
    if (type(action[1]) == "table") then
        if (direction == 0) then
            i = 0
            while (i < #action) do
                i=i+1
                printKey(action[i], 1)
                lmc_send_input(action[i][1], action[i][2], 0)
            end
            while (i > 0) do
                printKey(action[i], 0)
                lmc_send_input(action[i][1], action[i][2], 2)
                i=i-1
            end
        end
    else
        if (type(action) == nil) then return end
        if (type(action) == "string") then
            if (string.sub(action, 1, 1) == '|') then
                print(action)
                if (action == "|isRightNumpadToggle" and direction == 0) then 
                    isRightNumpad = not isRightNumpad
                end
            end
        end
        if (type(action) == "table") then 
            hash = 'vk' .. action[1] .. 'sc' .. action[2]
            -- print(hash)
            if (direction == 1) then
                -- if (not pressedLog[hash]) then
                printKey(action, direction)
                lmc_send_input(action[1], 0x11C, 0)
                -- end
                -- pressedLog[hash] = true
            else 
                printKey(action, direction)                 
                lmc_send_input(action[1], action[2], 2)
                -- pressedLog[hash] = false
            end
        end
    end
end

-- define callback for whole device
lmc_set_handler('MACRO_LEFT', handleLeft)
lmc_set_handler('MACRO_RIGHT', handleRight)
lmc_set_handler('NUMPAD', handleNumpad)


-- testy things
-- print(string.sub(0xffff,1))
-- if (not nil) then print('a') end
-- print(string.sub(0x12,1))

-- for i in string.gmatch("ff,aa 00 ff", "%S+") do
--     print(i)
--     print(tonumber(i, 16))
--  end

-- split = function()
--     for i in string.gmatch(example, "%S+") do
--     print(i)
--     end
-- end


print('started')

