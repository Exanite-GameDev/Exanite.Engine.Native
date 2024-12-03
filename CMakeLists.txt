cmake_minimum_required(VERSION 3.28)
project(Exanite.GameDev.Native LANGUAGES CXX)

# From https://github.com/DenizThatMenace/More-Modern-CMake/blob/master/example-3.12/CMakeLists.txt
# Always use '-fPIC'/'-fPIE' option.
set(CMAKE_POSITION_INDEPENDENT_CODE ON)

# Globally disable library prefix for Windows
if (WIN32)
    set(CMAKE_SHARED_LIBRARY_PREFIX "")
endif()

# --- Third party ---

# Vulkan
find_package(Vulkan REQUIRED)

# VulkanMemoryAllocator
add_library(vma SHARED)
add_library(VulkanMemoryAllocator ALIAS vma)

set_target_properties(vma PROPERTIES LINKER_LANGUAGE CXX)
target_include_directories(vma PUBLIC native/VulkanMemoryAllocator/include)
target_sources(vma PUBLIC native/VulkanMemoryAllocator/include/vk_mem_alloc.h)


# --- First party ---

# Exanite.TestProject
add_subdirectory(native/Exanite.TestProject)
