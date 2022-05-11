// this is taken from KeyoardForeward.ino [sic] in the teensy examples
// the ifdefs for KEYBOARD_INTERFACE have been removed for readability

// also, the teensy 4.1 is Fast, so the SHOW_KEYBOARD_DATA ifdefs have
// been modified to if statements, again, for readability

// Simple USB Keyboard Forwarder
//
// This example is in the public domain

#include "USBHost_t36.h"

#include "KeypadHelpers.h"

////////////   old version
const bool SHOW_KEYBOARD_DATA = true;

elapsedMillis sincePressedPhi,
    sincePressedDelta,
    keyPair;

int lastKeyPressed = 0;
int ROOT_K = 1;

bool isActiveScrollUp = false,
     isActiveScrollDown = false,
     phiLock = false,
     deltaLock = false;

int keyTimers[0xff];
int anyKeyTimer = 0;
int keysPressed[10];
int keysPressedLength = 0;

uint8_t keyboard_last_leds = 0;
uint8_t keyboard_modifiers = 0; // try to keep a reasonable value

uint8_t mouse1_last_buttons = 0;

USBHost myusb;
USBHub hub1(myusb);
USBHub hub2(myusb);
USBHub hub3(myusb);
USBHub hub4(myusb);
USBHub hub5(myusb);
USBHub hub6(myusb);
KeyboardController keyboard1(myusb);
KeyboardController keyboard2(myusb);
KeyboardController keyboard3(myusb);
KeyboardController keyboard4(myusb);
KeyboardController keyboard5(myusb);
KeyboardController keyboard6(myusb);
KeyboardController keyboard7(myusb);
KeyboardController keyboard8(myusb);
MouseController mouse1(myusb);
JoystickController joystick1(myusb);
USBHIDParser hid1(myusb);
USBHIDParser hid2(myusb);
RawHIDController rawhid1(myusb);
// RawHIDController rawhid2(myusb, 0xffc90004);

USBDriver *drivers[] = {&hub1, &hub2, &hub3, &hub4, &hub5, &hub6, &keyboard1, &keyboard2, &keyboard3, &keyboard4, &keyboard5, &keyboard6, &keyboard7, &keyboard8, &hid1, &hid2};
#define CNT_DEVICES (sizeof(drivers) / sizeof(drivers[0]))
const char *driver_names[CNT_DEVICES] = {"Hub1", "Hub2", "Hub3", "Hub4", "Hub5", "Hub6", "KB1", "KB2", "KB3", "KB4", "KB5", "KB6", "KB7", "KB8", "HID1", "HID2"};
bool driver_active[CNT_DEVICES] = {false, false, false, false, false, false, false, false, false, false, false, false, false, false, false};

USBHIDInput *hiddrivers[] = {&mouse1, &joystick1, &rawhid1};
#define CNT_HIDDEVICES (sizeof(hiddrivers) / sizeof(hiddrivers[0]))
const char *hid_driver_names[CNT_DEVICES] = {"Mouse1", "Joystick1", "RawHid1"};
bool hid_driver_active[CNT_DEVICES] = {false, false, false};
bool show_changed_only = false;

void setup()
{

    for (int i = 0; i < 0xff; i++)
    {
        keyTimers[i] = 0;
    }

    Serial.println("\n\nUSB Host Testing");
    Serial.println(sizeof(USBHub), DEC);

    myusb.begin();

    keyboard1.attachPress(Press1);
    keyboard1.attachRelease(Release1);
    // keyboard1.attachRawPress(RawPress1);
    // keyboard1.attachRawRelease(RawRelease1);
    // keyboard1.attachExtrasPress(OnHIDExtrasPress);
    // keyboard1.attachExtrasRelease(OnHIDExtrasRelease);

    keyboard2.attachPress(Press2);
    keyboard2.attachRelease(Release2);
    // keyboard2.attachRawPress(RawPress2);
    // keyboard2.attachRawRelease(RawRelease2);

    // keyboard3.attachPress(Press3);
    // keyboard3.attachRelease(Release3);
    // keyboard4.attachPress(Press4);
    // keyboard4.attachRelease(Release4);
    // keyboard5.attachPress(Press5);
    // keyboard5.attachRelease(Release5);
    // keyboard6.attachPress(Press6);
    // keyboard6.attachRelease(Release6);
    // keyboard7.attachPress(Press7);
    // keyboard7.attachRelease(Release7);
    // keyboard8.attachPress(Press8);
    // keyboard8.attachRelease(Release8);
}

