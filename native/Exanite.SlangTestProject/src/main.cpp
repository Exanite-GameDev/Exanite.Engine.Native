#include <iostream>
#include "SlangExample.h"

typedef struct UIntBitfield {
    int bits : 8;
    char bits1 : 8;
    unsigned int bits2 : 8;
    unsigned char bits3 : 8;
} UIntBitfield;

int main()
{
    runSlangExample();

    return 0;
}