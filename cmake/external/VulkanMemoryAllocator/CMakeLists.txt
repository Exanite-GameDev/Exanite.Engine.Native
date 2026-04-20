find_package(Vulkan REQUIRED)

add_library(Imported.VulkanMemoryAllocator.Headers INTERFACE)
target_include_directories(Imported.VulkanMemoryAllocator.Headers INTERFACE ${CMAKE_CURRENT_LIST_DIR}/../native/VulkanMemoryAllocator/include)

target_link_libraries(Imported.VulkanMemoryAllocator.Headers INTERFACE Vulkan::Headers)
