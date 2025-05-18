cmake_minimum_required(VERSION 3.28)
project(Exanite.GameDev LANGUAGES CXX)

# ----- Project wide configuration -----

# --- CMake options ---

# Set option variable policy
# The NEW policy enables the use of the option() function
cmake_policy(SET CMP0077 NEW)
set(CMAKE_POLICY_DEFAULT_CMP0077 NEW)

if (CMAKE_BUILD_TYPE STREQUAL "Debug")
    add_compile_definitions(DEBUG)
endif()

# --- Compilation options ---

# Enable architecture specific optimizations
if (CMAKE_CXX_COMPILER_ID STREQUAL "GNU" OR CMAKE_CXX_COMPILER_ID STREQUAL "Clang")
    add_compile_options(-march=native)
endif()

# --- Linking options ---

# This allows shared libraries to be loaded at different memory addresses
set(CMAKE_POSITION_INDEPENDENT_CODE ON)

#if (NOT (CMAKE_BUILD_TYPE STREQUAL "Debug"))
#    # Set IPO policy
#    # The NEW policy enables IPO flags for all compilers if possible and to error if not
#    # We check for compatibility below so using the new policy is safe
#    cmake_policy(SET CMP0069 NEW)
#    set(CMAKE_POLICY_DEFAULT_CMP0069 NEW)
#
#    # Enable Inter-Procedural Optimization (IPO) if supported by the compiler
#    include(CheckIPOSupported)
#    check_ipo_supported(RESULT IS_IPO_SUPPORTED)
#    if((IS_IPO_SUPPORTED) AND NOT (CMAKE_CXX_COMPILER_ID STREQUAL "MSVC"))
#        set(CMAKE_INTERPROCEDURAL_OPTIMIZATION ON)
#    endif()
#endif()

# --- Output options ---

# This postfixes a "d" to shared library names in DEBUG mode
set(CMAKE_DEBUG_POSTFIX d)

# Globally disable shared library prefix for Windows
if (WIN32)
    set(CMAKE_SHARED_LIBRARY_PREFIX "")
endif()

# --- Windows ---

# Target Windows 10 or later
# See: https://learn.microsoft.com/en-us/cpp/porting/modifying-winver-and-win32-winnt
if (WIN32)
    add_definitions(-D_WIN32_WINNT=0x0A00)
endif()

# --- Linux ---

# Use ccache when possible to reduce compilation times
find_program(CCACHE_PROGRAM ccache)
if(CCACHE_PROGRAM)
    message(STATUS "Ccache found: ${CCACHE_PROGRAM}")
    set(CMAKE_C_COMPILER_LAUNCHER ${CCACHE_PROGRAM})
    set(CMAKE_CXX_COMPILER_LAUNCHER ${CCACHE_PROGRAM})
endif()

# Use mold linker when possible to reduce linking times
find_program(MOLD_LINKER mold)
if (MOLD_LINKER)
    message(STATUS "Mold linker found: ${MOLD_LINKER}")
    set(CMAKE_CXX_LINKER_FLAGS "${CMAKE_CXX_LINKER_FLAGS} -fuse-ld=mold")
    set(CMAKE_EXE_LINKER_FLAGS "${CMAKE_EXE_LINKER_FLAGS} -fuse-ld=mold")
    set(CMAKE_SHARED_LINKER_FLAGS "${CMAKE_SHARED_LINKER_FLAGS} -fuse-ld=mold")
endif()

# --- Debug ---

# Hardcoded AddressSanitizer toggle
if (OFF)
    add_compile_options(-fsanitize=address)
    add_link_options(-fsanitize=address)
endif()

# ----- Third party -----

# Vulkan
find_package(Vulkan REQUIRED)

# VulkanMemoryAllocator
add_library(vma SHARED)
add_library(VulkanMemoryAllocator ALIAS vma)

set_target_properties(vma PROPERTIES LINKER_LANGUAGE CXX)
target_include_directories(vma PUBLIC native/VulkanMemoryAllocator/include)
target_sources(vma PUBLIC native/VulkanMemoryAllocator/include/vk_mem_alloc.h)

## Slang
#if (WIN32)
#    FetchContent_Declare(
#        slang_binaries
#        URL https://github.com/shader-slang/slang/releases/download/v2024.15/slang-2024.15-windows-x86_64.zip
#    )
#    FetchContent_MakeAvailable(slang_binaries)
#    add_library(slang SHARED IMPORTED)
#    set_target_properties(
#        slang
#        PROPERTIES
#            IMPORTED_LOCATION ${slang_binaries_SOURCE_DIR}/bin/slang.dll
#            IMPORTED_IMPLIB ${slang_binaries_SOURCE_DIR}/lib/slang.lib
#            INTERFACE_INCLUDE_DIRECTORIES ${slang_binaries_SOURCE_DIR}/include
#    )
#endif()
#
#if (UNIX)
#    FetchContent_Declare(
#        slang_binaries
#        URL https://github.com/shader-slang/slang/releases/download/v2024.15/slang-2024.15-linux-x86_64.zip
#    )
#    FetchContent_MakeAvailable(slang_binaries)
#    add_library(slang SHARED IMPORTED)
#    set_target_properties(
#        slang
#        PROPERTIES
#            IMPORTED_LOCATION ${slang_binaries_SOURCE_DIR}/lib/libslang.so
#            IMPORTED_IMPLIB ${slang_binaries_SOURCE_DIR}/lib/libslang.so
#            INTERFACE_INCLUDE_DIRECTORIES ${slang_binaries_SOURCE_DIR}/include
#    )
#endif ()
#
## DirectXShaderCompiler
#if (WIN32)
#    FetchContent_Declare(
#        dxc_binaries
#        URL https://github.com/microsoft/DirectXShaderCompiler/releases/download/v1.8.2407/dxc_2024_07_31.zip
#    )
#    FetchContent_MakeAvailable(dxc_binaries)
#    add_library(dxc SHARED IMPORTED)
#    set_target_properties(
#        dxc
#        PROPERTIES
#            IMPORTED_LOCATION ${dxc_binaries_SOURCE_DIR}/bin/x64/dxcompiler.dll
#            IMPORTED_IMPLIB ${dxc_binaries_SOURCE_DIR}/lib/x64/dxcompiler.lib
#            INTERFACE_INCLUDE_DIRECTORIES ${dxc_binaries_SOURCE_DIR}/inc
#    )
#endif ()
#
#if (UNIX)
#    FetchContent_Declare(
#        dxc_binaries
#        URL https://github.com/microsoft/DirectXShaderCompiler/releases/download/v1.8.2407/linux_dxc_2024_07_31.x86_64.tar.gz
#    )
#    FetchContent_MakeAvailable(dxc_binaries)
#    add_library(dxc SHARED IMPORTED)
#    set_target_properties(
#        dxc
#        PROPERTIES
#            IMPORTED_LOCATION ${dxc_binaries_SOURCE_DIR}/lib/libdxcompiler.so
#            IMPORTED_IMPLIB ${dxc_binaries_SOURCE_DIR}/lib/libdxcompiler.so
#            INTERFACE_INCLUDE_DIRECTORIES ${dxc_binaries_SOURCE_DIR}/include/dxc
#    )
#endif ()
#
## Zlib, required for DirectXShaderCompiler
#if (UNIX)
#    find_package(ZLIB REQUIRED)
#endif ()
#
## ----- First party -----
#
## Exanite.TestProject
#add_subdirectory(native/Exanite.TestProject)

# ----- Meta -----

add_custom_target(BuildAllNatives ALL
    DEPENDS
        VulkanMemoryAllocator
)