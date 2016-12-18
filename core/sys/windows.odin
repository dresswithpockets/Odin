#foreign_system_library "user32" when ODIN_OS == "windows";
#foreign_system_library "gdi32"  when ODIN_OS == "windows";

type HANDLE    rawptr;
type HWND      HANDLE;
type HDC       HANDLE;
type HINSTANCE HANDLE;
type HICON     HANDLE;
type HCURSOR   HANDLE;
type HMENU     HANDLE;
type HBRUSH    HANDLE;
type HGDIOBJ   HANDLE;
type HMODULE   HANDLE;
type WPARAM    uint;
type LPARAM    int;
type LRESULT   int;
type ATOM      i16;
type BOOL      i32;
type WNDPROC   proc(hwnd HWND, msg u32, wparam WPARAM, lparam LPARAM) -> LRESULT;

const INVALID_HANDLE_VALUE = (-1 as int) as HANDLE;

const CS_VREDRAW    = 0x0001;
const CS_HREDRAW    = 0x0002;
const CS_OWNDC      = 0x0020;
const CW_USEDEFAULT = -0x80000000;

const WS_OVERLAPPED       = 0;
const WS_MAXIMIZEBOX      = 0x00010000;
const WS_MINIMIZEBOX      = 0x00020000;
const WS_THICKFRAME       = 0x00040000;
const WS_SYSMENU          = 0x00080000;
const WS_CAPTION          = 0x00C00000;
const WS_VISIBLE          = 0x10000000;
const WS_OVERLAPPEDWINDOW = WS_OVERLAPPED|WS_CAPTION|WS_SYSMENU|WS_THICKFRAME|WS_MINIMIZEBOX|WS_MAXIMIZEBOX;

const WM_DESTROY = 0x0002;
const WM_CLOSE   = 0x0010;
const WM_QUIT    = 0x0012;
const WM_KEYDOWN = 0x0100;
const WM_KEYUP   = 0x0101;

const PM_REMOVE = 1;

const COLOR_BACKGROUND = 1 as HBRUSH;
const BLACK_BRUSH = 4;

const SM_CXSCREEN = 0;
const SM_CYSCREEN = 1;

const SW_SHOW = 5;

type POINT struct #ordered {
	x, y i32;
}


type WNDCLASSEXA struct #ordered {
	size, style           u32;
	wnd_proc              WNDPROC;
	cls_extra, wnd_extra  i32;
	instance              HINSTANCE;
	icon                  HICON;
	cursor                HCURSOR;
	background            HBRUSH;
	menu_name, class_name ^u8;
	sm                    HICON;
}

type MSG struct #ordered {
	hwnd    HWND;
	message u32;
	wparam  WPARAM;
	lparam  LPARAM;
	time    u32;
	pt      POINT;
}

type RECT struct #ordered {
	left   i32;
	top    i32;
	right  i32;
	bottom i32;
}

type FILETIME struct #ordered {
	low_date_time, high_date_time u32;
}

type BY_HANDLE_FILE_INFORMATION struct #ordered {
	file_attributes      u32;
	creation_time,
	last_access_time,
	last_write_time      FILETIME;
	volume_serial_number,
	file_size_high,
	file_size_low,
	number_of_links,
	file_index_high,
	file_index_low       u32;
}

type WIN32_FILE_ATTRIBUTE_DATA struct #ordered {
	file_attributes  u32;
	creation_time,
	last_access_time,
	last_write_time  FILETIME;
	file_size_high,
	file_size_low    u32;
}

type GET_FILEEX_INFO_LEVELS i32;
const GetFileExInfoStandard = 0 as GET_FILEEX_INFO_LEVELS;
const GetFileExMaxInfoLevel = 1 as GET_FILEEX_INFO_LEVELS;

