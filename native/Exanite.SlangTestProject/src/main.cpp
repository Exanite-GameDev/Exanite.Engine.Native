#include "OpAccessChainRepro.h"

#include <slang-com-helper.h>

#include <cassert>
#include <iostream>

int main()
{
    std::cout << "Using Slang version: " << spGetBuildTagString() << std::endl;

    SlangResult result = runSlangExample();
    SLANG_ASSERT_ON_FAIL(result);

    return result;
}
