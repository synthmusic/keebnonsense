// this is taken from KeyoardForeward.ino [sic] in the teensy examples
// the ifdefs for KEYBOARD_INTERFACE have been removed for readability

#include "USBHost_t36.h"
#include "KeypadHelpers.h"

const int ROOT_K = 1;

bool isActiveScrollUp = false,
     isActiveScrollDown = false;

uint8_t keyboard_last_leds = 0;
uint8_t keyboard_modifiers = 0; // try to keep a reasonable value

uint8_t mouse1_last_buttons = 0;

int layer = KEY_ALPHA;

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
    Serial.println("\n\nUSB Host Testing");
    Serial.println(sizeof(USBHub), DEC);

    myusb.begin();

    // keyboard1.attachPress(Press1);
    // keyboard1.attachRelease(Release1);
    keyboard1.attachRawPress(RawPress1);
    keyboard1.attachRawRelease(RawRelease1);
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

    addSimpleInstance();
}

// void ShowPress1(int key) { ShowOnPress(key, keyboard1); }
// void Press1(int key) { OOnKeypadPressnKeypadPress(key, keyboard1, 1, true); }
// void Release1(int key) { OnKeypadPress(key, keyboard1, 1, false); }
void RawPress1(uint8_t key) { OnRawPress(key, keyboard1, 1, true); }
void RawRelease1(uint8_t key) { OnRawPress(key, keyboard1, 1, false); }

void Press2(int key) { OnKeypadPress(key, keyboard2, 2, true); }
void Release2(int key) { OnKeypadPress(key, keyboard2, 2, false); }
void Press3(int key) { OnKeypadPress(key, keyboard3, 3, true); }
void Release3(int key) { OnKeypadPress(key, keyboard3, 3, false); }
void Press4(int key) { OnKeypadPress(key, keyboard4, 4, true); }
void Release4(int key) { OnKeypadPress(key, keyboard4, 4, false); }
void Press5(int key) { OnKeypadPress(key, keyboard5, 5, true); }
void Release5(int key) { OnKeypadPress(key, keyboard5, 5, false); }
void Press6(int key) { OnKeypadPress(key, keyboard6, 6, true); }
void Release6(int key) { OnKeypadPress(key, keyboard6, 6, false); }
void Press7(int key) { OnKeypadPress(key, keyboard7, 7, true); }
void Release7(int key) { OnKeypadPress(key, keyboard7, 7, false); }
void Press8(int key) { OnKeypadPress(key, keyboard8, 8, true); }
void Release8(int key) { OnKeypadPress(key, keyboard8, 8, false); }

void downup(bool down) {}

