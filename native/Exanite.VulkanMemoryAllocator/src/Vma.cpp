#if defined _WIN32
    #define VMA_CALL_PRE __declspec(dllexport)
#else
    #define VMA_CALL_PRE __attribute__((visibility("default")))
#endif

#define VMA_IMPLEMENTATION
#include <vk_mem_alloc.h>