proc GetLastError    () -> i32                           #foreign #dll_import
proc ExitProcess     (exit_code u32)                    #foreign #dll_import
proc GetDesktopWindow() -> HWND                          #foreign #dll_import
proc GetCursorPos    (p ^POINT) -> i32                  #foreign #dll_import
proc ScreenToClient  (h HWND, p ^POINT) -> i32         #foreign #dll_import
proc GetModuleHandleA(module_name ^u8) -> HINSTANCE     #foreign #dll_import
proc GetStockObject  (fn_object i32) -> HGDIOBJ         #foreign #dll_import
proc PostQuitMessage (exit_code i32)                    #foreign #dll_import
proc SetWindowTextA  (hwnd HWND, c_string ^u8) -> BOOL #foreign #dll_import

proc QueryPerformanceFrequency(result ^i64) -> i32 #foreign #dll_import
proc QueryPerformanceCounter  (result ^i64) -> i32 #foreign #dll_import

proc Sleep(ms i32) -> i32 #foreign #dll_import

proc OutputDebugStringA(c_str ^u8) #foreign #dll_import


proc RegisterClassExA(wc ^WNDCLASSEXA) -> ATOM #foreign #dll_import
proc CreateWindowExA (ex_style u32,
                      class_name, title ^u8,
                      style u32,
                      x, y, w, h i32,
                      parent HWND, menu HMENU, instance HINSTANCE,
                      param rawptr) -> HWND #foreign #dll_import

proc ShowWindow      (hwnd HWND, cmd_show i32) -> BOOL #foreign #dll_import
proc TranslateMessage(msg ^MSG) -> BOOL                 #foreign #dll_import
proc DispatchMessageA(msg ^MSG) -> LRESULT              #foreign #dll_import
proc UpdateWindow    (hwnd HWND) -> BOOL                #foreign #dll_import
proc PeekMessageA    (msg ^MSG, hwnd HWND,
                         msg_filter_min, msg_filter_max, remove_msg u32) -> BOOL #foreign #dll_import

proc DefWindowProcA  (hwnd HWND, msg u32, wparam WPARAM, lparam LPARAM) -> LRESULT #foreign #dll_import

proc AdjustWindowRect(rect ^RECT, style u32, menu BOOL) -> BOOL #foreign #dll_import
proc GetActiveWindow () -> HWND #foreign #dll_import


proc GetQueryPerformanceFrequency() -> i64 {
	var r i64;
	QueryPerformanceFrequency(^r);
	return r;
}

proc GetCommandLineA() -> ^u8 #foreign #dll_import
proc GetSystemMetrics(index i32) -> i32 #foreign #dll_import
proc GetCurrentThreadId() -> u32 #foreign #dll_import

// File Stuff

proc CloseHandle (h HANDLE) -> i32 #foreign #dll_import
proc GetStdHandle(h i32) -> HANDLE #foreign #dll_import
proc CreateFileA (filename ^u8, desired_access, share_mode u32,
                     security rawptr,
                     creation, flags_and_attribs u32, template_file HANDLE) -> HANDLE #foreign #dll_import
proc ReadFile    (h HANDLE, buf rawptr, to_read u32, bytes_read ^i32, overlapped rawptr) -> BOOL #foreign #dll_import
proc WriteFile   (h HANDLE, buf rawptr, len i32, written_result ^i32, overlapped rawptr) -> i32 #foreign #dll_import

proc GetFileSizeEx             (file_handle HANDLE, file_size ^i64) -> BOOL #foreign #dll_import
proc GetFileAttributesExA      (filename ^u8, info_level_id GET_FILEEX_INFO_LEVELS, file_info rawptr) -> BOOL #foreign #dll_import
proc GetFileInformationByHandle(file_handle HANDLE, file_info ^BY_HANDLE_FILE_INFORMATION) -> BOOL #foreign #dll_import

const FILE_SHARE_READ      = 0x00000001;
const FILE_SHARE_WRITE     = 0x00000002;
const FILE_SHARE_DELETE    = 0x00000004;
const FILE_GENERIC_ALL     = 0x10000000;
const FILE_GENERIC_EXECUTE = 0x20000000;
const FILE_GENERIC_WRITE   = 0x40000000;
const FILE_GENERIC_READ    = 0x80000000;

