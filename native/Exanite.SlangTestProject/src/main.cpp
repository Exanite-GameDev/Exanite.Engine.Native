#include "OpAccessChainRepro.h"
#include <iostream>

int main()
{
    SlangResult result = runSlangExample();
    SLANG_ASSERT_ON_FAIL(result);

    return result;
}
