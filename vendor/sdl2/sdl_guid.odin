package sdl2

import "core:c"

when ODIN_OS == .Windows {
	foreign import lib "SDL2.lib"
} else when ODIN_OS == .Darwin {
	foreign import lib "system:SDL2.framework"
} else {
	foreign import lib "system:SDL2"
}

GUID :: struct {
	data: [16]u8,
}

@(default_calling_convention="c", link_prefix="SDL_")
foreign lib {
	GUIDToString        :: proc(guid: GUID, pszGUID: [^]u8, cbGUID: c.int) ---
	GUIDFromString      :: proc(pchGUID: cstring) -> GUID ---
}
