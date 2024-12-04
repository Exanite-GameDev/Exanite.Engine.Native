#define _Maybenull_
#ifdef WIN32
#include <d3d12shader.h>
#endif
#include <dxcapi.h>
#include <stdexcept>

const GUID IID_IDxcUtils = {0x4605c4cb, 0x2019, 0x492a, {0xad, 0xa4, 0x65, 0xf2, 0x0b, 0xb7, 0xd6, 0x7f}};

void guardSuccess(HRESULT result)
{
    if (result != 0)
    {
        throw std::runtime_error("Result was not a success");
    }
}

auto main(int argc, char** argv) -> int
{
    IDxcUtils* pUtils;
    guardSuccess(DxcCreateInstance(CLSID_DxcUtils, IID_IDxcUtils, reinterpret_cast<void**>(&pUtils)));

    const char* pShaderSource = "";

    IDxcBlobEncoding* pSource;
    guardSuccess(pUtils->CreateBlob(pShaderSource, 0, CP_UTF8, &pSource));

    return 0;
}
