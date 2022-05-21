#include <LinkedList.h>

class KeyStateInfo
{
public:
    int Key;
    int KeyboardNum;
    int LastDown;
    int LastUp;
    bool Down;
    int KeyState;
    bool exec();
};

const int KS_DOWN = 0,
          KS_UP = 1;

const int KS_TIME_CHORD = 10,
          KS_TIME_HOLD = 120,
          KS_TIME_DOUBLE_TAP_GAP = 40;

LinkedList<KeyStateInfo *> RecentKeyStates = LinkedList<KeyStateInfo *>();

// new
KeyStateInfo *ksi = new KeyStateInfo();

int LastAnyKeyChangedTime = 0;
int now;
int anyKeyChangedEllapsed;

void addSimpleInstance()
{
    now = millis();
    ksi->Down = true;
    ksi->Key = 0x22;
    ksi->KeyboardNum = 1;
    ksi->KeyState = KS_DOWN;
    ksi->LastDown = now;
    ksi->LastUp = now;
    RecentKeyStates.add(ksi);
}

void KeyThings()
{
}

void KeyStateChange(int key, int keyboard, bool down)
{

    now = millis();

    anyKeyChangedEllapsed = now - LastAnyKeyChangedTime;

    if (anyKeyChangedEllapsed < 2)
        anyKeyChangedEllapsed = 1;

    for (int i = 0; i < RecentKeyStates.size(); i++)
    {
    }

    if (down)
    {
    }
    else // up
    {
    }

    down ? Serial.printf("    d:  %i", anyKeyChangedEllapsed)
         : Serial.printf("          u:  %i", anyKeyChangedEllapsed);
    Serial.println();

    LastAnyKeyChangedTime = now;
}

const int AHK_LEFT_SHIFT = KEY_LEFT_ALT,
          AHK_LEFT_ALT = KEY_LEFT_SHIFT,
          AHK_B = KEY_CAPS_LOCK,
          AHK_ALPHA = KEY_F13,
          AHK_DELTA = KEY_F14,
          AHK_PHI = KEY_F15,
          KEY_ALPHA = KEY_F22,
          KEY_DELTA = KEY_F23,
          KEY_PHI = KEY_F24,
          RAW_K = 0xE,
          RAW_CAPS = 0x39,
          RAW_SPACE = 0x2C,
          KEY_BLANK = 0
    // RAW_L = 0x2F,
    // RAW_ = 0x,
    // RAW_ = 0x,
    // RAW_ = 0x,
    // RAW_ = 0x,
    // RAW_ = 0x,
    // RAW_ = 0x,
    // RAW_ = 0x,
    ;

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

const uint8_t RAW_LEFT_CTRL = 0x67,
              RAW_LEFT_SHIFT = 0x68,
              RAW_LEFT_ALT = 0x69,
              RAW_LEFT_GUI = 0x6A,
              RAW_RIGHT_CTRL = 0x6B,
              RAW_RIGHT_SHIFT = 0x6C,
              RAW_RIGHT_ALT = 0x6D;

const String KeypadShowNames(int key)
{
    return key == nDiv         ? "nDiv"
           : key == nMult      ? "nMult"
           : key == nSub       ? "nSub"
           : key == nAdd       ? "nAdd"
           : key == nEnter     ? "nEnter"
           : key == n1         ? "n1"
           : key == n2         ? "n2"
           : key == n3         ? "n3"
           : key == n4         ? "n4"
           : key == n5         ? "n5"
           : key == n6         ? "n6"
           : key == n7         ? "n7"
           : key == n8         ? "n8"
           : key == n9         ? "n9"
           : key == n0         ? "n0"
           : key == nDot       ? "nDot"
           : key == nTab       ? "nTab"
           : key == nBackspace ? "nBackspace"

                               : String(key);
}

