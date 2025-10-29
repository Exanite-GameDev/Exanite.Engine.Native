cmake_minimum_required(VERSION 3.28)
project(Exanite.GameDev LANGUAGES CXX)

# ----- Project wide configuration -----

# --- CMake options ---

# Set option variable policy
# The NEW policy enables the use of the option() function
cmake_policy(SET CMP0077 NEW)
set(CMAKE_POLICY_DEFAULT_CMP0077 NEW)

# Set IPO policy
# The NEW policy enables IPO flags for all compilers if possible and to error if not
# We check for compatibility below so using the new policy is safe
cmake_policy(SET CMP0069 NEW)
set(CMAKE_POLICY_DEFAULT_CMP0069 NEW)

# Tell CMake where to find CMake find modules
list(APPEND CMAKE_MODULE_PATH ${CMAKE_CURRENT_SOURCE_DIR}/cmake)

# --- Compilation options ---

# Define DEBUG symbol if build configuration is Debug
if(CMAKE_BUILD_TYPE STREQUAL "Debug")
    add_compile_definitions(DEBUG)
endif()

# Enable architecture specific optimizations
if(CMAKE_CXX_COMPILER_ID STREQUAL "GNU" OR CMAKE_CXX_COMPILER_ID STREQUAL "Clang")
    add_compile_options(-march=native)
endif()

# Compile as a universal dylib for Mac
if(APPLE)
    set(CMAKE_OSX_ARCHITECTURES "arm64;x86_64")
    set(CMAKE_OSX_DEPLOYMENT_TARGET "10.15")
endif()

# --- Linking options ---

# This allows shared libraries to be loaded at different memory addresses
set(CMAKE_POSITION_INDEPENDENT_CODE ON)

# Warning: IPO is extremely slow and will slow down iteration times
if(NOT (CMAKE_BUILD_TYPE STREQUAL "Debug"))
    # Enable Inter-Procedural Optimization (IPO) if supported by the compiler
    include(CheckIPOSupported)
    check_ipo_supported(RESULT IS_IPO_SUPPORTED)
    if((IS_IPO_SUPPORTED) AND NOT (CMAKE_CXX_COMPILER_ID STREQUAL "MSVC"))
        set(CMAKE_INTERPROCEDURAL_OPTIMIZATION ON)
    endif()
endif()

# Use shared libraries by default
set(BUILD_SHARED_LIBS ON CACHE BOOL "Build shared libraries by default")

# --- Output options ---

# This postfixes a "d" to shared library names in DEBUG mode
set(CMAKE_DEBUG_POSTFIX d)

# Globally disable shared library prefix for Windows
if(WIN32)
    set(CMAKE_SHARED_LIBRARY_PREFIX "")
endif()

# --- Windows ---

# Target Windows 10 or later
# See: https://learn.microsoft.com/en-us/cpp/porting/modifying-winver-and-win32-winnt
if(WIN32)
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
if(MOLD_LINKER)
    message(STATUS "Mold linker found: ${MOLD_LINKER}")
    set(CMAKE_CXX_LINKER_FLAGS "${CMAKE_CXX_LINKER_FLAGS} -fuse-ld=mold")
    set(CMAKE_EXE_LINKER_FLAGS "${CMAKE_EXE_LINKER_FLAGS} -fuse-ld=mold")
    set(CMAKE_SHARED_LINKER_FLAGS "${CMAKE_SHARED_LINKER_FLAGS} -fuse-ld=mold")
endif()

# --- Debug ---

# Hardcoded AddressSanitizer toggle
if(OFF)
    add_compile_options(-fsanitize=address)
    add_link_options(-fsanitize=address)
endif()

# ----- Third party -----

if(NOT APPLE)
    add_subdirectory(./native/Exanite.TracyClient)
endif()

add_subdirectory(./native/Exanite.VulkanMemoryAllocator)

# ----- First party -----

add_subdirectory(./native/Exanite.TestProject)
add_subdirectory(./native/Exanite.SlangTestProject)
