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

elapsedMillis sincePressed;
int lastKeyPressed = 0;
int rootK = 0;

bool isActiveScrollUp = false,
     isActiveScrollDown = false;

uint8_t keyboard_last_leds = 0;
uint8_t keyboard_modifiers = 0; // try to keep a reasonable value

const int NA = 0x1B;

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
USBHIDParser hid1(myusb);
USBHIDParser hid2(myusb);

USBDriver *drivers[] = {&hub1, &hub2, &hub3, &hub4, &hub5, &hub6, &keyboard1, &keyboard2, &keyboard3, &keyboard4, &keyboard5, &keyboard6, &keyboard7, &keyboard8, &hid1, &hid2};
#define CNT_DEVICES (sizeof(drivers) / sizeof(drivers[0]))
const char *driver_names[CNT_DEVICES] = {"Hub1", "Hub2", "Hub3", "Hub4", "Hub5", "Hub6", "KB1", "KB2", "KB3", "KB4", "KB5", "KB6", "KB7", "KB8", "HID1", "HID2"};
bool driver_active[CNT_DEVICES] = {false, false, false, false, false, false, false, false, false, false, false, false, false, false, false};

void setup()
{

    Serial.println("\n\nUSB Host Testing");
    Serial.println(sizeof(USBHub), DEC);

    myusb.begin();
    keyboard1.attachPress(ShowOnPress);
    // keyboard1.attachPress(Press1);
    // keyboard1.attachRelease(Release1);

    keyboard1.attachRawPress(RawPress1);
    keyboard1.attachRawRelease(RawRelease1);
    //     keyboard1.attachRawPress(OnRawPress);
    //     keyboard1.attachRawRelease(OnRawRelease);

    keyboard1.attachExtrasPress(OnHIDExtrasPress);
    keyboard1.attachExtrasRelease(OnHIDExtrasRelease);

    keyboard2.attachPress(Press2);
    keyboard2.attachRelease(Release2);
    keyboard3.attachPress(Press3);
    keyboard3.attachRelease(Release3);
    keyboard4.attachPress(Press4);
    keyboard4.attachRelease(Release4);
    keyboard5.attachPress(Press5);
    keyboard5.attachRelease(Release5);
    keyboard6.attachPress(Press6);
    keyboard6.attachRelease(Release6);
    keyboard7.attachPress(Press7);
    keyboard7.attachRelease(Release7);
    keyboard8.attachPress(Press8);
    keyboard8.attachRelease(Release8);
}

void Press1(int key) { OnPress(key, keyboard1, 1, true); }
void Release1(int key) { OnPress(key, keyboard1, 1, false); }
void RawPress1(uint8_t key) { OnRawPress(key, keyboard1, 1, true); }
void RawRelease1(uint8_t key) { OnRawPress(key, keyboard1, 1, false); }
void Press2(int key) { OnPress(key, keyboard2, 2, true); }
void Release2(int key) { OnPress(key, keyboard2, 2, false); }
void Press3(int key) { OnPress(key, keyboard3, 3, true); }
void Release3(int key) { OnPress(key, keyboard3, 3, false); }
void Press4(int key) { OnPress(key, keyboard4, 4, true); }
void Release4(int key) { OnPress(key, keyboard4, 4, false); }
void Press5(int key) { OnPress(key, keyboard5, 5, true); }
void Release5(int key) { OnPress(key, keyboard5, 5, false); }
void Press6(int key) { OnPress(key, keyboard6, 6, true); }
void Release6(int key) { OnPress(key, keyboard6, 6, false); }
void Press7(int key) { OnPress(key, keyboard7, 7, true); }
void Release7(int key) { OnPress(key, keyboard7, 7, false); }
void Press8(int key) { OnPress(key, keyboard8, 8, true); }
void Release8(int key) { OnPress(key, keyboard8, 8, false); }

void downup(int key, bool down)
{
    if (down)
    {
        // Serial.print(sincePressed);
        // sincePressed = 0;
        Keyboard.press(key);
    }
    else
    {
        // delay(5);
        Keyboard.release(key);
    }
}

void downup(int key1, int key2, bool down)
{
    if (down)
    {
        Keyboard.press(key1);
        delay(2);
        Keyboard.press(key2);
    }
    else
    {
        delay(2);
        Keyboard.release(key2);
        delay(2);
        Keyboard.release(key1);
    }
}

