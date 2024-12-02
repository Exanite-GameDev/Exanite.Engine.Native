cmake_minimum_required(VERSION 3.28)
project(Exanite.TestProject LANGUAGES CXX)

# --- Build ---

add_executable(${PROJECT_NAME})
set_target_properties(${PROJECT_NAME} PROPERTIES CXX_STANDARD 23 OUTPUT_NAME "Exanite.TestProject")

file(GLOB sources CONFIGURE_DEPENDS ${CMAKE_CURRENT_SOURCE_DIR}/src/*.cpp)
target_sources(${PROJECT_NAME} PRIVATE ${sources})

target_link_libraries(${PROJECT_NAME} PRIVATE Vulkan::Vulkan)
target_link_libraries(${PROJECT_NAME} PRIVATE VulkanMemoryAllocator)