const STD_INPUT_HANDLE  = -10;
const STD_OUTPUT_HANDLE = -11;
const STD_ERROR_HANDLE  = -12;

const CREATE_NEW        = 1;
const CREATE_ALWAYS     = 2;
const OPEN_EXISTING     = 3;
const OPEN_ALWAYS       = 4;
const TRUNCATE_EXISTING = 5;





proc HeapAlloc     (h HANDLE, flags u32, bytes int) -> rawptr                 #foreign #dll_import
proc HeapReAlloc   (h HANDLE, flags u32, memory rawptr, bytes int) -> rawptr #foreign #dll_import
proc HeapFree      (h HANDLE, flags u32, memory rawptr) -> BOOL               #foreign #dll_import
proc GetProcessHeap() -> HANDLE #foreign #dll_import


const HEAP_ZERO_MEMORY = 0x00000008;

// Synchronization

type SECURITY_ATTRIBUTES struct #ordered {
	length              u32;
	security_descriptor rawptr;
	inherit_handle      BOOL;
}

const INFINITE = 0xffffffff;

proc CreateSemaphoreA   (attributes ^SECURITY_ATTRIBUTES, initial_count, maximum_count i32, name ^byte) -> HANDLE #foreign #dll_import
proc ReleaseSemaphore   (semaphore HANDLE, release_count i32, previous_count ^i32) -> BOOL #foreign #dll_import
proc WaitForSingleObject(handle HANDLE, milliseconds u32) -> u32 #foreign #dll_import


proc InterlockedCompareExchange(dst ^i32, exchange, comparand i32) -> i32 #foreign
proc InterlockedExchange       (dst ^i32, desired i32) -> i32 #foreign
proc InterlockedExchangeAdd    (dst ^i32, desired i32) -> i32 #foreign
proc InterlockedAnd            (dst ^i32, desired i32) -> i32 #foreign
proc InterlockedOr             (dst ^i32, desired i32) -> i32 #foreign

proc InterlockedCompareExchange64(dst ^i64, exchange, comparand i64) -> i64 #foreign
proc InterlockedExchange64       (dst ^i64, desired i64) -> i64 #foreign
proc InterlockedExchangeAdd64    (dst ^i64, desired i64) -> i64 #foreign
proc InterlockedAnd64            (dst ^i64, desired i64) -> i64 #foreign
proc InterlockedOr64             (dst ^i64, desired i64) -> i64 #foreign

proc _mm_pause       () #foreign
proc ReadWriteBarrier() #foreign
proc WriteBarrier    () #foreign
proc ReadBarrier     () #foreign


// GDI

type BITMAPINFOHEADER struct #ordered {
	size              u32;
	width, height     i32;
	planes, bit_count i16;
	compression       u32;
	size_image        u32;
	x_pels_per_meter  i32;
	y_pels_per_meter  i32;
	clr_used          u32;
	clr_important     u32;
}
type BITMAPINFO struct #ordered {
	using header BITMAPINFOHEADER;
	colors       [1]RGBQUAD;
}


type RGBQUAD struct #ordered {
	blue, green, red, reserved byte;
}

const BI_RGB         = 0;
const DIB_RGB_COLORS = 0x00;
const SRCCOPY        = 0x00cc0020 as u32;

proc StretchDIBits(hdc HDC,
                   x_dst, y_dst, width_dst, height_dst i32,
                   x_src, y_src, width_src, header_src i32,
                   bits rawptr, bits_info ^BITMAPINFO,
                   usage u32,
                   rop u32) -> i32 #foreign #dll_import



proc LoadLibraryA  (c_str ^u8) -> HMODULE #foreign
proc FreeLibrary   (h HMODULE) #foreign
proc GetProcAddress(h HMODULE, c_str ^u8) -> PROC #foreign

proc GetClientRect(hwnd HWND, rect ^RECT) -> BOOL #foreign



// Windows OpenGL