void loop()
{
    myusb.Task();

    ShowDeviceData();
    MouseThings();
    delay(1);
}

void Press1(int key) { OnKeypadPress(key, keyboard1, 1, true); }
void Release1(int key) { OnKeypadPress(key, keyboard1, 1, false); }
void RawPress1(uint8_t key) { OnRawPress(key, keyboard1, 1, true); }
void RawRelease1(uint8_t key) { OnRawPress(key, keyboard1, 1, false); }

void Press2(int key) { OnKeypadPress(key, keyboard2, 2, true); }
void Release2(int key) { OnKeypadPress(key, keyboard2, 2, false); }
void RawPress2(uint8_t key) { OnRawPress(key, keyboard2, 2, true); }
void RawRelease2(uint8_t key) { OnRawPress(key, keyboard2, 2, false); }

// void Press3(int key) { OnKeypadPress(key, keyboard3, 3, true); }
// void Release3(int key) { OnKeypadPress(key, keyboard3, 3, false); }
// void Press4(int key) { OnKeypadPress(key, keyboard4, 4, true); }
// void Release4(int key) { OnKeypadPress(key, keyboard4, 4, false); }
// void Press5(int key) { OnKeypadPress(key, keyboard5, 5, true); }
// void Release5(int key) { OnKeypadPress(key, keyboard5, 5, false); }
// void Press6(int key) { OnKeypadPress(key, keyboard6, 6, true); }
// void Release6(int key) { OnKeypadPress(key, keyboard6, 6, false); }
// void Press7(int key) { OnKeypadPress(key, keyboard7, 7, true); }
// void Release7(int key) { OnKeypadPress(key, keyboard7, 7, false); }
// void Press8(int key) { OnKeypadPress(key, keyboard8, 8, true); }
// void Release8(int key) { OnKeypadPress(key, keyboard8, 8, false); }

void downup(int key, bool down)
{
    // Serial.print("Out ");
    // Serial.print(down ? "__ 0x" : "^^ 0x");
    // Serial.print(key, HEX);
    // Serial.println();

    // if (key == KEY_PHI)
    // {
    //     if (down)
    //     {
    //         sincePressedPhi = 0;
    //     }
    //     else
    //     {
    //         if (sincePressedPhi < 120)
    //         {
    //             if (!phiLock)
    //             {
    //                 phiLock = true;
    //                 return;
    //             }
    //         }
    //         phiLock = false;
    //     }
    // }

    // if (down)
    // {
    //     // Serial.print(sincePressed);
    //     // sincePressed = 0;
    //     Keyboard.press(key);
    // }
    // else
    // {
    //     // delay(5);
    //     Keyboard.release(key);
    // }
}

void downup(int key1, int key2, bool down)
{
    if (down)
    {
        downup(key1, down);
        delay(2);
        downup(key2, down);
    }
    else
    {
        delay(2);
        downup(key2, down);
        delay(2);
        downup(key1, down);
    }
}

void downup(int key1, int key2, int key3, bool down)
{
    if (down)
    {
        downup(key1, down);
        delay(2);
        downup(key2, down);
        delay(2);
        downup(key3, down);
    }
    else
    {
        delay(2);
        downup(key3, down);
        delay(2);
        downup(key2, down);
        delay(2);
        downup(key1, down);
    }
}

void noop() {}

void logKeyPress(int key, KeyboardController kb, int kbNum, bool down, int keyTime, int anyKeyTime)
{
    Serial.print("k");
    Serial.print(kbNum);
    Serial.print(down ? "__" : "^^");
    Serial.printf(" %8i", keyTime);
    Serial.print(down ? "" : "     ");
    Serial.printf("  0x%02X ", key);
    Serial.print(down ? "     " : "");
    if (!(down && keysPressedLength == 1))
    {
        Serial.printf(" %8i", anyKeyTime);
    }
    else
    {
        Serial.printf("         ");
    }
    Serial.printf(" nL: %i", kb.numLock());
    // Serial.print("   Mods: ");
    // Serial.print(kb.getModifiers(), HEX);
    // Serial.print(" OEM: ");
    // Serial.print(kb.getOemKey(), HEX);
    // Serial.print(" LEDS: ");
    // Serial.print(kb.LEDS(), HEX);
    // Serial.print(" ");
    // Serial.print(KeypadShowNames(key));
    Serial.println();
}

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////  key press

int k = 0;
int d = 0;
int now = 0;
int keyTime = 0;
int anyKeyTime = 0;

