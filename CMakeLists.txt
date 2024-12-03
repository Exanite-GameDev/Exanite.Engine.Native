cmake_minimum_required(VERSION 3.28)
project(Exanite.GameDev.Native LANGUAGES CXX)

# From https://github.com/DenizThatMenace/More-Modern-CMake/blob/master/example-3.12/CMakeLists.txt
# Always use '-fPIC'/'-fPIE' option.
set(CMAKE_POSITION_INDEPENDENT_CODE ON)

# Globally disable library prefix for Windows
if (WIN32)
    set(CMAKE_SHARED_LIBRARY_PREFIX "")
endif()

# Add external project support
include(ExternalProject)

# --- Third party ---

# Vulkan
find_package(Vulkan REQUIRED)

# VulkanMemoryAllocator
add_library(vma SHARED)
add_library(VulkanMemoryAllocator ALIAS vma)

set_target_properties(vma PROPERTIES LINKER_LANGUAGE CXX)
target_include_directories(vma PUBLIC native/VulkanMemoryAllocator/include)
target_sources(vma PUBLIC native/VulkanMemoryAllocator/include/vk_mem_alloc.h)

# Slang
ExternalProject_Add(
    slang_binaries
    URL https://github.com/shader-slang/slang/releases/download/v2024.15/slang-2024.15-windows-x86_64.zip
)
ExternalProject_Get_Property(slang_binaries SOURCE_DIR)
add_library(slang SHARED IMPORTED)
set_target_properties(
    slang
    PROPERTIES
        IMPORTED_LOCATION ${SOURCE_DIR}/bin/slang.dll
        IMPORTED_IMPLIB ${SOURCE_DIR}/lib
        INTERFACE_INCLUDE_DIRECTORIES ${SOURCE_DIR}/include
)

# --- First party ---

# Exanite.TestProject
add_subdirectory(native/Exanite.TestProject)
