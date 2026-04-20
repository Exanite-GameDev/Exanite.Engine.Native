add_library(Imported.Vulkan.Headers INTERFACE)
target_include_directories(Imported.Vulkan.Headers INTERFACE ${CMAKE_CURRENT_LIST_DIR}/../native/Vulkan-Headers/include)