void ShowOutPress(int key, KeyboardController keyboard)
{
    Serial.print("key '");
    switch (key)
    {
    case KEYD_UP:
        Serial.print("UP");
        break;
    case KEYD_DOWN:
        Serial.print("DN");
        break;
    case KEYD_LEFT:
        Serial.print("LEFT");
        break;
    case KEYD_RIGHT:
        Serial.print("RIGHT");
        break;
    case KEYD_INSERT:
        Serial.print("Ins");
        break;
    case KEYD_DELETE:
        Serial.print("Del");
        break;
    case KEYD_PAGE_UP:
        Serial.print("PUP");
        break;
    case KEYD_PAGE_DOWN:
        Serial.print("PDN");
        break;
    case KEYD_HOME:
        Serial.print("HOME");
        break;
    case KEYD_END:
        Serial.print("END");
        break;
    case KEYD_F1:
        Serial.print("F1");
        break;
    case KEYD_F2:
        Serial.print("F2");
        break;
    case KEYD_F3:
        Serial.print("F3");
        break;
    case KEYD_F4:
        Serial.print("F4");
        break;
    case KEYD_F5:
        Serial.print("F5");
        break;
    case KEYD_F6:
        Serial.print("F6");
        break;
    case KEYD_F7:
        Serial.print("F7");
        break;
    case KEYD_F8:
        Serial.print("F8");
        break;
    case KEYD_F9:
        Serial.print("F9");
        break;
    case KEYD_F10:
        Serial.print("F10");
        break;
    case KEYD_F11:
        Serial.print("F11");
        break;
    case KEYD_F12:
        Serial.print("F12");
        break;
    default:
        Serial.print(String(key));
        break;
    }
    Serial.print("'  ");
    Serial.print(key);
    Serial.print(" MOD: ");
    Serial.print(keyboard.getModifiers(), HEX);
    Serial.print(" OEM: ");
    Serial.print(keyboard.getOemKey(), HEX);
    Serial.print(" LEDS: ");
    Serial.println(keyboard.LEDS(), HEX);
}

