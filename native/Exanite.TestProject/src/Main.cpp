#define _Maybenull_
#ifdef WIN32
#include <d3d12shader.h>
#endif
#include <dxcapi.h>
#include <iostream>
#include <stdexcept>

#define EXANITE_DEBUG

void log(const std::string& value = "")
{
    std::cout << value + "\n" << std::flush;
}

void logDebug(const std::string& value = "")
{
#ifdef EXANITE_DEBUG
    log(value);
#endif
}

constexpr GUID IID_IDxcUtils = {0x4605c4cb, 0x2019, 0x492a, {0xad, 0xa4, 0x65, 0xf2, 0x0b, 0xb7, 0xd6, 0x7f}};

void guardSuccess(const HRESULT result)
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

    std::string shaderSource = "main() {}";

    IDxcBlobEncoding* pSource;
    guardSuccess(pUtils->CreateBlob(shaderSource.data(), shaderSource.length(), CP_UTF8, &pSource));

    return 0;
}
