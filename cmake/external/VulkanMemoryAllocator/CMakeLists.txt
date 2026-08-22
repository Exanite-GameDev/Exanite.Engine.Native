# Define relevant folders
set(source_dir ${CMAKE_SOURCE_DIR}/projects/VulkanMemoryAllocator)

# Define target
add_library(Imported.VulkanMemoryAllocator INTERFACE)
target_include_directories(Imported.VulkanMemoryAllocator INTERFACE ${source_dir}/include)

target_link_libraries(Imported.VulkanMemoryAllocator INTERFACE Imported.Vulkan)