void ShowHIDExtrasPress(uint32_t top, uint16_t key)
{
    Serial.print("HID (");
    Serial.print(top, HEX);
    Serial.print(") key press:");
    Serial.print(key, HEX);
    if (top == 0xc0000)
    {
        switch (key)
        {
        case 0x20:
            Serial.print(" - +10");
            break;
        case 0x21:
            Serial.print(" - +100");
            break;
        case 0x22:
            Serial.print(" - AM/PM");
            break;
        case 0x30:
            Serial.print(" - Power");
            break;
        case 0x31:
            Serial.print(" - Reset");
            break;
        case 0x32:
            Serial.print(" - Sleep");
            break;
        case 0x33:
            Serial.print(" - Sleep After");
            break;
        case 0x34:
            Serial.print(" - Sleep Mode");
            break;
        case 0x35:
            Serial.print(" - Illumination");
            break;
        case 0x36:
            Serial.print(" - Function Buttons");
            break;
        case 0x40:
            Serial.print(" - Menu");
            break;
        case 0x41:
            Serial.print(" - Menu  Pick");
            break;
        case 0x42:
            Serial.print(" - Menu Up");
            break;
        case 0x43:
            Serial.print(" - Menu Down");
            break;
        case 0x44:
            Serial.print(" - Menu Left");
            break;
        case 0x45:
            Serial.print(" - Menu Right");
            break;
        case 0x46:
            Serial.print(" - Menu Escape");
            break;
        case 0x47:
            Serial.print(" - Menu Value Increase");
            break;
        case 0x48:
            Serial.print(" - Menu Value Decrease");
            break;
        case 0x60:
            Serial.print(" - Data On Screen");
            break;
        case 0x61:
            Serial.print(" - Closed Caption");
            break;
        case 0x62:
            Serial.print(" - Closed Caption Select");
            break;
        case 0x63:
            Serial.print(" - VCR/TV");
            break;
        case 0x64:
            Serial.print(" - Broadcast Mode");
            break;
        case 0x65:
            Serial.print(" - Snapshot");
            break;
        case 0x66:
            Serial.print(" - Still");
            break;
        case 0x80:
            Serial.print(" - Selection");
            break;
        case 0x81:
            Serial.print(" - Assign Selection");
            break;
        case 0x82:
            Serial.print(" - Mode Step");
            break;
        case 0x83:
            Serial.print(" - Recall Last");
            break;
        case 0x84:
            Serial.print(" - Enter Channel");
            break;
        case 0x85:
            Serial.print(" - Order Movie");
            break;
        case 0x86:
            Serial.print(" - Channel");
            break;
        case 0x87:
            Serial.print(" - Media Selection");
            break;
        case 0x88:
            Serial.print(" - Media Select Computer");
            break;
        case 0x89:
            Serial.print(" - Media Select TV");
            break;
        case 0x8A:
            Serial.print(" - Media Select WWW");
            break;
        case 0x8B:
            Serial.print(" - Media Select DVD");
            break;
        case 0x8C:
            Serial.print(" - Media Select Telephone");
            break;
        case 0x8D:
            Serial.print(" - Media Select Program Guide");
            break;
        case 0x8E:
            Serial.print(" - Media Select Video Phone");
            break;
        case 0x8F:
            Serial.print(" - Media Select Games");
            break;
        case 0x90:
            Serial.print(" - Media Select Messages");
            break;
        case 0x91:
            Serial.print(" - Media Select CD");
            break;
        case 0x92:
            Serial.print(" - Media Select VCR");
            break;
        case 0x93:
            Serial.print(" - Media Select Tuner");
            break;
        case 0x94:
            Serial.print(" - Quit");
            break;
        case 0x95:
            Serial.print(" - Help");
            break;
        case 0x96:
            Serial.print(" - Media Select Tape");
            break;
        case 0x97:
            Serial.print(" - Media Select Cable");
            break;
        case 0x98:
            Serial.print(" - Media Select Satellite");
            break;
        case 0x99:
            Serial.print(" - Media Select Security");
            break;
        case 0x9A:
            Serial.print(" - Media Select Home");
            break;
        case 0x9B:
            Serial.print(" - Media Select Call");
            break;
        case 0x9C:
            Serial.print(" - Channel Increment");
            break;
        case 0x9D:
            Serial.print(" - Channel Decrement");
            break;
        case 0x9E:
            Serial.print(" - Media Select SAP");
            break;
        case 0xA0:
            Serial.print(" - VCR Plus");
            break;
        case 0xA1:
            Serial.print(" - Once");
            break;
        case 0xA2:
            Serial.print(" - Daily");
            break;
        case 0xA3:
            Serial.print(" - Weekly");
            break;
        case 0xA4:
            Serial.print(" - Monthly");
            break;
        case 0xB0:
            Serial.print(" - Play");
            break;
        case 0xB1:
            Serial.print(" - Pause");
            break;
        case 0xB2:
            Serial.print(" - Record");
            break;
        case 0xB3:
            Serial.print(" - Fast Forward");
            break;
        case 0xB4:
            Serial.print(" - Rewind");
            break;
        case 0xB5:
            Serial.print(" - Scan Next Track");
            break;
        case 0xB6:
            Serial.print(" - Scan Previous Track");
            break;
        case 0xB7:
            Serial.print(" - Stop");
            break;
        case 0xB8:
            Serial.print(" - Eject");
            break;
        case 0xB9:
            Serial.print(" - Random Play");
            break;
        case 0xBA:
            Serial.print(" - Select DisC");
            break;
        case 0xBB:
            Serial.print(" - Enter Disc");
            break;
        case 0xBC:
            Serial.print(" - Repeat");
            break;
        case 0xBD:
            Serial.print(" - Tracking");
            break;
        case 0xBE:
            Serial.print(" - Track Normal");
            break;
        case 0xBF:
            Serial.print(" - Slow Tracking");
            break;
        case 0xC0:
            Serial.print(" - Frame Forward");
            break;
        case 0xC1:
            Serial.print(" - Frame Back");
            break;
        case 0xC2:
            Serial.print(" - Mark");
            break;
        case 0xC3:
            Serial.print(" - Clear Mark");
            break;
        case 0xC4:
            Serial.print(" - Repeat From Mark");
            break;
        case 0xC5:
            Serial.print(" - Return To Mark");
            break;
        case 0xC6:
            Serial.print(" - Search Mark Forward");
            break;
        case 0xC7:
            Serial.print(" - Search Mark Backwards");
            break;
        case 0xC8:
            Serial.print(" - Counter Reset");
            break;
        case 0xC9:
            Serial.print(" - Show Counter");
            break;
        case 0xCA:
            Serial.print(" - Tracking Increment");
            break;
        case 0xCB:
            Serial.print(" - Tracking Decrement");
            break;
        case 0xCD:
            Serial.print(" - Pause/Continue");
            break;
        case 0xE0:
            Serial.print(" - Volume");
            break;
        case 0xE1:
            Serial.print(" - Balance");
            break;
        case 0xE2:
            Serial.print(" - Mute");
            break;
        case 0xE3:
            Serial.print(" - Bass");
            break;
        case 0xE4:
            Serial.print(" - Treble");
            break;
        case 0xE5:
            Serial.print(" - Bass Boost");
            break;
        case 0xE6:
            Serial.print(" - Surround Mode");
            break;
        case 0xE7:
            Serial.print(" - Loudness");
            break;
        case 0xE8:
            Serial.print(" - MPX");
            break;
        case 0xE9:
            Serial.print(" - Volume Up");
            break;
        case 0xEA:
            Serial.print(" - Volume Down");
            break;
        case 0xF0:
            Serial.print(" - Speed Select");
            break;
        case 0xF1:
            Serial.print(" - Playback Speed");
            break;
        case 0xF2:
            Serial.print(" - Standard Play");
            break;
        case 0xF3:
            Serial.print(" - Long Play");
            break;
        case 0xF4:
            Serial.print(" - Extended Play");
            break;
        case 0xF5:
            Serial.print(" - Slow");
            break;
        case 0x100:
            Serial.print(" - Fan Enable");
            break;
        case 0x101:
            Serial.print(" - Fan Speed");
            break;
        case 0x102:
            Serial.print(" - Light");
            break;
        case 0x103:
            Serial.print(" - Light Illumination Level");
            break;
        case 0x104:
            Serial.print(" - Climate Control Enable");
            break;
        case 0x105:
            Serial.print(" - Room Temperature");
            break;
        case 0x106:
            Serial.print(" - Security Enable");
            break;
        case 0x107:
            Serial.print(" - Fire Alarm");
            break;
        case 0x108:
            Serial.print(" - Police Alarm");
            break;
        case 0x150:
            Serial.print(" - Balance Right");
            break;
        case 0x151:
            Serial.print(" - Balance Left");
            break;
        case 0x152:
            Serial.print(" - Bass Increment");
            break;
        case 0x153:
            Serial.print(" - Bass Decrement");
            break;
        case 0x154:
            Serial.print(" - Treble Increment");
            break;
        case 0x155:
            Serial.print(" - Treble Decrement");
            break;
        case 0x160:
            Serial.print(" - Speaker System");
            break;
        case 0x161:
            Serial.print(" - Channel Left");
            break;
        case 0x162:
            Serial.print(" - Channel Right");
            break;
        case 0x163:
            Serial.print(" - Channel Center");
            break;
        case 0x164:
            Serial.print(" - Channel Front");
            break;
        case 0x165:
            Serial.print(" - Channel Center Front");
            break;
        case 0x166:
            Serial.print(" - Channel Side");
            break;
        case 0x167:
            Serial.print(" - Channel Surround");
            break;
        case 0x168:
            Serial.print(" - Channel Low Frequency Enhancement");
            break;
        case 0x169:
            Serial.print(" - Channel Top");
            break;
        case 0x16A:
            Serial.print(" - Channel Unknown");
            break;
        case 0x170:
            Serial.print(" - Sub-channel");
            break;
        case 0x171:
            Serial.print(" - Sub-channel Increment");
            break;
        case 0x172:
            Serial.print(" - Sub-channel Decrement");
            break;
        case 0x173:
            Serial.print(" - Alternate Audio Increment");
            break;
        case 0x174:
            Serial.print(" - Alternate Audio Decrement");
            break;
        case 0x180:
            Serial.print(" - Application Launch Buttons");
            break;
        case 0x181:
            Serial.print(" - AL Launch Button Configuration Tool");
            break;
        case 0x182:
            Serial.print(" - AL Programmable Button Configuration");
            break;
        case 0x183:
            Serial.print(" - AL Consumer Control Configuration");
            break;
        case 0x184:
            Serial.print(" - AL Word Processor");
            break;
        case 0x185:
            Serial.print(" - AL Text Editor");
            break;
        case 0x186:
            Serial.print(" - AL Spreadsheet");
            break;
        case 0x187:
            Serial.print(" - AL Graphics Editor");
            break;
        case 0x188:
            Serial.print(" - AL Presentation App");
            break;
        case 0x189:
            Serial.print(" - AL Database App");
            break;
        case 0x18A:
            Serial.print(" - AL Email Reader");
            break;
        case 0x18B:
            Serial.print(" - AL Newsreader");
            break;
        case 0x18C:
            Serial.print(" - AL Voicemail");
            break;
        case 0x18D:
            Serial.print(" - AL Contacts/Address Book");
            break;
        case 0x18E:
            Serial.print(" - AL Calendar/Schedule");
            break;
        case 0x18F:
            Serial.print(" - AL Task/Project Manager");
            break;
        case 0x190:
            Serial.print(" - AL Log/Journal/Timecard");
            break;
        case 0x191:
            Serial.print(" - AL Checkbook/Finance");
            break;
        case 0x192:
            Serial.print(" - AL Calculator");
            break;
        case 0x193:
            Serial.print(" - AL A/V Capture/Playback");
            break;
        case 0x194:
            Serial.print(" - AL Local Machine Browser");
            break;
        case 0x195:
            Serial.print(" - AL LAN/WAN Browser");
            break;
        case 0x196:
            Serial.print(" - AL Internet Browser");
            break;
        case 0x197:
            Serial.print(" - AL Remote Networking/ISP Connect");
            break;
        case 0x198:
            Serial.print(" - AL Network Conference");
            break;
        case 0x199:
            Serial.print(" - AL Network Chat");
            break;
        case 0x19A:
            Serial.print(" - AL Telephony/Dialer");
            break;
        case 0x19B:
            Serial.print(" - AL Logon");
            break;
        case 0x19C:
            Serial.print(" - AL Logoff");
            break;
        case 0x19D:
            Serial.print(" - AL Logon/Logoff");
            break;
        case 0x19E:
            Serial.print(" - AL Terminal Lock/Screensaver");
            break;
        case 0x19F:
            Serial.print(" - AL Control Panel");
            break;
        case 0x1A0:
            Serial.print(" - AL Command Line Processor/Run");
            break;
        case 0x1A1:
            Serial.print(" - AL Process/Task Manager");
            break;
        case 0x1A2:
            Serial.print(" - AL Select Tast/Application");
            break;
        case 0x1A3:
            Serial.print(" - AL Next Task/Application");
            break;
        case 0x1A4:
            Serial.print(" - AL Previous Task/Application");
            break;
        case 0x1A5:
            Serial.print(" - AL Preemptive Halt Task/Application");
            break;
        case 0x200:
            Serial.print(" - Generic GUI Application Controls");
            break;
        case 0x201:
            Serial.print(" - AC New");
            break;
        case 0x202:
            Serial.print(" - AC Open");
            break;
        case 0x203:
            Serial.print(" - AC Close");
            break;
        case 0x204:
            Serial.print(" - AC Exit");
            break;
        case 0x205:
            Serial.print(" - AC Maximize");
            break;
        case 0x206:
            Serial.print(" - AC Minimize");
            break;
        case 0x207:
            Serial.print(" - AC Save");
            break;
        case 0x208:
            Serial.print(" - AC Print");
            break;
        case 0x209:
            Serial.print(" - AC Properties");
            break;
        case 0x21A:
            Serial.print(" - AC Undo");
            break;
        case 0x21B:
            Serial.print(" - AC Copy");
            break;
        case 0x21C:
            Serial.print(" - AC Cut");
            break;
        case 0x21D:
            Serial.print(" - AC Paste");
            break;
        case 0x21E:
            Serial.print(" - AC Select All");
            break;
        case 0x21F:
            Serial.print(" - AC Find");
            break;
        case 0x220:
            Serial.print(" - AC Find and Replace");
            break;
        case 0x221:
            Serial.print(" - AC Search");
            break;
        case 0x222:
            Serial.print(" - AC Go To");
            break;
        case 0x223:
            Serial.print(" - AC Home");
            break;
        case 0x224:
            Serial.print(" - AC Back");
            break;
        case 0x225:
            Serial.print(" - AC Forward");
            break;
        case 0x226:
            Serial.print(" - AC Stop");
            break;
        case 0x227:
            Serial.print(" - AC Refresh");
            break;
        case 0x228:
            Serial.print(" - AC Previous Link");
            break;
        case 0x229:
            Serial.print(" - AC Next Link");
            break;
        case 0x22A:
            Serial.print(" - AC Bookmarks");
            break;
        case 0x22B:
            Serial.print(" - AC History");
            break;
        case 0x22C:
            Serial.print(" - AC Subscriptions");
            break;
        case 0x22D:
            Serial.print(" - AC Zoom In");
            break;
        case 0x22E:
            Serial.print(" - AC Zoom Out");
            break;
        case 0x22F:
            Serial.print(" - AC Zoom");
            break;
        case 0x230:
            Serial.print(" - AC Full Screen View");
            break;
        case 0x231:
            Serial.print(" - AC Normal View");
            break;
        case 0x232:
            Serial.print(" - AC View Toggle");
            break;
        case 0x233:
            Serial.print(" - AC Scroll Up");
            break;
        case 0x234:
            Serial.print(" - AC Scroll Down");
            break;
        case 0x235:
            Serial.print(" - AC Scroll");
            break;
        case 0x236:
            Serial.print(" - AC Pan Left");
            break;
        case 0x237:
            Serial.print(" - AC Pan Right");
            break;
        case 0x238:
            Serial.print(" - AC Pan");
            break;
        case 0x239:
            Serial.print(" - AC New Window");
            break;
        case 0x23A:
            Serial.print(" - AC Tile Horizontally");
            break;
        case 0x23B:
            Serial.print(" - AC Tile Vertically");
            break;
        case 0x23C:
            Serial.print(" - AC Format");
            break;
        }
    }
    Serial.println();
}
