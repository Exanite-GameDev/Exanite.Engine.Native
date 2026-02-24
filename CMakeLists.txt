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

# --- Debug ---

# Hardcoded AddressSanitizer toggle
if(OFF)
    add_compile_options(-fsanitize=address)
    add_link_options(-fsanitize=address)
endif()

# ----- Third party -----

add_subdirectory(./native/Exanite.Tracy)
add_subdirectory(./native/Exanite.VulkanMemoryAllocator)

# ----- First party -----

add_subdirectory(./native/Exanite.TestProject)
add_subdirectory(./native/Exanite.SlangTestProject)

# ----- Call all find modules -----

# This is so that the targets always exist

find_package(FreeType REQUIRED)
find_package(HarfBuzz REQUIRED)
find_package(Slang REQUIRED)
find_package(Tracy REQUIRED)
find_package(TracyProfiler REQUIRED)
find_package(Vulkan REQUIRED)
find_package(VulkanMemoryAllocator REQUIRED)
