cmake_minimum_required(VERSION 3.28)
project(Exanite.GameDev LANGUAGES CXX)

# ----- Project wide configuration -----

# Tell CMake where to find CMake find modules
list(APPEND CMAKE_MODULE_PATH ${CMAKE_CURRENT_SOURCE_DIR}/cmake)

# Add ExternalProject support
include(ExternalProject)

# --- Compilation options ---

# Define DEBUG symbol if build configuration is Debug
if(CMAKE_BUILD_TYPE STREQUAL "Debug")
    add_compile_definitions(DEBUG)
endif()

# --- Linking options ---

# Currently none

# --- Output options ---

# Currently none

# --- Debug ---

# Hardcoded AddressSanitizer toggle
if(OFF)
    add_compile_options(-fsanitize=address)
    add_link_options(-fsanitize=address)
endif()

# ----- Third party -----

add_subdirectory(./native/Exanite.FreeType)
add_subdirectory(./native/Exanite.Tracy)
add_subdirectory(./native/Exanite.VulkanMemoryAllocator)

# ----- First party -----

add_subdirectory(./native/Exanite.TestProject)
add_subdirectory(./native/Exanite.SlangTestProject)

# ----- Include find modules -----

# This is so that the targets always exist

find_package(BZip2 REQUIRED)
find_package(Brotli REQUIRED)
find_package(FreeType REQUIRED)
find_package(HarfBuzz REQUIRED)
find_package(LibPng REQUIRED)
find_package(Slang REQUIRED)
find_package(Tracy REQUIRED)
find_package(TracyProfiler REQUIRED)
find_package(Vulkan REQUIRED)
find_package(VulkanMemoryAllocator REQUIRED)
find_package(ZLib REQUIRED)

# ----- Define all target -----

# This is so that Jetbrains IDEs have an explicit "all" target to show

add_custom_target(AllTargets
    DEPENDS
        Exanite.FreeType
        Exanite.Tracy
        Exanite.VulkanMemoryAllocator
        Exanite.TestProject
        Exanite.SlangTestProject
        External.BZip2
        External.Brotli
        External.FreeType
        External.HarfBuzz
        External.LibPng
        External.Slang
        External.Tracy
        External.TracyProfiler
        External.ZLib
)
