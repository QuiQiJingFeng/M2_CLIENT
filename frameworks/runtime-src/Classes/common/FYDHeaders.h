//
//  FYDHeaders.h
//  Email
//
//  Created by JingFeng on 2018/6/23.
//  Copyright © 2018年 JingFeng. All rights reserved.
//

#ifndef FYDHeaders_h
#define FYDHeaders_h

#define NS_FYD_BEGIN namespace FYD {
#define NS_FYD_ENDED }
#define USING_NS_FYD using namespace FYD;


#include <assert.h>

#define FYDASSERT(cond,msg) do {\
    if (!(cond)) {\
        if (msg) {\
            printf("Assert failed: %s\n", msg);\
        }\
        assert(cond);\
    } \
} while (0)


#define FYD_SAFE_DELETE(p)           do { delete (p); (p) = nullptr; } while(0)
#define FYD_SAFE_DELETE_ARRAY(p)     do { if(p) { delete[] (p); (p) = nullptr; } } while(0)
#define FYD_SAFE_FREE(p)             do { if(p) { free(p); (p) = nullptr; } } while(0)


// define supported target platform macro which CC uses.
#define FYD_PLATFORM_UNKNOWN            0
#define FYD_PLATFORM_IOS                1
#define FYD_PLATFORM_ANDROID            2
#define FYD_PLATFORM_WIN32              3
#define FYD_PLATFORM_MARMALADE          4
#define FYD_PLATFORM_LINUX              5
#define FYD_PLATFORM_BADA               6
#define FYD_PLATFORM_BLACKBERRY         7
#define FYD_PLATFORM_MAC                8
#define FYD_PLATFORM_NACL               9
#define FYD_PLATFORM_EMSCRIPTEN        10
#define FYD_PLATFORM_TIZEN             11
#define FYD_PLATFORM_QT5               12
#define FYD_PLATFORM_WINRT             13

// Determine target platform by compile environment macro.
#define FYD_TARGET_PLATFORM             FYD_PLATFORM_UNKNOWN

// Apple: Mac and iOS
#if defined(__APPLE__) && !defined(ANDROID) // exclude android for binding generator.
#include <TargetConditionals.h>
#if TARGET_OS_IPHONE // TARGET_OS_IPHONE includes TARGET_OS_IOS TARGET_OS_TV and TARGET_OS_WATCH. see TargetConditionals.h
#undef  FYD_TARGET_PLATFORM
#define FYD_TARGET_PLATFORM         FYD_PLATFORM_IOS
#elif TARGET_OS_MAC
#undef  FYD_TARGET_PLATFORM
#define FYD_TARGET_PLATFORM         FYD_PLATFORM_MAC
#endif
#endif

// android
#if defined(ANDROID)
#undef  FYD_TARGET_PLATFORM
#define FYD_TARGET_PLATFORM         FYD_PLATFORM_ANDROID
#endif

// win32
#if defined(_WIN32) && defined(_WINDOWS)
#undef  FYD_TARGET_PLATFORM
#define FYD_TARGET_PLATFORM         FYD_PLATFORM_WIN32
#endif

// linux
#if defined(LINUX) && !defined(__APPLE__)
#undef  FYD_TARGET_PLATFORM
#define FYD_TARGET_PLATFORM         FYD_PLATFORM_LINUX
#endif

// marmalade
#if defined(MARMALADE)
#undef  FYD_TARGET_PLATFORM
#define FYD_TARGET_PLATFORM         FYD_PLATFORM_MARMALADE
#endif

// bada
#if defined(SHP)
#undef  FYD_TARGET_PLATFORM
#define FYD_TARGET_PLATFORM         FYD_PLATFORM_BADA
#endif

// qnx
#if defined(__QNX__)
#undef  FYD_TARGET_PLATFORM
#define FYD_TARGET_PLATFORM     FYD_PLATFORM_BLACKBERRY
#endif

// native client
#if defined(__native_client__)
#undef  FYD_TARGET_PLATFORM
#define FYD_TARGET_PLATFORM     FYD_PLATFORM_NACL
#endif

// Emscripten
#if defined(EMSCRIPTEN)
#undef  FYD_TARGET_PLATFORM
#define FYD_TARGET_PLATFORM     FYD_PLATFORM_EMSCRIPTEN
#endif

// tizen
#if defined(TIZEN)
#undef  FYD_TARGET_PLATFORM
#define FYD_TARGET_PLATFORM     FYD_PLATFORM_TIZEN
#endif

// qt5
#if defined(FYD_TARGET_QT5)
#undef  FYD_TARGET_PLATFORM
#define FYD_TARGET_PLATFORM     FYD_PLATFORM_QT5
#endif

// WinRT (Windows 8.1 Store/Phone App)
#if defined(WINRT)
#undef  FYD_TARGET_PLATFORM
#define FYD_TARGET_PLATFORM          FYD_PLATFORM_WINRT
#endif

//////////////////////////////////////////////////////////////////////////
// post configure
//////////////////////////////////////////////////////////////////////////

// check user set platform
#if ! FYD_TARGET_PLATFORM
#error  "Cannot recognize the target platform; are you targeting an unsupported platform?"
#endif

#if (FYD_TARGET_PLATFORM == FYD_PLATFORM_WIN32)
#ifndef __MINGW32__
#pragma warning (disable:4127)
#endif
#endif  // FYD_PLATFORM_WIN32

#if ((FYD_TARGET_PLATFORM == FYD_PLATFORM_ANDROID) || (FYD_TARGET_PLATFORM == FYD_PLATFORM_IOS) || (FYD_TARGET_PLATFORM == FYD_PLATFORM_TIZEN))
#define FYD_PLATFORM_MOBILE
#else
#define FYD_PLATFORM_PC
#endif



#endif /* FYDHeaders_h */
