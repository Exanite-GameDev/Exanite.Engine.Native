#include <dxcapi.h>

auto main(int argc, char** argv) -> int
{
    ComPtr<IDxcUtils> pUtils;
    DxcCreateInstance(CLSID_DxcUtils, IID_PPV_ARGS(pUtils.GetAddressOf()));
    ComPtr<IDxcBlobEncoding> pSource;
    pUtils->CreateBlob(pShaderSource, shaderSourceSize, CP_UTF8, pSource.GetAddressOf());


    DxcCreateInstance(CLSID_DxcCompiler, )

    return 0;
}
