#include "USBHost_t36.h"

elapsedMillis sincePressed;
int lastKeyPressed = 0;

const int nDiv = 0x2F,
          nMult = 0x2A,
          nSub = 0x2D,
          nAdd = 0x2B,
          nEnter = 0x0A,
          n1 = 0xD5,
          n2 = 0xD9,
          n3 = 0xD6,
          n4 = 0xD8,
          n5 = 0x00,
          n6 = 0xD7,
          n7 = 0xD2,
          n8 = 0xDA,
          n9 = 0xD3,
          n0 = 0xD1,
          nDot = 0xD4,
          nTab = 0x09,
          nBackspace = 0x7F;

bool isActiveScrollUp = false,
     isActiveScrollDown = false;

const int NA = 0x1B;

USBHost myusb;
USBHub hub1(myusb);
USBHub hub2(myusb);
USBHub hub3(myusb);
USBHub hub4(myusb);
KeyboardController keyboard1(myusb);
KeyboardController keyboard2(myusb);

USBDriver *drivers[] = {&hub1, &hub2, &hub3, &hub4, &keyboard1, &keyboard2};
#define CNT_DEVICES (sizeof(drivers) / sizeof(drivers[0]))
const char *driver_names[CNT_DEVICES] = {"Hub1", "Hub2", "Hub3", "Hub4", "KB1", "KB2"};
bool driver_active[CNT_DEVICES] = {false, false, false, false, false};

void setup()
{
  // Serial1.begin(2000000);
  // while (!Serial); // wait for Arduino Serial Monitor
  myusb.begin();
  keyboard1.attachPress(Press1);
  keyboard1.attachRelease(Release1);
  keyboard2.attachPress(Press2);
  keyboard2.attachRelease(Release2);
}

void Press1(int key) { OnPress(key, keyboard1, 1, true); }
void Release1(int key) { OnPress(key, keyboard1, 1, false); }
void Press2(int key) { OnPress(key, keyboard2, 2, true); }
void Release2(int key) { OnPress(key, keyboard2, 2, false); }

void downup(int key, bool down)
{
  if (down)
  {
    Serial.print(sincePressed);
    sincePressed = 0;
    Keyboard.press(key);
  }
  else
  {
    delay(5);
    Keyboard.release(key);
  }
}

void downup(int key1, int key2, bool down)
{
  if (down)
  {
    Keyboard.press(key1);
    delay(5);
    Keyboard.press(key2);
  }
  else
  {
    delay(5);
    Keyboard.release(key2);
    delay(5);
    Keyboard.release(key1);
  }
}

void downup(int key1, int key2, int key3, bool down)
{
  if (down)
  {
    Keyboard.press(key1);
    delay(5);
    Keyboard.press(key2);
    delay(5);
    Keyboard.press(key3);
  }
  else
  {
    delay(5);
    Keyboard.release(key3);
    delay(5);
    Keyboard.release(key2);
    delay(5);
    Keyboard.release(key1);
  }
}

void noop() {}

int AHK_LEFT_SHIFT = KEY_LEFT_ALT,
    AHK_LEFT_ALT = KEY_LEFT_SHIFT,
    AHK_B = KEY_CAPS_LOCK,
    AHK_SPACE = KEY_F13;

void OnPress(int key, KeyboardController kb, int kbNum, bool down)
{
  int k = key;
  int d = down;

  if (kbNum == 1) // LEFT
  {
    k == nDiv         ? downup(KEY_LEFT_CTRL, KEY_F4, d)
    : k == nMult      ? downup(KEY_LEFT_CTRL, AHK_LEFT_SHIFT, AHK_B, d)
    : k == nSub       ? noop()
    : k == nAdd       ? noop()
    : k == nEnter     ? downup(AHK_SPACE, d)
    : k == n1         ? downup(KEY_ENTER, d)
    : k == n2         ? downup(KEY_DELETE, d)
    : k == n3         ? downup(KEY_TAB, d)
    : k == n4         ? downup(KEY_F24, d)
    : k == n5         ? downup(KEY_F23, d)
    : k == n6         ? downup(KEY_ESC, d)
    : k == n7         ? downup(KEY_LEFT_GUI, d)
    : k == n9         ? noop()
    : k == n8         ? noop()
    : k == n0         ? downup(KEY_LEFT_CTRL, d)
    : k == nDot       ? noop()
    : k == nTab       ? downup(KEY_LEFT_CTRL, KEY_T, d)
    : k == nBackspace ? downup(AHK_LEFT_ALT, KEY_F4, d)

                      : void(0);
  }
  else if (kbNum == 2) // RIGHT

  {
    k == nDiv         ? downup(KEY_LEFT_CTRL, KEY_F, d)
    : k == nMult      ? downup(KEY_F3, d)
    : k == nSub       ? downup(KEY_F22, d)
    : k == nAdd       ? downup(KEY_F24, d)
    : k == nEnter     ? downup(AHK_SPACE, d)
    : k == n1         ? noop()
    : k == n2         ? downup(KEY_LEFT_CTRL, KEY_Z, d)
    : k == n3         ? downup(KEY_BACKSPACE, d)
    : k == n4         ? noop()
    : k == n5         ? noop()
    : k == n6         ? downup(KEY_F23, d)
    : k == n7         ? noop()
    : k == n8         ? noop()
    : k == n9         ? downup(KEY_LEFT_CTRL, KEY_P, d)
    : k == n0         ? downup(KEY_ENTER, d)
    : k == nDot       ? downup(KEY_LEFT_CTRL, d)
    : k == nTab       ? noop()
    : k == nBackspace ? downup(KEY_F21, d)

                      : void(0);
  }

  // PRINT WHAT'S HAPPENING

  Serial.print("kb");
  Serial.print(kbNum);
  Serial.print(" - ");
  Serial.print(
      k == nDiv         ? "nDiv"
      : k == nMult      ? "nMult"
      : k == nSub       ? "nSub"
      : k == nAdd       ? "nAdd"
      : k == nEnter     ? "nEnter"
      : k == n1         ? "n1"
      : k == n2         ? "n2"
      : k == n3         ? "n3"
      : k == n4         ? "n4"
      : k == n5         ? "n5"
      : k == n6         ? "n6"
      : k == n7         ? "n7"
      : k == n8         ? "n8"
      : k == n9         ? "n9"
      : k == n0         ? "n0"
      : k == nDot       ? "nDot"
      : k == nTab       ? "nTab"
      : k == nBackspace ? "nBackspace"

                        : "not found");
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

void loop()
{
  myusb.Task();

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