void downup(int key1, int key2, int key3, bool down)
{
    if (down)
    {
        Keyboard.press(key1);
        delay(2);
        Keyboard.press(key2);
        delay(2);
        Keyboard.press(key3);
    }
    else
    {
        delay(2);
        Keyboard.release(key3);
        delay(2);
        Keyboard.release(key2);
        delay(2);
        Keyboard.release(key1);
    }
}

void noop() {}

int AHK_LEFT_SHIFT = KEY_LEFT_ALT,
    AHK_LEFT_ALT = KEY_LEFT_SHIFT,
    AHK_B = KEY_CAPS_LOCK,
    AHK_SPACE = KEY_F13;

void OnRawPress(uint8_t key, KeyboardController kb, int kbNum, bool down)
{
    int d = down;

    Serial.print("0x");
    Serial.print(key, HEX);
    Serial.println(down ? "  pressed" : "  released");

    if (kbNum == 1)
    {
        key == RAW_LEFT_CTRL     ? downup(MODIFIERKEY_CTRL, d)
        : key == RAW_LEFT_SHIFT  ? downup(MODIFIERKEY_SHIFT, d)
        : key == RAW_LEFT_ALT    ? downup(MODIFIERKEY_ALT, d)
        : key == RAW_LEFT_GUI    ? downup(MODIFIERKEY_GUI, d)
        : key == RAW_RIGHT_CTRL  ? downup(MODIFIERKEY_RIGHT_CTRL, d)
        : key == RAW_RIGHT_SHIFT ? downup(MODIFIERKEY_RIGHT_SHIFT, d)
        : key == RAW_RIGHT_ALT   ? downup(MODIFIERKEY_RIGHT_ALT, d)

                               : void(0);
    }
}

void OnPress(int key, KeyboardController kb, int kbNum, bool down)
{
    int k = key;
    int d = down;

    if (kbNum == rootK)
    {
        downup(key, down);
    }
    else if (kbNum == rootK + 1) // LEFT

    {
        k == nTab         ? downup(KEY_LEFT_CTRL, KEY_T, d)
        : k == nDiv       ? downup(KEY_LEFT_CTRL, KEY_F4, d)
        : k == nMult      ? downup(KEY_LEFT_CTRL, AHK_LEFT_SHIFT, AHK_B, d)
        : k == nBackspace ? downup(AHK_LEFT_ALT, KEY_F4, d)

        : k == n7   ? downup(KEY_LEFT_GUI, d)
        : k == n8   ? noop()
        : k == n9   ? noop()
        : k == nSub ? noop()

        : k == n4   ? downup(KEY_F24, d)
        : k == n5   ? downup(KEY_F23, d)
        : k == n6   ? downup(KEY_ESC, d)
        : k == nAdd ? noop()

        : k == n1     ? downup(KEY_ENTER, d)
        : k == n2     ? downup(KEY_DELETE, d)
        : k == n3     ? downup(KEY_TAB, d)
        : k == nEnter ? downup(AHK_SPACE, d)

        : k == n0   ? downup(KEY_LEFT_CTRL, d)
        : k == nDot ? noop()

                    : void(0);
    }
    else if (kbNum == rootK + 2) // RIGHT

    {
        k == nTab         ? noop()
        : k == nDiv       ? downup(KEY_LEFT_CTRL, KEY_F, d)
        : k == nMult      ? downup(KEY_F3, d)
        : k == nBackspace ? downup(KEY_F21, d)

        : k == n7   ? noop()
        : k == n9   ? downup(KEY_LEFT_CTRL, KEY_P, d)
        : k == n8   ? noop()
        : k == nSub ? downup(KEY_F22, d)

        : k == n4   ? noop()
        : k == n5   ? noop()
        : k == n6   ? downup(KEY_F23, d)
        : k == nAdd ? downup(KEY_F24, d)

        : k == n1     ? noop()
        : k == n2     ? downup(KEY_LEFT_CTRL, KEY_Z, d)
        : k == n3     ? downup(KEY_BACKSPACE, d)
        : k == nEnter ? downup(AHK_SPACE, d)

        : k == n0   ? downup(KEY_ENTER, d)
        : k == nDot ? downup(KEY_LEFT_CTRL, d)

                    : void(0);
    }
    else if (kbNum == rootK + 2) // RIGHT
    {
        k == nTab         ? noop()
        : k == nDiv       ? downup(KEY_LEFT_CTRL, KEY_F, d)
        : k == nMult      ? downup(KEY_F3, d)
        : k == nBackspace ? downup(KEY_F21, d)

        : k == n7   ? noop()
        : k == n9   ? downup(KEY_LEFT_CTRL, KEY_P, d)
        : k == n8   ? noop()
        : k == nSub ? downup(KEY_F22, d)

        : k == n4   ? noop()
        : k == n5   ? noop()
        : k == n6   ? downup(KEY_F23, d)
        : k == nAdd ? downup(KEY_F24, d)

        : k == n1     ? noop()
        : k == n2     ? downup(KEY_LEFT_CTRL, KEY_Z, d)
        : k == n3     ? downup(KEY_BACKSPACE, d)
        : k == nEnter ? downup(AHK_SPACE, d)

        : k == n0   ? downup(KEY_ENTER, d)
        : k == nDot ? downup(KEY_LEFT_CTRL, d)

                    : void(0);
    }
    else
    {
        downup(key, down);
    }

    // PRINT WHAT'S HAPPENING

    Serial.print("kb");
    Serial.print(kbNum);
    Serial.print(" - ");
    Serial.print(KeypadShowNames(key));
    Serial.print("  ");
    Serial.print(key, HEX);
    Serial.print("  ");
    Serial.print(down ? "down" : "up");
    Serial.print("   MOD: ");
    Serial.print(kb.getModifiers(), HEX);
    Serial.print(" OEM: ");
    Serial.print(kb.getOemKey(), HEX);
    Serial.print(" LEDS: ");
    Serial.println(kb.LEDS(), HEX);
}