void OnKeypadPress(int key, KeyboardController kb, int kbNum, bool down)
{
    if (kb.getOemKey() == 0x53)
        return;

    k = key;
    d = down;
    now = millis();
    keyTime = now - keyTimers[key];
    anyKeyTime = now - anyKeyTimer;

    keyTimers[key] = now;
    anyKeyTimer = now;

    if (keyTime < 2)
        keyTime = 2;

    if (anyKeyTime < 2)
        anyKeyTime = 2;

    if (d)
    {
        keysPressedLength++;
        keysPressed[keysPressedLength] = key;
    }
    else
    {
        keysPressedLength--;
    }

    logKeyPress(key, kb, kbNum, down, keyTime, anyKeyTime);

    if (kbNum == ROOT_K) // LEFT

    {
        k == nTab         ? downup(KEY_T, d)
        : k == nDiv       ? downup(KEY_G, d)
        : k == nMult      ? downup(KEY_B, d)
        : k == nBackspace ? downup(KEY_, d)

        : k == n7   ? downup(KEY_R, d)
        : k == n8   ? downup(KEY_F, d)
        : k == n9   ? downup(KEY_V, d)
        : k == nSub ? downup(KEY_, d)

        : k == n4   ? downup(KEY_E, d)
        : k == n5   ? downup(KEY_D, d)
        : k == n6   ? downup(KEY_C, d)
        : k == nAdd ? downup(KEY_, d)

        : k == n1 ? downup(KEY_W, d)
        : k == n2 ? downup(KEY_S, d)
        : k == n3 ? downup(KEY_X, d)

        : k == n0     ? downup(KEY_Q, d)
        : k == nDot   ? downup(KEY_A, d)
        : k == nEnter ? downup(KEY_Z, d)

                      : void(0);
    }
    else if (kbNum == ROOT_K + 1) // RIGHT

    {
        k == nTab         ? downup(KEY_, d)
        : k == nDiv       ? downup(KEY_N, d)
        : k == nMult      ? downup(KEY_H, d)
        : k == nBackspace ? downup(KEY_Y, d)

        : k == n7   ? downup(KEY_, d)
        : k == n8   ? downup(KEY_M, d)
        : k == n9   ? downup(KEY_J, d)
        : k == nSub ? downup(KEY_U, d)

        : k == n4   ? downup(KEY_, d)
        : k == n5   ? downup(KEY_COMMA, d)
        : k == n6   ? downup(KEY_K, d)
        : k == nAdd ? downup(KEY_I, d)

        : k == n1     ? downup(KEY_, d)
        : k == n2     ? downup(KEY_PERIOD, d)
        : k == n3     ? downup(KEY_L, d)
        : k == nEnter ? downup(KEY_O, d)

        : k == n0   ? downup(KEY_, d)
        : k == nDot ? downup(KEY_P, d)

                    : void(0);
    }

    // PRINT WHAT'S HAPPENING
}

void ShowMouseData()
{
    Serial.print("Mouse: buttons = ");
    Serial.print(mouse1.getButtons());
    Serial.print(",  mouseX = ");
    Serial.print(mouse1.getMouseX());
    Serial.print(",  mouseY = ");
    Serial.print(mouse1.getMouseY());
    Serial.print(",  wheel = ");
    Serial.print(mouse1.getWheel());
    Serial.print(",  wheelH = ");
    Serial.print(mouse1.getWheelH());
    Serial.println();
}

void pr(const char *data)
{
    Serial.print(data);
}

void MouseThings()
{
    if (mouse1.available())
    {
        ShowMouseData();
        uint8_t mouse_buttons = mouse1.getButtons();
        uint8_t mb = mouse_buttons;
        uint8_t lmb = mouse1_last_buttons;
        Serial.print(mouse_buttons + " " + mouse1_last_buttons);
        // Serial.print(mouse_buttons | mouse1_last_buttons);
        Serial.println();
        ((mb & 0b1) > (lmb & 0b1))         ? pr("1 down")
        : ((mb & 0b1) < (lmb & 0b1))       ? pr("1 up")
        : ((mb & 0b10) > (lmb & 0b10))     ? pr("2 down")
        : ((mb & 0b10) < (lmb & 0b10))     ? pr("2 up")
        : ((mb & 0b100) > (lmb & 0b100))   ? pr("3 down")
        : ((mb & 0b100) < (lmb & 0b100))   ? pr("3 up")
        : ((mb & 0b1000) > (lmb & 0b1000)) ? pr("4 down")
        : ((mb & 0b1000) < (lmb & 0b1000)) ? pr("4 up")
                                           : noop();

        if (mouse_buttons > mouse1_last_buttons)
            Mouse.press();
        if (mouse_buttons < mouse1_last_buttons)
            Mouse.release();
        // front to the back
        // Mouse.move(-mouse1.getMouseX(), -mouse1.getMouseY(), mouse1.getWheel());
        // front to the left
        Mouse.move(-mouse1.getMouseY(), mouse1.getMouseX(), mouse1.getWheel());
        mouse1_last_buttons = mouse_buttons;
        mouse1.mouseDataClear();
    }
}

