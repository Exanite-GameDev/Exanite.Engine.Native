#define _Maybenull_
#ifdef WIN32
#include <d3d12shader.h>
#endif
#ifdef __linux__
#include <WinAdapter.h>
#endif
#include <dxcapi.h>
#include <iostream>
#include <stdexcept>
#include <vector>

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

constexpr GUID iidDxcUtils = {0x4605c4cb, 0x2019, 0x492a, {0xad, 0xa4, 0x65, 0xf2, 0x0b, 0xb7, 0xd6, 0x7f}};
constexpr GUID iidDxcCompiler3 = {0x228b4687, 0x5a6a, 0x4730, {0x90, 0x0c, 0x97, 0x02, 0xb2, 0x20, 0x3f, 0x54}};
constexpr GUID iidDxcResult = {0x58346cda, 0xdde7, 0x4497, {0x94, 0x61, 0x6f, 0x87, 0xaf, 0x5e, 0x06, 0x59}};

void guardIsTrue(const bool value)
{
    if (!value)
    {
        throw std::runtime_error("Condition was false");
    }
}

void guardSuccess(const HRESULT result)
{
    if (result != 0)
    {
        throw std::runtime_error("Result was not a success");
    }
}

auto main(int argc, char** argv) -> int
{
    IDxcUtils* utils;
    guardSuccess(DxcCreateInstance(CLSID_DxcUtils, iidDxcUtils, reinterpret_cast<void**>(&utils)));

    IDxcCompiler3* compiler;
    guardSuccess(DxcCreateInstance(CLSID_DxcCompiler, iidDxcCompiler3, reinterpret_cast<void**>(&compiler)));

    std::string shaderSource = "void main() {}";

    IDxcBlobEncoding* encodedCodeBlob;
    guardSuccess(utils->CreateBlob(shaderSource.data(), shaderSource.length(), CP_UTF8, &encodedCodeBlob));

    DxcBuffer buffer(encodedCodeBlob->GetBufferPointer(), encodedCodeBlob->GetBufferSize(), CP_ACP);

    log(std::to_string(sizeof(LPCWSTR)));
    const auto shaderProfile = const_cast<LPCWSTR>(L"ps_6_6");
    std::vector<LPCWSTR> arguments
    {
        // Entrypoint
        L"-E", L"main",

        // Target profile / shader type + version
        L"-T", shaderProfile,

        // Only strips from output bytecode
        L"-Qstrip_debug",

        // Warnings as errors
        L"-WX",

        // SPIRV
        L"-spirv",
        L"-fspv-target-env=vulkan1.3",

        // Use gl_BaseInstance as first vertex instance instead of 0 (Follows Vulkan spec)
        L"-fvk-support-nonzero-base-instance",
    };

    bool useReflection = true;
    if (useReflection)
    {
        arguments.push_back(L"-fspv-reflect");
    }

    IDxcResult* result;
    guardSuccess(compiler->Compile(&buffer, arguments.data(), arguments.size(), nullptr, iidDxcResult, reinterpret_cast<void**>(&result)));

    IDxcBlobEncoding* errors;
    guardSuccess(result->GetErrorBuffer(&errors));

    if (errors != nullptr && errors->GetBufferPointer() != nullptr)
    {
        BOOL isEncodingKnown;
        UINT32 codePage;
        errors->GetEncoding(&isEncodingKnown, &codePage);

        guardIsTrue(isEncodingKnown && codePage == CP_UTF8);

        std::string errorMessage = static_cast<LPSTR>(errors->GetBufferPointer());
        if (!errorMessage.empty())
        {
            throw std::runtime_error(errorMessage);
        }
    }

    return 0;
}
