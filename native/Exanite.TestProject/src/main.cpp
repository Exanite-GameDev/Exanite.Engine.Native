#include <iostream>
#include <unistd.h>
#include <Exanite/Tracy.h>

typedef struct UIntBitfield {
    int bits : 8;
    char bits1 : 8;
    unsigned int bits2 : 8;
    unsigned char bits3 : 8;
} UIntBitfield;

int main()
{
    std::cout << sizeof(UIntBitfield) << std::endl;
    std::cout << ___tracy_get_time() << std::endl;
    std::cout << ___tracy_connected() << std::endl;

    while (!___tracy_connected())
    {
        std::cout << "Waiting for connection from Tracy UI" << std::endl;

        sleep(1);
    }

    std::cout << "Connected!" << std::endl;

    ___tracy_set_thread_name("Main");

    {
        auto source = ___tracy_alloc_srcloc(123, "hello-cpu.cpp", 13, "cpu", 3, 0);
        auto zone = ___tracy_emit_zone_begin_alloc(source, 1);
        {
            sleep(1);
        }
        ___tracy_emit_zone_end(zone);
    }

    auto context = 0;
    auto startQueryId = 0;
    auto endQueryId = 1;
    auto nanoSecondsPerSecond = 1000000000.0f;

    // Create context
    ___tracy_emit_gpu_new_context_serial(___tracy_gpu_new_context_data(static_cast<int64_t>(0.25f * nanoSecondsPerSecond), 1, context, 0, 0));
    ___tracy_emit_gpu_context_name(___tracy_gpu_context_name_data(context, "Graphics", 8));
    ___tracy_emit_gpu_time_sync_serial(___tracy_gpu_time_sync_data(static_cast<int64_t>(0.5f * nanoSecondsPerSecond), context));

    // Create GPU zone
    {
        auto source = ___tracy_alloc_srcloc(123, "hello-gpu.cpp", 13, "gpu", 3, 0);
        ___tracy_emit_gpu_zone_begin_alloc_serial(___tracy_gpu_zone_begin_data(source, startQueryId, context));
        ___tracy_emit_gpu_zone_end_serial(___tracy_gpu_zone_end_data(endQueryId, context));
    }

    // Emit data
    ___tracy_emit_gpu_time_serial(___tracy_gpu_time_data(static_cast<int64_t>(1.0f * nanoSecondsPerSecond), startQueryId, context));
    ___tracy_emit_gpu_time_serial(___tracy_gpu_time_data(static_cast<int64_t>(2.0f * nanoSecondsPerSecond), endQueryId, context));

    sleep(1);

    return 0;
}
