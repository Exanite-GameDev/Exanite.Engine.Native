cmake_minimum_required(VERSION 3.28)
project(Exanite.GameDev.Native LANGUAGES CXX)

# From https://github.com/DenizThatMenace/More-Modern-CMake/blob/master/example-3.12/CMakeLists.txt
# Always use '-fPIC'/'-fPIE' option.
set(CMAKE_POSITION_INDEPENDENT_CODE ON)

# --- Third party ---

# Vulkan
find_package(Vulkan REQUIRED)

# VulkanMemoryAllocator
add_library(VulkanMemoryAllocator SHARED)
set_target_properties(VulkanMemoryAllocator PROPERTIES LINKER_LANGUAGE CXX)
target_include_directories(VulkanMemoryAllocator PUBLIC native/VulkanMemoryAllocator/include)
target_sources(VulkanMemoryAllocator PUBLIC native/VulkanMemoryAllocator/include/vk_mem_alloc.h)

# --- First party ---

# Exanite.TestProject
add_subdirectory(native/Exanite.TestProject)
