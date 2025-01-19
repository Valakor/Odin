package sdl2

import "core:c"

when ODIN_OS == .Windows {
	foreign import lib "SDL2.lib"
} else when ODIN_OS == .Darwin {
	foreign import lib "system:SDL2.framework"
} else {
	foreign import lib "system:SDL2"
}

Point :: struct {
	x: c.int,
	y: c.int,
}

FPoint :: struct {
	x: f32,
	y: f32,
}


Rect :: struct {
	x, y: c.int,
	w, h: c.int,
}

FRect :: struct {
	x, y: f32,
	w, h: f32,
}

PointInIRect :: proc(p: ^Point, r: ^Rect) -> bool {
	return bool((p.x >= r.x) && (p.x < (r.x + r.w)) && (p.y >= r.y) && (p.y < (r.y + r.h)))
}

PointInFRect :: proc(p: ^FPoint, r: ^FRect) -> bool {
	return bool((p.x >= r.x) && (p.x < (r.x + r.w)) && (p.y >= r.y) && (p.y < (r.y + r.h)))
}

PointInRect :: proc{ PointInIRect, PointInFRect }

IRectEmpty :: proc(r: ^Rect) -> bool {
	return bool(r == nil|| r.w <= 0 || r.h <= 0)
}

FRectEmpty :: proc(r: ^FRect) -> bool {
	return bool(r == nil|| r.w <= 0 || r.h <= 0)
}

RectEmpty :: proc{ IRectEmpty, FRectEmpty }

IRectEquals :: proc(a, b: ^Rect) -> bool {
	return a != nil && b != nil && a^ == b^
}

FRectEquals :: proc(a, b: ^FRect) -> bool {
	return a != nil && b != nil && a^ == b^
}

RectEquals :: proc{ IRectEquals, FRectEquals }

FRectEqualsEpsilon :: proc(a: ^FRect, b: ^FRect, epsilon: f32) -> bool {
    return bool(a != nil && b != nil && ((a == b) ||
            ((abs(a.x - b.x) <= epsilon) &&
            (abs(a.y - b.y) <= epsilon) &&
            (abs(a.w - b.w) <= epsilon) &&
            (abs(a.h - b.h) <= epsilon))))
}

@(default_calling_convention="c", link_prefix="SDL_")
foreign lib {
	HasIntersection       :: proc(A, B: ^Rect) -> bool ---
	IntersectRect         :: proc(A, B: ^Rect, result: ^Rect) -> bool ---
	UnionRect             :: proc(A, B: ^Rect, result: ^Rect) ---
	EnclosePoints         :: proc(points: [^]Point, count: c.int, clip: ^Rect, result: ^Rect) -> bool ---
	IntersectRectAndLine  :: proc(rect: ^Rect, X1, Y1, X2, Y2: ^c.int) -> bool ---

	HasIntersectionF      :: proc(A, B: ^FRect) -> bool ---
	IntersectFRect        :: proc(A, B: ^FRect, result: ^FRect) -> bool ---
	UnionFRect            :: proc(A, B: ^Rect, result: ^Rect) ---
	EncloseFPoints        :: proc(points: [^]FPoint, count: c.int, clip: ^FRect, result: ^FRect) -> bool ---
	IntersectFRectAndLine :: proc(rect: ^FRect, X1, Y1, X2, Y2: ^f32) -> bool ---
}
