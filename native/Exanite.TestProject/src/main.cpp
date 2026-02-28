#include <chrono>
#include <iostream>
#include <thread>
#include <Exanite/Tracy/Tracy.h>
#include <Exanite/FreeType/FreeType.h>

void guardSuccessFreeType(int result)
{
    if (result != 0)
    {
        throw std::runtime_error("Error while calling FreeType function: " + std::string(FT_Error_String(result)));
    }
}

int main()
{
    FT_Library library;
    guardSuccessFreeType(FT_Init_FreeType(&library));

    // Yay they match now
    int size = sizeof(FT_FaceRec); // 248 on Windows, 248 on Linux
    int sizeShort = sizeof(FT_Short); // 2 on Windows, 2 on Linux
    int sizeInt = sizeof(FT_Int); // 4 on Windows, 4 on Linux
    int sizeLong = sizeof(FT_Long); // 8 on Windows, 8 on Linux
    int offset = offsetof(FT_FaceRec, glyph); // 152 on Windows, 152 on Linux
}

[[noreturn]] void main_tracy()
{
    while (!___tracy_connected())
    {
        std::cout << "Waiting for connection from Tracy UI" << std::endl;

        std::this_thread::sleep_for(std::chrono::seconds(1));
    }

    std::cout << "Connected!" << std::endl;

    auto start = std::chrono::steady_clock::now();
    const auto nanoSecondsPerSecond = 1000000000.0f;

    // Initialize CPU timeline
    ___tracy_set_thread_name("Main");

    // Initialize GPU timeline
    auto context = 0;
    ___tracy_emit_gpu_new_context_serial(___tracy_gpu_new_context_data(0, 1, context, 0, 2));
    ___tracy_emit_gpu_context_name(___tracy_gpu_context_name_data(context, "Graphics", 8));

    while (true)
    {
        // Mark start of frame
        ___tracy_emit_frame_mark("Main");

        // Simulate CPU work
        {
            auto cpuSource = ___tracy_alloc_srcloc_name(1, "hello-cpu.cpp", 13, "cpu1", 4, 0, 0, 0);
            auto zone = ___tracy_emit_zone_begin_alloc(cpuSource, 1);
            {
                std::this_thread::sleep_for(std::chrono::milliseconds(500));
            }
            ___tracy_emit_zone_end(zone);
        }

        // Simulate GPU work
        auto simulatedGpuTime = static_cast<float>(std::chrono::duration_cast<std::chrono::nanoseconds>(std::chrono::steady_clock::now() - start).count());
        auto startQueryId = 0;
        auto endQueryId = 1;
        auto gpuSource = ___tracy_alloc_srcloc_name(123, "hello-gpu.cpp", 13, "gpu", 3, 0, 0, 0);
        ___tracy_emit_gpu_zone_begin_alloc_serial(___tracy_gpu_zone_begin_data(gpuSource, startQueryId, context));
        {
            // Simulate recording time
            {
                auto cpuSource = ___tracy_alloc_srcloc_name(2, "hello-cpu.cpp", 13, "cpu2", 4, 0, 0, 0);
                auto zone = ___tracy_emit_zone_begin_alloc(cpuSource, 1);
                {
                    std::this_thread::sleep_for(std::chrono::milliseconds(100));
                }
                ___tracy_emit_zone_end(zone);
            }
        }
        ___tracy_emit_gpu_zone_end_serial(___tracy_gpu_zone_end_data(endQueryId, context));

        // Simulate CPU work
        {
            auto cpuSource = ___tracy_alloc_srcloc_name(3, "hello-cpu.cpp", 13, "cpu3", 4, 0, 0, 0);
            auto zone = ___tracy_emit_zone_begin_alloc(cpuSource, 1);
            {
                std::this_thread::sleep_for(std::chrono::milliseconds(500));
            }
            ___tracy_emit_zone_end(zone);
        }

        // Submit GPU timestamps
        ___tracy_emit_gpu_time_serial(___tracy_gpu_time_data(static_cast<int64_t>(simulatedGpuTime + 0.2f * nanoSecondsPerSecond), startQueryId, context));
        ___tracy_emit_gpu_time_serial(___tracy_gpu_time_data(static_cast<int64_t>(simulatedGpuTime + 0.4f * nanoSecondsPerSecond), endQueryId, context));
    }
}
