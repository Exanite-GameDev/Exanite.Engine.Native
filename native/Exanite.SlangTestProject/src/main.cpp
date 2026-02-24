#include "OpAccessChainRepro.h"

#include <slang-com-helper.h>

#include <cassert>
#include <iostream>

int main()
{
    SlangResult result = runSlangExample();
    SLANG_ASSERT_ON_FAIL(result);

    return result;
}
