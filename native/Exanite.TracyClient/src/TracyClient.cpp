#if defined _WIN32
    #define EXPORT_SYMBOL extern "C" __declspec(dllexport)
#else
    #define EXPORT_SYMBOL extern "C" __attribute__((visibility("default")))
#endif

#define TRACY_ENABLE ON
#define TRACY_ON_DEMAND ON
#define TRACY_CALLSTACK ON
#include <tracy/Tracy.hpp>

// Used to ensure that Tracy's symbols are detected as used and properly exported
EXPORT_SYMBOL int ExportHelper()
{
    TracyNoop;
}
