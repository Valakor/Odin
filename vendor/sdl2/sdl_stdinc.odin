package sdl2

import "core:c"
import "core:math"

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

bool :: distinct b32
#assert(size_of(bool) == size_of(c.int))

SIZE_MAX :: c.SIZE_MAX
FLT_EPSILON :: math.F32_EPSILON

FOURCC :: #force_inline proc "c" (A, B, C, D: u8) -> u32 {
	return u32(A) << 0 | u32(B) << 8 | u32(C) << 16 | u32(D) << 24
}


malloc_func  :: proc "c" (size: c.size_t) -> rawptr
calloc_func  :: proc "c" (nmemb, size: c.size_t) -> rawptr
realloc_func :: proc "c" (mem: rawptr, size: c.size_t) -> rawptr
free_func    :: proc "c" (mem: rawptr)

@(default_calling_convention="c", link_prefix="SDL_")
foreign lib {
	malloc   :: proc(size: c.size_t)              -> rawptr ---
	calloc   :: proc(nmemb, size: c.size_t)       -> rawptr ---
	realloc  :: proc(mem: rawptr, size: c.size_t) -> rawptr ---
	free     :: proc(mem: rawptr) ---

	GetOriginalMemoryFunctions :: proc(malloc_func:  ^malloc_func,
	                                   calloc_func:  ^calloc_func,
	                                   realloc_func: ^realloc_func,
	                                   free_func:    ^free_func) ---
	GetMemoryFunctions :: proc(malloc_func:  ^malloc_func,
	                           calloc_func:  ^calloc_func,
	                           realloc_func: ^realloc_func,
	                           free_func:    ^free_func) ---

	SetMemoryFunctions :: proc(malloc_func:  malloc_func,
	                           calloc_func:  calloc_func,
	                           realloc_func: realloc_func,
	                           free_func:    free_func) -> c.int ---

	GetNumAllocations :: proc() -> c.int ---

}

@(default_calling_convention="c", link_prefix="SDL_")
foreign lib {
	getenv :: proc(name: cstring) -> cstring ---
	setenv :: proc(name, value: cstring, overwrite: c.int) -> c.int ---
}

@(default_calling_convention="c", link_prefix="SDL_")
foreign lib {
	qsort   :: proc(base: rawptr, nmemb: c.size_t, size: c.size_t, compare: proc "c" (a: rawptr, b: rawptr) -> c.int) ---
	bsearch :: proc(key: rawptr, base: rawptr, nmemb: c.size_t, size: c.size_t, compare: proc "c" (a: rawptr, b: rawptr) -> c.int) -> rawptr ---
}

@(default_calling_convention="c", link_prefix="SDL_")
foreign lib {
	isalpha  :: proc(x: rune) -> bool ---
	isalnum  :: proc(x: rune) -> bool ---
	isblank  :: proc(x: rune) -> bool ---
	iscntrl  :: proc(x: rune) -> bool ---
	isdigit  :: proc(x: rune) -> bool ---
	isxdigit :: proc(x: rune) -> bool ---
	ispunct  :: proc(x: rune) -> bool ---
	isspace  :: proc(x: rune) -> bool ---
	isupper  :: proc(x: rune) -> bool ---
	islower  :: proc(x: rune) -> bool ---
	isprint  :: proc(x: rune) -> bool ---
	isgraph  :: proc(x: rune) -> bool ---
	toupper  :: proc(x: rune) -> bool ---
	tolower  :: proc(x: rune) -> bool ---

	crc16 :: proc(crc: u16, data: rawptr, len: c.size_t) -> u16 ---
	crc32 :: proc(crc: u32, data: rawptr, len: c.size_t) -> u32 ---
}

