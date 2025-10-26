cmake_minimum_required(VERSION 3.28)
project(Exanite.VulkanMemoryAllocator LANGUAGES CXX)

# --- Dependencies ---

find_package(VulkanMemoryAllocator REQUIRED)

# --- Build ---

add_library(Exanite.VulkanMemoryAllocator SHARED)
add_library(Exanite::VulkanMemoryAllocator ALIAS Exanite.VulkanMemoryAllocator)
set_target_properties(Exanite.VulkanMemoryAllocator
    PROPERTIES
        CXX_STANDARD 23
        OUTPUT_NAME "vma"
)

file(GLOB sources CONFIGURE_DEPENDS src/*.cpp)
target_sources(Exanite.VulkanMemoryAllocator PRIVATE ${sources})

target_link_libraries(Exanite.VulkanMemoryAllocator PRIVATE Exanite::VulkanMemoryAllocator-Headers)