void downup(int key, bool down)
{
    // Serial.print(down ? "out down 0x" : "up 0x");
    // Serial.println(key, HEX);

    if (down)
    {
        if (key == KEY_DELTA)
        {
            layer = KEY_DELTA;
            downup(AHK_DELTA, true);
            downup(AHK_DELTA, false);
            // delay(5);
            // downup(KEY_LEFT_SHIFT, true);
            // downup(KEY_LEFT_SHIFT, false);
        }
        else if (key == KEY_PHI)
        {
            layer = KEY_PHI;
            downup(AHK_PHI, true);
            downup(AHK_PHI, false);
            // delay(5);

            // downup(KEY_LEFT_SHIFT, true);
            // downup(KEY_LEFT_SHIFT, false);
        }
        else if (key == KEY_ALPHA)
        {
            layer = KEY_ALPHA;
            downup(AHK_ALPHA, true);
            downup(AHK_ALPHA, false);
            // delay(5);

            // downup(KEY_LEFT_SHIFT, true);
            // downup(KEY_LEFT_SHIFT, false);
        }
        // Serial.print(sincePressed);
        // sincePressed = 0;
        Keyboard.press(key);
    }
    else
    {
        Keyboard.release(key);
    }
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

int k = 0;
int d = 0;

void OnKeypadPress(int key, KeyboardController kb, int kbNum, bool down)
{
    KeyStateChange(key, kbNum, down);
    k = key;
    d = down;

    if (kbNum == ROOT_K)
    {
    }
    else if (kbNum == ROOT_K + 1) // LEFT
    {
        k == nTab         ? downup(KEY_LEFT_GUI, d)
        : k == nDiv       ? downup(KEY_LEFT_CTRL, KEY_T, d)
        : k == nMult      ? downup(KEY_LEFT_CTRL, KEY_F4, d)
        : k == nBackspace ? downup(KEY_LEFT_ALT, KEY_F4, d)

        : k == n7   ? downup(KEY_DELTA, d)
        : k == n8   ? downup(KEY_DELTA, d)
        : k == n9   ? downup(d)
        : k == nSub ? downup(d)

        : k == n4   ? downup(KEY_ENTER, d)
        : k == n5   ? downup(KEY_ESC, d)
        : k == n6   ? downup(KEY_ALPHA, d)
        : k == nAdd ? downup(KEY_SPACE, d)

        : k == n1     ? downup(KEY_TAB, d)
        : k == n2     ? downup(KEY_RIGHT_CTRL, d)
        : k == n3     ? downup(KEY_ENTER, d)
        : k == nEnter ? downup(KEY_LEFT_ALT, d)

        : k == n0   ? downup(KEY_DELETE, d)
        : k == nDot ? downup(d)

                    : void(0);
    }
    else if (kbNum == ROOT_K + 2) // RIGHT

    {
        k == nTab         ? downup(d)
        : k == nDiv       ? downup(d)
        : k == nMult      ? downup(d)
        : k == nBackspace ? downup(KEY_BACKSPACE, d)

        : k == n7   ? downup(d)
        : k == n8   ? downup(d)
        : k == n9   ? downup(KEY_ALPHA, d)
        : k == nSub ? downup(KEY_ALPHA, d)

        : k == n4   ? downup(d)
        : k == n5   ? downup(KEY_PHI, d)
        : k == n6   ? downup(KEY_BACKSPACE, d)
        : k == nAdd ? downup(KEY_SPACE, d)

        : k == n1     ? downup(KEY_LEFT_GUI, KEY_L, d)
        : k == n2     ? downup(d)
        : k == n3     ? downup(KEY_LEFT_CTRL, d)
        : k == nEnter ? downup(KEY_LEFT_CTRL, KEY_Z, d)

        : k == n0   ? downup(KEY_LEFT_ALT, d)
        : k == nDot ? downup(d)

                    : void(0);
    }
    else
    {
        k == n3   ? downup(0x5B, d)
        : k == n7 ? downup(0x5F, d)

                  : downup(key, down);
    }

    // PRINT WHAT'S HAPPENING

    // Serial.print("IN kb");
    // Serial.print(kbNum);
    // Serial.print(" - ");
    // Serial.print(KeypadShowNames(key));
    // Serial.print("  ");
    // Serial.print(key, HEX);
    // Serial.print("  ");
    // Serial.print(down ? "down" : "up");
    // Serial.print("   MOD: ");
    // Serial.print(kb.getModifiers(), HEX);
    // Serial.print(" OEM: ");
    // Serial.print(kb.getOemKey(), HEX);
    // Serial.print(" LEDS: ");
    // Serial.println(kb.LEDS(), HEX);
}

void OnRawPress(uint8_t keycode, KeyboardController kb, int kbNum, bool down)
{
    int key = (0xF000 | keycode);
    KeyStateChange(keycode, kbNum, down);
    Serial.print("RAW IN raw1 0x");
    Serial.print(keycode, HEX);
    Serial.print(" Modifiers: ");
    Serial.println(keyboard_modifiers, HEX);
    if (keyboard_leds != keyboard_last_leds)
    {
        // Serial.printf("New LEDS: %x\n", keyboard_leds);
        keyboard_last_leds = keyboard_leds;
        keyboard1.LEDS(keyboard_leds);
    }

    int out =
        keycode == 103         ? KEY_LEFT_CTRL
        : keycode == 104       ? KEY_LEFT_SHIFT
        : keycode == 105       ? KEY_LEFT_ALT
        : keycode == 106       ? KEY_LEFT_GUI
        : keycode == 107       ? KEY_RIGHT_CTRL
        : keycode == 108       ? KEY_RIGHT_SHIFT
        : keycode == 109       ? KEY_RIGHT_ALT
        : keycode == 110       ? KEY_RIGHT_GUI
        : keycode == RAW_SPACE ? KEY_LEFT_SHIFT
        : keycode == 0x33      ? KEY_B

        : keycode == 0x4B ? KEY_F20
        : keycode == 0x4E ? KEY_F21
                          : 0;

    if (out == 0)
    {
        // Serial.print("out ");
        // ShowOutPress(keycode, keyboard1);
        out = (0xF000 | keycode);
    }

    // Serial.printf("%x, %x, %x, %x, ", layer, KEY_DELTA, keycode, key);
    // Serial.println();
    if (layer == KEY_DELTA)
    {
        // Serial.printf("%x, %x, %x, %x, ", KEY_Q & 0xFF, KEY_Q, keycode, key);
        // Serial.println();

        // qwert
        key == KEY_Q   ? downup(KEY_LEFT_SHIFT, KEY_TILDE, down)
        : key == KEY_W ? downup(KEY_HOME, down)
        : key == KEY_E ? downup(KEY_UP_ARROW, down)
        : key == KEY_R ? downup(KEY_END, down)
        : key == KEY_T ? downup(KEY_LEFT_SHIFT, KEY_EQUAL, down)
        // asdfg

        : key == KEY_A ? downup(KEY_TILDE, down)
        : key == KEY_S ? downup(KEY_LEFT_ARROW, down)
        : key == KEY_D ? downup(KEY_DOWN_ARROW, down)
        : key == KEY_F ? downup(KEY_RIGHT_ARROW, down)
        : key == KEY_G ? downup(KEY_MINUS, down)

        // zxcv
        : key == KEY_Z ? downup(KEY_BACKSLASH, down)
        // : key == KEY_X ? downup(KEY_, down)
        : key == KEY_C ? downup(KEY_RIGHT_BRACE, down)
        : key == KEY_V ? downup(KEY_LEFT_BRACE, down)

        // yuiop
        // : key == KEY_Y ? downup(KEY_TILDE, down)
        : key == KEY_U ? downup(KEY_LEFT_SHIFT, KEY_COMMA, down)
        : key == KEY_I ? downup(KEY_LEFT_SHIFT, KEY_LEFT_BRACE, down)
        : key == KEY_O ? downup(KEY_LEFT_SHIFT, KEY_RIGHT_BRACE, down)
        : key == KEY_P ? downup(KEY_LEFT_SHIFT, KEY_BACKSLASH, down)

        // hjkl;
        : key == KEY_H         ? downup(KEY_LEFT_SHIFT, KEY_QUOTE, down)
        : key == KEY_J         ? downup(KEY_EQUAL, down)
        : key == KEY_K         ? downup(KEY_SEMICOLON, down)
        : key == KEY_L         ? downup(KEY_LEFT_SHIFT, KEY_SEMICOLON, down)
        : key == KEY_SEMICOLON ? downup(KEY_LEFT_SHIFT, KEY_SLASH, down)

        // nm
        : key == KEY_N ? downup(KEY_QUOTE, down)
        : key == KEY_M ? downup(KEY_LEFT_SHIFT, KEY_PERIOD, down)

        : key == KEY_1     ? downup(KEY_LEFT_SHIFT, KEY_1, down)
        : key == KEY_2     ? downup(KEY_LEFT_SHIFT, KEY_2, down)
        : key == KEY_3     ? downup(KEY_LEFT_SHIFT, KEY_3, down)
        : key == KEY_4     ? downup(KEY_LEFT_SHIFT, KEY_4, down)
        : key == KEY_5     ? downup(KEY_LEFT_SHIFT, KEY_5, down)
        : key == KEY_6     ? downup(KEY_LEFT_SHIFT, KEY_6, down)
        : key == KEY_7     ? downup(KEY_LEFT_SHIFT, KEY_7, down)
        : key == KEY_8     ? downup(KEY_LEFT_SHIFT, KEY_8, down)
        : key == KEY_9     ? downup(KEY_LEFT_SHIFT, KEY_9, down)
        : key == KEY_0     ? downup(KEY_LEFT_SHIFT, KEY_0, down)
        : key == KEY_MINUS ? downup(KEY_LEFT_SHIFT, KEY_MINUS, down)
        : key == KEY_EQUAL ? downup(KEY_LEFT_SHIFT, KEY_EQUAL, down)

                           : downup(out, down);
    }
    else if (layer == KEY_PHI)
    {
        downup(out, down);
    }
    else
    {
        downup(out, down);
    }

    // Serial.print("out ");
    // ShowOutPress(keycode, keyboard1);
    // Serial.printf("%x, %x, %x, %x, ", KEY_M & 0xFF, KEY_M, keycode, key);
    // Serial.println();
}

void RawSend()
{
}

void loop()
{
    myusb.Task();

    ShowDeviceData();
    MouseThings();
    KeyThings();
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
                                           : void(0);

        if (mouse_buttons > mouse1_last_buttons)
            Mouse.press();
        if (mouse_buttons < mouse1_last_buttons)
            Mouse.release();
        // front to the back
        // Mouse.move(-mouse1.getMouseX(), -mouse1.getMouseY(), mouse1.getWheel());
        // front to the left
        Mouse.move(-mouse1.getMouseY(), mouse1.getMouseX(), -mouse1.getWheel());
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

void OnHIDExtrasPress(uint32_t top, uint16_t key)
{

    if (top == 0xc0000)
    {
        Keyboard.press(0XE400 | key);
    }

    ShowHIDExtrasPress(top, key);
}

void OnHIDExtrasRelease(uint32_t top, uint16_t key)
{

    if (top == 0xc0000)
    {
        Keyboard.release(0XE400 | key);
    }

    Serial.print("HID (");
    Serial.print(top, HEX);
    Serial.print(") key release:");
    Serial.println(key, HEX);
}
