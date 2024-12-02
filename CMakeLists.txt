cmake_minimum_required(VERSION 3.28)
project(Exanite.GameDev.Native LANGUAGES CXX)

# From https://github.com/DenizThatMenace/More-Modern-CMake/blob/master/example-3.12/CMakeLists.txt
# Always use '-fPIC'/'-fPIE' option.
set(CMAKE_POSITION_INDEPENDENT_CODE ON)

# --- Projects ---

# Vulkan
find_package(Vulkan REQUIRED)

# VulkanMemoryAllocator
add_library(VulkanMemoryAllocator INTERFACE)
target_include_directories(VulkanMemoryAllocator INTERFACE native/VulkanMemoryAllocator/include)

# Exanite.TestProject
add_subdirectory(${CMAKE_CURRENT_LIST_DIR}/native/Exanite.TestProject ${CMAKE_BINARY_DIR}/Exanite.TestProject)