const PFD_TYPE_RGBA             = 0;
const PFD_TYPE_COLORINDEX       = 1;
const PFD_MAIN_PLANE            = 0;
const PFD_OVERLAY_PLANE         = 1;
const PFD_UNDERLAY_PLANE        = -1;
const PFD_DOUBLEBUFFER          = 1;
const PFD_STEREO                = 2;
const PFD_DRAW_TO_WINDOW        = 4;
const PFD_DRAW_TO_BITMAP        = 8;
const PFD_SUPPORT_GDI           = 16;
const PFD_SUPPORT_OPENGL        = 32;
const PFD_GENERIC_FORMAT        = 64;
const PFD_NEED_PALETTE          = 128;
const PFD_NEED_SYSTEM_PALETTE   = 0x00000100;
const PFD_SWAP_EXCHANGE         = 0x00000200;
const PFD_SWAP_COPY             = 0x00000400;
const PFD_SWAP_LAYER_BUFFERS    = 0x00000800;
const PFD_GENERIC_ACCELERATED   = 0x00001000;
const PFD_DEPTH_DONTCARE        = 0x20000000;
const PFD_DOUBLEBUFFER_DONTCARE = 0x40000000;
const PFD_STEREO_DONTCARE       = 0x80000000;

type HGLRC HANDLE;
type PROC  proc();
type wglCreateContextAttribsARBType proc(hdc HDC, hshareContext rawptr, attribList ^i32) -> HGLRC;


type PIXELFORMATDESCRIPTOR struct #ordered {
	size,
	version,
	flags u32;

	pixel_type,
	color_bits,
	red_bits,
	red_shift,
	green_bits,
	green_shift,
	blue_bits,
	blue_shift,
	alpha_bits,
	alpha_shift,
	accum_bits,
	accum_red_bits,
	accum_green_bits,
	accum_blue_bits,
	accum_alpha_bits,
	depth_bits,
	stencil_bits,
	aux_buffers,
	layer_type,
	reserved byte;

	layer_mask,
	visible_mask,
	damage_mask u32;
}

proc GetDC            (h HANDLE) -> HDC #foreign
proc SetPixelFormat   (hdc HDC, pixel_format i32, pfd ^PIXELFORMATDESCRIPTOR ) -> BOOL #foreign #dll_import
proc ChoosePixelFormat(hdc HDC, pfd ^PIXELFORMATDESCRIPTOR) -> i32 #foreign #dll_import
proc SwapBuffers      (hdc HDC) -> BOOL #foreign #dll_import
proc ReleaseDC        (wnd HWND, hdc HDC) -> i32 #foreign #dll_import

const WGL_CONTEXT_MAJOR_VERSION_ARB             = 0x2091;
const WGL_CONTEXT_MINOR_VERSION_ARB             = 0x2092;
const WGL_CONTEXT_PROFILE_MASK_ARB              = 0x9126;
const WGL_CONTEXT_CORE_PROFILE_BIT_ARB          = 0x0001;
const WGL_CONTEXT_COMPATIBILITY_PROFILE_BIT_ARB = 0x0002;

proc wglCreateContext (hdc HDC) -> HGLRC #foreign #dll_import
proc wglMakeCurrent   (hdc HDC, hglrc HGLRC) -> BOOL #foreign #dll_import
proc wglGetProcAddress(c_str ^u8) -> PROC #foreign #dll_import
proc wglDeleteContext (hglrc HGLRC) -> BOOL #foreign #dll_import



proc GetKeyState     (v_key i32) -> i16 #foreign #dll_import
proc GetAsyncKeyState(v_key i32) -> i16 #foreign #dll_import

proc is_key_down(key Key_Code) -> bool {
	return GetAsyncKeyState(key as i32) < 0;
}

