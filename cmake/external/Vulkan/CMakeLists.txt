add_library(Imported.Vulkan.Headers INTERFACE)
target_include_directories(Imported.Vulkan.Headers INTERFACE ${CMAKE_SOURCE_DIR}/native/Vulkan-Headers/include)
