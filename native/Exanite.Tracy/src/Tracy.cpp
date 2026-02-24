#include <Exanite/Tracy.h>
#include <tracy/Tracy.hpp>

extern "C"
{
    // Not actually needed. Keeping as reference for how to add a custom export.
    // int64_t ___tracy_get_time()
    // {
    //     return tracy::Profiler::GetTime();
    // }
}
