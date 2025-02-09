package sdl2

import "core:c"

when ODIN_OS == .Windows {
	@(ignore_duplicates)
	foreign import lib "SDL2.lib"
} else when ODIN_OS == .Darwin {
	@(ignore_duplicates)
	foreign import lib "system:SDL2.framework"
} else {
	@(ignore_duplicates)
	foreign import lib "system:SDL2"
}

Joystick :: struct {}

JoystickGUID :: distinct GUID

JoystickID :: distinct i32

JoystickType :: enum c.int {
	UNKNOWN,
	GAMECONTROLLER,
	WHEEL,
	ARCADE_STICK,
	FLIGHT_STICK,
	DANCE_PAD,
	GUITAR,
	DRUM_KIT,
	ARCADE_PAD,
	THROTTLE,
}

JoystickPowerLevel :: enum c.int {
	UNKNOWN = -1,
	EMPTY,   /* <= 5% */
	LOW,     /* <= 20% */
	MEDIUM,  /* <= 70% */
	FULL,    /* <= 100% */
	WIRED,
	MAX,
}

VIRTUAL_JOYSTICK_DESC_VERSION :: 1

UpdateCallback :: proc "c" (userdata: rawptr)
SetPlayerIndexCallback :: proc "c" (userdata: rawptr, player_index: c.int)
RumbleCallback :: proc "c" (userdata: rawptr, low_frequency_rumble, high_frequency_rumble: u16) -> int
RumbleTriggersCallback :: proc "c" (userdata: rawptr, left_rumble, right_rumble: u16) -> int
SetLEDCallback :: proc "c" (userdata: rawptr, red, green, blue: u8) -> int
SendEffectCallback :: proc "c" (userdata: rawptr, data: rawptr, size: c.int) -> int

VirtualJoystickDesc :: struct {
	version: u16,                           /**< `SDL_VIRTUAL_JOYSTICK_DESC_VERSION` */
	type: JoystickType,                     /**< `SDL_JoystickType` */
	naxes: u16,                             /**< the number of axes on this joystick */
	nbuttons: u16,                          /**< the number of buttons on this joystick */
	nhats: u16,                             /**< the number of hats on this joystick */
	vendor_id: u16,                         /**< the USB vendor ID of this joystick */
	product_id: u16,                        /**< the USB product ID of this joystick */
	_: u16,                                 /**< unused */
	button_mask: u32,                       /**< A mask of which buttons are valid for this controller
                                                 e.g. (1 << SDL_CONTROLLER_BUTTON_A) */
	axis_mask: u32,                         /**< A mask of which axes are valid for this controller
                                                 e.g. (1 << SDL_CONTROLLER_AXIS_LEFTX) */
	name: cstring,                          /**< the name of the joystick */

	userdata: rawptr,                       /**< User data pointer passed to callbacks */
	Update: UpdateCallback,                 /**< Called when the joystick state should be updated */
	SetPlayerIndex: SetPlayerIndexCallback, /**< Called when the player index is set */
	Rumble: RumbleCallback,                 /**< Implements SDL_JoystickRumble() */
	RumbleTriggers: RumbleTriggersCallback, /**< Implements SDL_JoystickRumbleTriggers() */
	SetLED: SetLEDCallback,                 /**< Implements SDL_JoystickSetLED() */
	SendEffect: SendEffectCallback,         /**< Implements SDL_JoystickSendEffect() */
}

IPHONE_MAX_GFORCE :: 5.0

JOYSTICK_AXIS_MAX :: +32767
JOYSTICK_AXIS_MIN :: -32768

HAT_CENTERED  :: 0x00
HAT_UP        :: 0x01
HAT_RIGHT     :: 0x02
HAT_DOWN      :: 0x04
HAT_LEFT      :: 0x08
HAT_RIGHTUP   :: HAT_RIGHT|HAT_UP
HAT_RIGHTDOWN :: HAT_RIGHT|HAT_DOWN
HAT_LEFTUP    :: HAT_LEFT|HAT_UP
HAT_LEFTDOWN  :: HAT_LEFT|HAT_DOWN

