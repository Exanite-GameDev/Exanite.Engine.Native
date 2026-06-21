#include <chrono>
#include <iostream>

int main()
{
    std::cout << "Hello world" << std::endl;
    std::cout << static_cast<int32_t>(static_cast<char>(-1)) << std::endl;
    std::cout << static_cast<int32_t>(static_cast<uint8_t>(-1)) << std::endl;
    std::cout << static_cast<int32_t>(static_cast<int8_t>(-1)) << std::endl;
}