@(default_calling_convention="c", link_prefix="SDL_")
foreign lib {
	memset      :: proc(dst: rawptr, cnt: c.int, len: c.size_t) -> rawptr ---
	memcpy      :: proc(dst, src: rawptr, len: c.size_t) -> rawptr ---

	memmove     :: proc(dst, src: rawptr, len: c.size_t) -> rawptr ---
	memcmp      :: proc(s1, s2: rawptr, len: c.size_t) -> c.int ---

	wcslen      :: proc(wstr: [^]c.wchar_t) -> c.size_t ---
	wcslcpy     :: proc(dst, src: [^]c.wchar_t, maxlen: c.size_t) -> c.size_t ---
	wcslcat     :: proc(dst, src: [^]c.wchar_t, maxlen: c.size_t) -> c.size_t ---
	wcsdup      :: proc(wstr: [^]c.wchar_t) -> [^]c.wchar_t ---
	wcsstr      :: proc(haystack: [^]c.wchar_t, needle: [^]c.wchar_t) -> [^]c.wchar_t ---

	wcscmp      :: proc(str1, str2: [^]c.wchar_t) -> c.int ---
	wcsncmp     :: proc(str1, str2: [^]c.wchar_t, maxlen: c.size_t) -> c.int ---
	wcscasecmp  :: proc(str1, str2: [^]c.wchar_t) -> c.int ---
	wcsncasecmp :: proc(str1, str2: [^]c.wchar_t, len: c.size_t) -> c.int ---

	strlen      :: proc(str: cstring) -> c.size_t ---
	strlcpy     :: proc(dst, src: cstring, maxlen: c.size_t) -> c.size_t ---
	utf8strlcpy :: proc(dst, src: cstring, dst_bytes: c.size_t) -> c.size_t ---
	strlcat     :: proc(dst, src: cstring, maxlen: c.size_t) -> c.size_t ---
	strdup      :: proc(str: cstring) -> cstring ---
	strrev      :: proc(str: cstring) -> cstring ---
	strupr      :: proc(str: cstring) -> cstring ---
	strlwr      :: proc(str: cstring) -> cstring ---
	strchr      :: proc(str: cstring, c: c.int) -> cstring ---
	strrchr     :: proc(str: cstring, c: c.int) -> cstring ---
	strstr      :: proc(haystack, needle: cstring) -> cstring ---
	strcasestr  :: proc(haystack, needle: cstring) -> cstring ---
	strtokr     :: proc(s1, s2: cstring, saveptr: ^cstring) -> cstring ---
	utf8strlen  :: proc(str: cstring) -> c.size_t ---
	utf8strnlen :: proc(str: cstring, bytes: c.size_t) -> c.size_t ---

	itoa        :: proc(value: c.int, str: cstring, radix: c.int) -> cstring ---
	uitoa       :: proc(value: c.uint, str: cstring, radix: c.int) -> cstring ---
	ltoa        :: proc(value: c.long, str: cstring, radix: c.int) -> cstring ---
	ultoa       :: proc(value: c.ulong, str: cstring, radix: c.int) -> cstring ---
	lltoa       :: proc(value: i64, str: cstring, radix: c.int) -> cstring ---
	ulltoa      :: proc(value: u64, str: cstring, radix: c.int) -> cstring ---

	atoi        :: proc(str: cstring) -> c.int ---
	atof        :: proc(str: cstring) -> f64 ---
	strtol      :: proc(str: cstring, endp: ^cstring, base: c.int) -> c.long ---
	strtoul     :: proc(str: cstring, endp: ^cstring, base: c.int) -> c.ulong ---
	strtoll     :: proc(str: cstring, endp: ^cstring, base: c.int) -> i64 ---
	strtoull    :: proc(str: cstring, endp: ^cstring, base: c.int) -> u64 ---
	strtod      :: proc(str: cstring, endp: ^cstring) -> f64 ---

	strcmp      :: proc(str1, str2: cstring) -> c.int ---
	strncmp     :: proc(str1, str2: cstring, maxlen: c.size_t) -> c.int ---
	strcasecmp  :: proc(str1, str2: cstring) -> c.int ---
	strncasecmp :: proc(str1, str2: cstring, len: c.size_t) -> c.int ---

	sscanf      :: proc(text: cstring, fmt: cstring, #c_vararg args: ..any) -> c.int ---
	// vsscanf     :: proc(text: cstring, fmt: cstring, ap: c.va_list) -> c.int ---
	snprintf    :: proc(text: cstring, maxlen: c.size_t, fmt: cstring, #c_vararg args: ..any) -> c.int ---
	// vsnprintf   :: proc(text: cstring, maxlen: c.size_t, fmt: cstring, ap: c.va_list) -> c.int ---
	asprintf    :: proc(strp: ^cstring, fmt: cstring, #c_vararg args: ..any) -> c.int ---
	// vasprintf   :: proc(strp: ^cstring, fmt: cstring, ap: c.va_list) -> c.int ---
}


M_PI :: 3.14159265358979323846264338327950288

@(default_calling_convention="c", link_prefix="SDL_")
foreign lib {
	acos      :: proc(x: f64)           -> f64 ---
	acosf     :: proc(x: f32)           -> f32 ---
	asin      :: proc(x: f64)           -> f64 ---
	asinf     :: proc(x: f32)           -> f32 ---
	atan      :: proc(x: f64)           -> f64 ---
	atanf     :: proc(x: f32)           -> f32 ---
	atan2     :: proc(x, y: f64)        -> f64 ---
	atan2f    :: proc(x, y: f32)        -> f32 ---
	ceil      :: proc(x: f64)           -> f64 ---
	ceilf     :: proc(x: f32)           -> f32 ---
	copysign  :: proc(x, y: f64)        -> f64 ---
	copysignf :: proc(x, y: f32)        -> f32 ---
	cos       :: proc(x: f64)           -> f64 ---
	cosf      :: proc(x: f32)           -> f32 ---
	exp       :: proc(x: f64)           -> f64 ---
	expf      :: proc(x: f32)           -> f32 ---
	fabs      :: proc(x: f64)           -> f64 ---
	fabsf     :: proc(x: f32)           -> f32 ---
	floor     :: proc(x: f64)           -> f64 ---
	floorf    :: proc(x: f32)           -> f32 ---
	trunc     :: proc(x: f64)           -> f64 ---
	truncf    :: proc(x: f32)           -> f32 ---
	fmod      :: proc(x, y: f64)        -> f64 ---
	fmodf     :: proc(x, y: f32)        -> f32 ---
	log       :: proc(x: f64)           -> f64 ---
	logf      :: proc(x: f32)           -> f32 ---
	log10     :: proc(x: f64)           -> f64 ---
	log10f    :: proc(x: f32)           -> f32 ---
	pow       :: proc(x, y: f64)        -> f64 ---
	powf      :: proc(x, y: f32)        -> f32 ---
	round     :: proc(x: f64)           -> f64 ---
	roundf    :: proc(x: f32)           -> f32 ---
	lround    :: proc(x: f64)           -> c.long ---
	lroundf   :: proc(x: f32)           -> c.long ---
	scalbn    :: proc(x: f64, n: c.int) -> f64 ---
	scalbnf   :: proc(x: f32, n: c.int) -> f32 ---
	sin       :: proc(x: f64)           -> f64 ---
	sinf      :: proc(x: f32)           -> f32 ---
	sqrt      :: proc(x: f64)           -> f64 ---
	sqrtf     :: proc(x: f32)           -> f32 ---
	tan       :: proc(x: f64)           -> f64 ---
	tanf      :: proc(x: f32)           -> f32 ---
}

/* The SDL implementation of iconv() returns these error codes */
ICONV_ERROR  :: ~c.size_t(0) // (size_t)-1
ICONV_E2BIG  :: ~c.size_t(1) // (size_t)-2
ICONV_EILSEQ :: ~c.size_t(2) // (size_t)-3
ICONV_EINVAL :: ~c.size_t(3) // (size_t)-4

/* SDL_iconv_* are now always real symbols/types, not macros or inlined. */
iconv_t :: distinct rawptr

@(default_calling_convention="c", link_prefix="SDL_")
foreign lib {
	iconv_open   :: proc(tocode, fromcode: cstring) -> iconv_t ---
	iconv_close  :: proc(cd: iconv_t) -> c.int ---
	iconv        :: proc(cd: iconv_t, inbuf: ^cstring, inbytesleft: ^c.size_t, outbuf: ^[^]u8, outbytesleft: ^c.size_t) -> c.size_t ---
	iconv_string :: proc(tocode, fromcode, inbuf: cstring, inbytesleft: c.size_t) -> [^]u8 ---
}

iconv_utf8_locale :: proc "c" (s: string) -> cstring {
	return cast(cstring)iconv_string("", "UTF-8", cstring(raw_data(s)), len(s)+1)
}

iconv_utf8_utf16 :: iconv_utf8_ucs2
iconv_utf8_ucs2 :: proc "c" (s: string) -> [^]u16 {
	return cast([^]u16)iconv_string("UCS-2", "UTF-8", cstring(raw_data(s)), len(s)+1)
}

#assert(size_of(rune) == size_of(c.int))

iconv_utf8_utf32 :: iconv_utf8_ucs4
iconv_utf8_ucs4 :: proc "c" (s: string) -> [^]rune {
	return cast([^]rune)iconv_string("UCS-4", "UTF-8", cstring(raw_data(s)), len(s)+1)
}

iconv_wchar_utf8 :: proc "c" (s: [^]c.wchar_t) -> cstring {
	return cast(cstring)iconv_string("UTF-8", "WCHAR_T", cstring(cast([^]u8)s), (wcslen(s)+1)*size_of(c.wchar_t))
}
