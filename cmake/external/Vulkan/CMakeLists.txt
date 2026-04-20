add_library(Vulkan-Headers INTERFACE)
add_library(Vulkan::Headers ALIAS Vulkan-Headers)
target_include_directories(Vulkan-Headers INTERFACE ${CMAKE_CURRENT_LIST_DIR}/../native/Vulkan-Headers/include)
