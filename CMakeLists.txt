cmake_minimum_required(VERSION 3.28)
project(Exanite.GameDev.Native LANGUAGES CXX)

# From https://github.com/DenizThatMenace/More-Modern-CMake/blob/master/example-3.12/CMakeLists.txt
# Always use '-fPIC'/'-fPIE' option.
set(CMAKE_POSITION_INDEPENDENT_CODE ON)

# CPM
include(cmake/CPM.cmake)

# --- Third party ---

# Vulkan
find_package(Vulkan REQUIRED)

# VulkanMemoryAllocator
add_library(VulkanMemoryAllocator INTERFACE)
target_include_directories(VulkanMemoryAllocator INTERFACE native/VulkanMemoryAllocator/include)

# SPIRV-Cross
CPMAddPackage(
    NAME SPIRV-Cross
    GIT_REPOSITORY https://github.com/KhronosGroup/SPIRV-Cross.git
    GIT_TAG vulkan-sdk-1.3.296
)

# SPIRV-Reflect
CPMAddPackage(
    NAME SPIRV-Reflect
    GIT_REPOSITORY https://github.com/KhronosGroup/SPIRV-Reflect.git
    GIT_TAG vulkan-sdk-1.3.296
)

# --- First party ---

# Exanite.TestProject
add_subdirectory(native/Exanite.TestProject)
