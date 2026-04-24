add_library(Exanite.VulkanMemoryAllocator SHARED)
set_target_properties(Exanite.VulkanMemoryAllocator
    PROPERTIES
        CXX_STANDARD 23
        OUTPUT_NAME "ExaniteVulkanMemoryAllocator"
)

file(GLOB sources CONFIGURE_DEPENDS src/*.cpp)
target_sources(Exanite.VulkanMemoryAllocator PRIVATE ${sources})

target_link_libraries(Exanite.VulkanMemoryAllocator PRIVATE Imported.VulkanMemoryAllocator)