void ShowDeviceData()
{
    for (uint8_t i = 0; i < CNT_DEVICES; i++)
    {
        if (*drivers[i] != driver_active[i])
        {
            if (driver_active[i])
            {
                Serial.printf("*** Device %s - disconnected ***\n", driver_names[i]);
                driver_active[i] = false;
            }
            else
            {
                Serial.printf("*** Device %s %x:%x - connected ***\n", driver_names[i], drivers[i]->idVendor(), drivers[i]->idProduct());
                driver_active[i] = true;

                const uint8_t *psz = drivers[i]->manufacturer();
                if (psz && *psz)
                    Serial.printf("  manufacturer: %s\n", psz);
                psz = drivers[i]->product();
                if (psz && *psz)
                    Serial.printf("  product: %s\n", psz);
                psz = drivers[i]->serialNumber();
                if (psz && *psz)
                    Serial.printf("  Serial: %s\n                                                                               ", psz);
            }
        }
    }
}

void OnRawPress(uint8_t keycode, KeyboardController kb, int kbNum, bool down)
{

    Serial.print(keycode);

    Serial.print("Raw1 ");
    Serial.print(down ? "d" : "u    ");
    Serial.print(" 0x");
    Serial.print(keycode, HEX);
    // Serial.print(" Mods: ");
    // Serial.println(keyboard_modifiers, HEX);
    Serial.println();
    // if (keyboard_leds != keyboard_last_leds)
    // {
    //     // Serial.printf("New LEDS: %x\n", keyboard_leds);
    //     keyboard_last_leds = keyboard_leds;
    //     keyboard1.LEDS(keyboard_leds);
    // }
    // int out =
    //     keycode == 103         ? KEY_LEFT_CTRL
    //     : keycode == 104       ? KEY_LEFT_SHIFT
    //     : keycode == 105       ? KEY_LEFT_ALT
    //     : keycode == 106       ? KEY_LEFT_GUI
    //     : keycode == 107       ? KEY_RIGHT_CTRL
    //     : keycode == 108       ? KEY_RIGHT_SHIFT
    //     : keycode == 109       ? KEY_RIGHT_ALT
    //     : keycode == 110       ? KEY_RIGHT_GUI
    //     : keycode == RAW_SPACE ? KEY_LEFT_SHIFT
    //     // : keycode == RAW_K     ? KEY_B
    //     // : keycode == RAW_CAPS  ? KEY_K
    //     : keycode == 0x33 ? KEY_B

    //     : keycode == 0x2E ? KEY_F17
    //     : keycode == 0x2A ? KEY_F21
    //     : keycode == 0x4A ? KEY_F20

    //     : keycode == 0x30 ? KEY_F18
    //     : keycode == 0x31 ? KEY_F22
    //     : keycode == 0x4D ? KEY_F19

    //     : keycode == 0x4B ? KEY_F14
    //     : keycode == 0x4E ? KEY_F15
    //                       : 0;
    // // todo: use rawsend
    // if (out == 0)
    // {
    //     Serial.print("out ");
    //     ShowOutPress(keycode, keyboard1);
    //     down ? Keyboard.press(0xF000 | keycode)
    //          : Keyboard.release(0xF000 | keycode);
    // }
    // else
    // {
    //     Serial.print(keycode);
    //     downup(out, down);
    // }
}

// void RawSend()
// {
// }

// void OnHIDExtrasPress(uint32_t top, uint16_t key)
// {

//     if (top == 0xc0000)
//     {
//         Keyboard.press(0XE400 | key);
//     }

//     if (SHOW_KEYBOARD_DATA)
//     {
//         ShowHIDExtrasPress(top, key);
//     }
// }

// void OnHIDExtrasRelease(uint32_t top, uint16_t key)
// {

//     if (top == 0xc0000)
//     {
//         Keyboard.release(0XE400 | key);
//     }

//     if (SHOW_KEYBOARD_DATA)
//     {

//         Serial.print("HID (");
//         Serial.print(top, HEX);
//         Serial.print(") key release:");
//         Serial.println(key, HEX);
//     }
// }
