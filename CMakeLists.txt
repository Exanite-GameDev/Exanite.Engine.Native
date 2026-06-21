cmake_minimum_required(VERSION 3.28)
project(Exanite.GameDev LANGUAGES CXX)

# ----- Import utilities -----

# Add ExternalProject support
include(ExternalProject)

# Include repo specific utilities
include(cmake/external/CopySharedLibrariesToExecutable.cmake)
include(cmake/external/ExternalProjectArgs.cmake)

# --- First party compilation options ---
# Note: These do not affect external projects

# Define DEBUG symbol if build configuration is Debug
if(CMAKE_BUILD_TYPE STREQUAL "Debug")
    add_compile_definitions(DEBUG)
endif()

# ----- Third party -----

add_subdirectory(./cmake/external/Brotli)
add_subdirectory(./cmake/external/FreeType)
add_subdirectory(./cmake/external/FreeTypeBootstrap)
add_subdirectory(./cmake/external/HarfBuzz)
add_subdirectory(./cmake/external/LibPng)
add_subdirectory(./cmake/external/Slang)
add_subdirectory(./cmake/external/Tracy)
add_subdirectory(./cmake/external/TracyProfiler)
add_subdirectory(./cmake/external/Vulkan)
add_subdirectory(./cmake/external/VulkanMemoryAllocator)
add_subdirectory(./cmake/external/ZLib)

# ----- Wrappers -----

add_subdirectory(./native/Exanite.FreeType)
add_subdirectory(./native/Exanite.Tracy)
add_subdirectory(./native/Exanite.VulkanMemoryAllocator)

# ----- First party -----

add_subdirectory(./native/Exanite.SlangTestProject)
add_subdirectory(./native/Exanite.TestProject)
add_subdirectory(./native/Exanite.TypographyTestProject)

# ----- Define all target -----

# This is so that Jetbrains IDEs have an explicit "all" target to show

add_custom_target(External.All
    DEPENDS
        External.Brotli
        External.FreeType
        External.FreeTypeBootstrap
        External.HarfBuzz
        External.LibPng
        External.Slang
        External.Tracy
        External.TracyProfiler
        External.ZLib
)

add_custom_target(Exanite.All
    DEPENDS
        Exanite.FreeType
        Exanite.Tracy
        Exanite.VulkanMemoryAllocator
        Exanite.TestProject
        Exanite.SlangTestProject
)

add_custom_target(AllTargets
    DEPENDS
        Exanite.All
        External.All
)
