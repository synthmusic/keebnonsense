# keebnonsense

Some scripts for multiple keyboards working together in harmony.
AutoHotKey, arduino (well, teensy), as well as some luamacros code - now no longer in use because of the teensy

keypads:  2 numeric keypads
keyboard:  kinesis freestyle 2 + companion numeric keypad
teensy 4.1 w/ input usb hub


arrangement

     keypad    keypad    
       | usb     | usb
    /--|----|----|----|--  usb hub
    | usb  
Teensy 4.1  keyboard   numpad
    | usb     |          |
 /--|----|----|----------|-- usb hub
 | usb
Computer