type Key_Code enum i32 {
	LBUTTON    = 0x01,
	RBUTTON    = 0x02,
	CANCEL     = 0x03,
	MBUTTON    = 0x04,

	BACK       = 0x08,
	TAB        = 0x09,

	CLEAR      = 0x0C,
	RETURN     = 0x0D,

	SHIFT      = 0x10,
	CONTROL    = 0x11,
	MENU       = 0x12,
	PAUSE      = 0x13,
	CAPITAL    = 0x14,

	KANA       = 0x15,
	HANGEUL    = 0x15,
	HANGUL     = 0x15,
	JUNJA      = 0x17,
	FINAL      = 0x18,
	HANJA      = 0x19,
	KANJI      = 0x19,

	ESCAPE     = 0x1B,

	CONVERT    = 0x1C,
	NONCONVERT = 0x1D,
	ACCEPT     = 0x1E,
	MODECHANGE = 0x1F,

	SPACE      = 0x20,
	PRIOR      = 0x21,
	NEXT       = 0x22,
	END        = 0x23,
	HOME       = 0x24,
	LEFT       = 0x25,
	UP         = 0x26,
	RIGHT      = 0x27,
	DOWN       = 0x28,
	SELECT     = 0x29,
	PRINT      = 0x2A,
	EXECUTE    = 0x2B,
	SNAPSHOT   = 0x2C,
	INSERT     = 0x2D,
	DELETE     = 0x2E,
	HELP       = 0x2F,

	NUM0 = '0',
	NUM1 = '1',
	NUM2 = '2',
	NUM3 = '3',
	NUM4 = '4',
	NUM5 = '5',
	NUM6 = '6',
	NUM7 = '7',
	NUM8 = '8',
	NUM9 = '9',

	A = 'A',
	B = 'B',
	C = 'C',
	D = 'D',
	E = 'E',
	F = 'F',
	G = 'G',
	H = 'H',
	I = 'I',
	J = 'J',
	K = 'K',
	L = 'L',
	M = 'M',
	N = 'N',
	O = 'O',
	P = 'P',
	Q = 'Q',
	R = 'R',
	S = 'S',
	T = 'T',
	U = 'U',
	V = 'V',
	W = 'W',
	X = 'X',
	Y = 'Y',
	Z = 'Z',

	LWIN       = 0x5B,
	RWIN       = 0x5C,
	APPS       = 0x5D,

	NUMPAD0    = 0x60,
	NUMPAD1    = 0x61,
	NUMPAD2    = 0x62,
	NUMPAD3    = 0x63,
	NUMPAD4    = 0x64,
	NUMPAD5    = 0x65,
	NUMPAD6    = 0x66,
	NUMPAD7    = 0x67,
	NUMPAD8    = 0x68,
	NUMPAD9    = 0x69,
	MULTIPLY   = 0x6A,
	ADD        = 0x6B,
	SEPARATOR  = 0x6C,
	SUBTRACT   = 0x6D,
	DECIMAL    = 0x6E,
	DIVIDE     = 0x6F,
	F1         = 0x70,
	F2         = 0x71,
	F3         = 0x72,
	F4         = 0x73,
	F5         = 0x74,
	F6         = 0x75,
	F7         = 0x76,
	F8         = 0x77,
	F9         = 0x78,
	F10        = 0x79,
	F11        = 0x7A,
	F12        = 0x7B,
	F13        = 0x7C,
	F14        = 0x7D,
	F15        = 0x7E,
	F16        = 0x7F,
	F17        = 0x80,
	F18        = 0x81,
	F19        = 0x82,
	F20        = 0x83,
	F21        = 0x84,
	F22        = 0x85,
	F23        = 0x86,
	F24        = 0x87,

	NUMLOCK    = 0x90,
	SCROLL     = 0x91,

	LSHIFT     = 0xA0,
	RSHIFT     = 0xA1,
	LCONTROL   = 0xA2,
	RCONTROL   = 0xA3,
	LMENU      = 0xA4,
	RMENU      = 0xA5,
	PROCESSKEY = 0xE5,
	ATTN       = 0xF6,
	CRSEL      = 0xF7,
	EXSEL      = 0xF8,
	EREOF      = 0xF9,
	PLAY       = 0xFA,
	ZOOM       = 0xFB,
	NONAME     = 0xFC,
	PA1        = 0xFD,
	OEM_CLEAR  = 0xFE,
}