@(default_calling_convention="c", link_prefix="SDL_")
foreign lib {
	LockJoysticks                   :: proc() ---
	UnlockJoysticks                 :: proc() ---
	NumJoysticks                    :: proc() -> c.int ---
	JoystickNameForIndex            :: proc(device_index: c.int) -> cstring ---
	JoystickPathForIndex            :: proc(device_index: c.int) -> cstring ---
	JoystickGetDevicePlayerIndex    :: proc(device_index: c.int) -> c.int ---
	JoystickGetDeviceGUID           :: proc(device_index: c.int) -> JoystickGUID ---
	JoystickGetDeviceVendor         :: proc(device_index: c.int) -> u16 ---
	JoystickGetDeviceProduct        :: proc(device_index: c.int) -> u16 ---
	JoystickGetDeviceProductVersion :: proc(device_index: c.int) -> u16 ---
	JoystickGetDeviceType           :: proc(device_index: c.int) -> JoystickType ---
	JoystickGetDeviceInstanceID     :: proc(device_index: c.int) -> JoystickID ---
	JoystickOpen                    :: proc(device_index: c.int) -> ^Joystick ---
	JoystickFromInstanceID          :: proc(instance_id: JoystickID ) -> ^Joystick ---
	JoystickFromPlayerIndex         :: proc(player_index: c.int) -> ^Joystick ---
	JoystickAttachVirtual           :: proc(type: JoystickType, naxes, nbuttons, nhats: c.int) -> c.int ---
	JoystickAttachVirtualEx         :: proc(desc: ^VirtualJoystickDesc) -> c.int ---
	JoystickDetachVirtual           :: proc(device_index: c.int) -> c.int ---
	JoystickIsVirtual               :: proc(device_index: c.int) -> bool ---
	JoystickSetVirtualAxis          :: proc(joystick: ^Joystick, axis: c.int, value: i16) -> c.int ---
	JoystickSetVirtualButton        :: proc(joystick: ^Joystick, button: c.int, value: u8) -> c.int ---
	JoystickSetVirtualHat           :: proc(joystick: ^Joystick, hat: c.int, value: u8) -> c.int ---
	JoystickName                    :: proc(joystick: ^Joystick) -> cstring ---
	JoystickPath                    :: proc(joystick: ^Joystick) -> cstring ---
	JoystickGetPlayerIndex          :: proc(joystick: ^Joystick) -> c.int ---
	JoystickSetPlayerIndex          :: proc(joystick: ^Joystick, player_index: c.int) ---
	JoystickGetGUID                 :: proc(joystick: ^Joystick) -> JoystickGUID ---
	JoystickGetVendor               :: proc(joystick: ^Joystick) -> u16 ---
	JoystickGetProduct              :: proc(joystick: ^Joystick) -> u16 ---
	JoystickGetProductVersion       :: proc(joystick: ^Joystick) -> u16 ---
	JoystickGetFirmwareVersion      :: proc(joystick: ^Joystick) -> u16 ---
	JoystickGetSerial               :: proc(joystick: ^Joystick) -> cstring ---
	JoystickGetType                 :: proc(joystick: ^Joystick) -> JoystickType ---
	JoystickGetGUIDString           :: proc(guid: JoystickGUID, pszGUID: [^]u8, cbGUID: c.int) ---
	JoystickGetGUIDFromString       :: proc(pchGUID: cstring) -> JoystickGUID ---
	GetJoystickGUIDInfo             :: proc(guid: JoystickGUID, vendor, product, version, crc16: ^u16) ---
	JoystickGetAttached             :: proc(joystick: ^Joystick) -> bool ---
	JoystickInstanceID              :: proc(joystick: ^Joystick) -> JoystickID ---
	JoystickNumAxes                 :: proc(joystick: ^Joystick) -> c.int ---
	JoystickNumBalls                :: proc(joystick: ^Joystick) -> c.int ---
	JoystickNumHats                 :: proc(joystick: ^Joystick) -> c.int ---
	JoystickNumButtons              :: proc(joystick: ^Joystick) -> c.int ---
	JoystickUpdate                  :: proc() ---
	JoystickEventState              :: proc(state: c.int) -> c.int ---
	JoystickGetAxis                 :: proc(joystick: ^Joystick, axis: c.int) -> i64 ---
	JoystickGetAxisInitialState     :: proc(joystick: ^Joystick, axis: c.int, state: ^i16) -> bool ---
	JoystickGetHat                  :: proc(joystick: ^Joystick, hat: c.int) -> u8 ---
	JoystickGetBall                 :: proc(joystick: ^Joystick, ball: c.int, dx, dy: ^c.int) -> c.int ---
	JoystickGetButton               :: proc(joystick: ^Joystick, button: c.int) -> u8 ---
	JoystickRumble                  :: proc(joystick: ^Joystick, low_frequency_rumble, high_frequency_rumble: u16, duration_ms: u32) -> c.int ---
	JoystickRumbleTriggers          :: proc(joystick: ^Joystick, left_rumble, right_rumble: u16, duration_ms: u32) -> c.int ---
	JoystickHasLED                  :: proc(joystick: ^Joystick) -> bool ---
	JoystickHasRumble               :: proc(joystick: ^Joystick) -> bool ---
	JoystickHasRumbleTriggers       :: proc(joystick: ^Joystick) -> bool ---
	JoystickSetLED                  :: proc(joystick: ^Joystick, red, green, blue: u8) -> c.int ---
	JoystickSendEffect              :: proc(joystick: ^Joystick, data: rawptr, size: c.int) -> c.int ---
	JoystickClose                   :: proc(joystick: ^Joystick) ---
	JoystickCurrentPowerLevel       :: proc(joystick: ^Joystick) -> JoystickPowerLevel ---
}
