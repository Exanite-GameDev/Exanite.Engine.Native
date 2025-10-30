if(NOT TARGET VulkanMemoryAllocator::Headers)
    find_package(Vulkan REQUIRED)

    add_library(VulkanMemoryAllocator-Headers INTERFACE)
    add_library(VulkanMemoryAllocator::Headers ALIAS VulkanMemoryAllocator-Headers)
    target_include_directories(VulkanMemoryAllocator-Headers INTERFACE ${CMAKE_CURRENT_LIST_DIR}/../native/VulkanMemoryAllocator/include)

    target_link_libraries(VulkanMemoryAllocator-Headers INTERFACE Vulkan::Headers)
endif()
