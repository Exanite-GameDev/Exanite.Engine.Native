#pragma once

#define TRACY_ENABLE

#include <tracy/Tracy.hpp>

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
    EXANITE_TRACY_API int64_t ___tracy_get_time()
    {
        return tracy::Profiler::GetTime();
    }
}
