#include <iostream>
#include <Exanite/Tracy.h>

typedef struct UIntBitfield {
    int bits : 8;
    char bits1 : 8;
    unsigned int bits2 : 8;
    unsigned char bits3 : 8;
} UIntBitfield;

int main()
{
    std::cout << sizeof(UIntBitfield) << std::endl;
    std::cout << ___tracy_get_time() << std::endl;
    std::cout << ___tracy_get_time() << std::endl;
    std::cout << ___tracy_get_time() << std::endl;
    std::cout << ___tracy_get_time() << std::endl;
    std::cout << ___tracy_connected() << std::endl;

    return 0;
}
