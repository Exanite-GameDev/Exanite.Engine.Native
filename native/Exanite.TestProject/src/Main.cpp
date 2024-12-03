#include <iostream>

#define VMA_IMPLEMENTATION
#include <vk_mem_alloc.h>

auto main(int argc, char** argv) -> int {
    VkInstanceCreateInfo instanceCreateInfo{};
    instanceCreateInfo.sType = VK_STRUCTURE_TYPE_INSTANCE_CREATE_INFO;

    VkInstance instance;
    vkCreateInstance(&instanceCreateInfo, nullptr, &instance);

    std::cout << std::to_string(sizeof(VmaAllocatorCreateInfo)) << std::endl;
    vmaDestroyAllocator(nullptr);

    return 0;
}