void OnHIDExtrasPress(uint32_t top, uint16_t key)
{

    if (top == 0xc0000)
    {
        Keyboard.press(0XE400 | key);
    }

    if (SHOW_KEYBOARD_DATA)
    {
        ShowHIDExtrasPress(top, key);
    }
}

void OnHIDExtrasRelease(uint32_t top, uint16_t key)
{

    if (top == 0xc0000)
    {
        Keyboard.release(0XE400 | key);
    }

    if (SHOW_KEYBOARD_DATA)
    {

        Serial.print("HID (");
        Serial.print(top, HEX);
        Serial.print(") key release:");
        Serial.println(key, HEX);
    }
}

void loop()
{
    myusb.Task();

    ShowDeviceData();
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
                    Serial.printf("  Serial: %s\n", psz);
            }
        }
    }
}

void OnRawPress(uint8_t keycode)
{

    if (keyboard_leds != keyboard_last_leds)
    {
        // Serial.printf("New LEDS: %x\n", keyboard_leds);
        keyboard_last_leds = keyboard_leds;
        keyboard1.LEDS(keyboard_leds);
    }

    if (keycode >= 103 && keycode < 111)
    {
        // one of the modifier keys was pressed, so lets turn it
        // on global..
        uint8_t keybit = 1 << (keycode - 103);
        keyboard_modifiers |= keybit;
        Keyboard.set_modifier(keyboard_modifiers);
    }
    else
    {
        if (keyboard1.getModifiers() != keyboard_modifiers)
        {
            if (SHOW_KEYBOARD_DATA)
            {

                Serial.printf("Mods mismatch: %x != %x\n", keyboard_modifiers, keyboard1.getModifiers());
            }
            keyboard_modifiers = keyboard1.getModifiers();
            Keyboard.set_modifier(keyboard_modifiers);
        }
        Keyboard.press(0XF000 | keycode);
    }

    if (SHOW_KEYBOARD_DATA)
    {

        Serial.print("OnRawPress keycode: ");
        Serial.print(keycode, HEX);
        Serial.print(" Modifiers: ");
        Serial.println(keyboard_modifiers, HEX);
    }
}

void OnRawRelease(uint8_t keycode)
{

    if (keycode >= 103 && keycode < 111)
    {
        // one of the modifier keys was pressed, so lets turn it
        // on global..
        uint8_t keybit = 1 << (keycode - 103);
        keyboard_modifiers &= ~keybit;
        Keyboard.set_modifier(keyboard_modifiers);
    }
    else
    {
        Keyboard.release(0XF000 | keycode);
    }

    if (SHOW_KEYBOARD_DATA)
    {

        Serial.print("OnRawRelease keycode: ");
        Serial.print(keycode, HEX);
        Serial.print(" Modifiers: ");
        Serial.println(keyboard1.getModifiers(), HEX);
    }
}
