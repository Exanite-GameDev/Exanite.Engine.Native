#pragma once

#define TRACY_ENABLE
#define TRACY_ON_DEMAND

#include <tracy/TracyC.h>

#if defined(_WIN32)
    #if defined(EXANITE_TRACY_EXPORT)
        #define EXANITE_TRACY_API __declspec(dllexport)
    #else
        #define EXANITE_TRACY_API __declspec(dllimport)
    #endif
#else
    #define EXANITE_TRACY_API __attribute__((visibility("default")))
#endif

extern "C"
{
    // Not actually needed. Keeping as reference for how to add a custom export.
    // EXANITE_TRACY_API int64_t ___tracy_get_time();
}
