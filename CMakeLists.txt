cmake_minimum_required(VERSION 3.28)
project(Exanite.GameDev.Native LANGUAGES CXX)

# From https://github.com/DenizThatMenace/More-Modern-CMake/blob/master/example-3.12/CMakeLists.txt
# Always use '-fPIC'/'-fPIE' option.
set(CMAKE_POSITION_INDEPENDENT_CODE ON)

# --- Third party ---

# Vulkan
find_package(Vulkan REQUIRED)

# VulkanMemoryAllocator
add_library(VulkanMemoryAllocator INTERFACE)
target_include_directories(VulkanMemoryAllocator INTERFACE native/VulkanMemoryAllocator/include)

include(FetchContent)
FetchContent_Declare(SPIRV-Cross
    GIT_REPOSITORY https://github.com/KhronosGroup/SPIRV-Cross.git
    GIT_TAG vulkan-sdk-1.3.290.0 # match the least sdk
    UPDATE_DISCONNECTED TRUE
    GIT_PROGRESS TRUE
)
set(SPIRV_CROSS_CLI OFF)
set(SPIRV_CROSS_ENABLE_TESTS OFF)
FetchContent_MakeAvailable(SPIRV-Cross)

# --- First party ---

# Exanite.TestProject
add_subdirectory(native/Exanite.TestProject)
