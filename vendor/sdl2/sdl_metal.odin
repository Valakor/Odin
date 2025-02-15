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

MetalView :: distinct rawptr

@(default_calling_convention="c", link_prefix="SDL_")
foreign lib {
	Metal_CreateView      :: proc(window: ^Window) -> MetalView ---
	Metal_DestroyView     :: proc(view: MetalView) ---
	Metal_GetLayer        :: proc(view: MetalView) -> rawptr ---
	Metal_GetDrawableSize :: proc(window: ^Window, w, h: ^c.int) ---
}
