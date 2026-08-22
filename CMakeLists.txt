cmake_minimum_required(VERSION 3.28)
project(Exanite.GameDev LANGUAGES CXX)

# ----- First party configuration -----

# These settings do not directly affect external projects
# Use the toolchain file to set options that affect both first party and external projects

# Import utilities
include(ExternalProject)
include(GNUInstallDirs)

# Define DEBUG symbol if build configuration is Debug
if(CMAKE_BUILD_TYPE STREQUAL "Debug")
    add_compile_definitions(DEBUG)
endif()

# These variables represents which install folder binaries are output to
if(WIN32)
    set(EXANITE_EXECUTABLE_INSTALL_DIR ${CMAKE_INSTALL_BINDIR})
    set(EXANITE_IMPORT_LIBRARY_INSTALL_DIR ${CMAKE_INSTALL_LIBDIR})
    set(EXANITE_SHARED_LIBRARY_INSTALL_DIR ${CMAKE_INSTALL_BINDIR})
    set(EXANITE_STATIC_LIBRARY_INSTALL_DIR ${CMAKE_INSTALL_LIBDIR})
else()
    set(EXANITE_EXECUTABLE_INSTALL_DIR ${CMAKE_INSTALL_BINDIR})
    set(EXANITE_IMPORT_LIBRARY_INSTALL_DIR ${CMAKE_INSTALL_LIBDIR})
    set(EXANITE_SHARED_LIBRARY_INSTALL_DIR ${CMAKE_INSTALL_LIBDIR})
    set(EXANITE_STATIC_LIBRARY_INSTALL_DIR ${CMAKE_INSTALL_LIBDIR})
endif()

# Include repo specific utilities
include(cmake/utility/CopySharedLibrariesToExecutable.cmake)
include(cmake/external/ExternalProjectArgs.cmake)

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

add_subdirectory(./projects/Exanite.FreeType)
add_subdirectory(./projects/Exanite.Tracy)
add_subdirectory(./projects/Exanite.VulkanMemoryAllocator)

# ----- First party -----

add_subdirectory(./projects/Exanite.CppScratchpad)
add_subdirectory(./projects/Exanite.SlangScratchpad)
add_subdirectory(./projects/Exanite.TypographyScratchpad)

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
        Exanite.CppScratchpad
        Exanite.SlangScratchpad
        Exanite.TypographyScratchpad
)

add_custom_target(AllTargets
    DEPENDS
        Exanite.All
        External.All
)
