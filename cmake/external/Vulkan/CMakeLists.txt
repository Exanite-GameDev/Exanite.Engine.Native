# Define relevant folders
set(source_dir ${CMAKE_SOURCE_DIR}/projects/Vulkan-Headers)

# Define target
add_library(Imported.Vulkan INTERFACE)
target_include_directories(Imported.Vulkan INTERFACE ${source_dir}/include)
