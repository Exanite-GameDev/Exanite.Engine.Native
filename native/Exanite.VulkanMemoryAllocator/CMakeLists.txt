cmake_minimum_required(VERSION 3.28)
project(Exanite.VulkanMemoryAllocator LANGUAGES CXX)

# --- Dependencies ---

find_package(Vulkan REQUIRED)
find_package(VulkanMemoryAllocator REQUIRED)

# --- Build ---

add_library(vma SHARED)
add_library(Exanite::VulkanMemoryAllocator ALIAS vma)
set_target_properties(vma
    PROPERTIES
        CXX_STANDARD 23
        OUTPUT_NAME "vma"
)

file(GLOB sources CONFIGURE_DEPENDS src/*.cpp)
target_sources(vma PRIVATE ${sources})

target_link_libraries(vma PRIVATE Vulkan::Vulkan)
target_link_libraries(vma PRIVATE Exanite::VulkanMemoryAllocator-Headers)
