cmake_minimum_required(VERSION 3.28)
project(Exanite.GameDev.Native LANGUAGES CXX)

# From https://github.com/DenizThatMenace/More-Modern-CMake/blob/master/example-3.12/CMakeLists.txt
# Always use '-fPIC'/'-fPIE' option.
set(CMAKE_POSITION_INDEPENDENT_CODE ON)

# Globally disable library prefix for Windows
if (WIN32)
    set(CMAKE_SHARED_LIBRARY_PREFIX "")
endif()

# Add FetchContent module
include(FetchContent)

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
FetchContent_Declare(
    slang_binaries
    URL https://github.com/shader-slang/slang/releases/download/v2024.15/slang-2024.15-windows-x86_64.zip
)
FetchContent_MakeAvailable(slang_binaries)
add_library(slang SHARED IMPORTED)
set_target_properties(
    slang
    PROPERTIES
        IMPORTED_LOCATION ${slang_binaries_SOURCE_DIR}/bin/slang.dll
        IMPORTED_IMPLIB ${slang_binaries_SOURCE_DIR}/lib/slang.lib
        INTERFACE_INCLUDE_DIRECTORIES ${slang_binaries_SOURCE_DIR}/include
)

# DirectXShaderCompiler
FetchContent_Declare(
    dxc_binaries
    URL https://github.com/microsoft/DirectXShaderCompiler/releases/download/v1.8.2407/dxc_2024_07_31.zip
)
FetchContent_MakeAvailable(dxc_binaries)
add_library(dxc SHARED IMPORTED)
set_target_properties(
    dxc
    PROPERTIES
    IMPORTED_LOCATION ${dxc_binaries_SOURCE_DIR}/bin/dxcapi.dll
    IMPORTED_IMPLIB ${dxc_binaries_SOURCE_DIR}/lib/dxcapi.lib
    INTERFACE_INCLUDE_DIRECTORIES ${dxc_binaries_SOURCE_DIR}/include
)

# --- First party ---

# Exanite.TestProject
add_subdirectory(native/Exanite.TestProject)
