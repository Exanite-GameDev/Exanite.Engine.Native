#include <Exanite/Tracy.h>
#include <tracy/Tracy.hpp>

extern "C"
{
    int64_t ___tracy_get_time()
    {
        return tracy::Profiler::GetTime();
    }
}
