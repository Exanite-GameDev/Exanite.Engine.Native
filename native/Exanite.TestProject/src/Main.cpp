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
    guardSuccess(DxcCreateInstance(CLSID_DxcUtils, __emulated_uuidof<IDxcUtils>(), reinterpret_cast<void**>(&utils)));

    IDxcCompiler3* compiler;
    guardSuccess(DxcCreateInstance(CLSID_DxcCompiler, __emulated_uuidof<IDxcCompiler3>(), reinterpret_cast<void**>(&compiler)));

    std::string shaderSource = "void main() {}";

    IDxcBlobEncoding* encodedCodeBlob;
    guardSuccess(utils->CreateBlob(shaderSource.data(), shaderSource.length(), CP_UTF8, &encodedCodeBlob));

    DxcBuffer buffer(encodedCodeBlob->GetBufferPointer(), encodedCodeBlob->GetBufferSize(), CP_ACP);

    const auto shaderProfile = const_cast<LPCWSTR>(L"ps_6_6");
    std::vector<LPCWSTR> arguments
    {
        // Entrypoint
        const_cast<LPWSTR>(L"-E"), const_cast<LPWSTR>(L"main"),

        // Target profile / shader type + version
        const_cast<LPWSTR>(L"-T"), shaderProfile,

        // Only strips from output bytecode
        const_cast<LPWSTR>(L"-Qstrip_debug"),

        // Warnings as errors
        const_cast<LPWSTR>(L"-WX"),

        // SPIRV
        const_cast<LPWSTR>(L"-spirv"),
        const_cast<LPWSTR>(L"-fspv-target-env=vulkan1.3"),

        // Use gl_BaseInstance as first vertex instance instead of 0 (Follows Vulkan spec)
        const_cast<LPWSTR>(L"-fvk-support-nonzero-base-instance"),

        // Include shader name for easier debugging
        const_cast<LPWSTR>(L"Shader.fragment.hlsl"),
    };

    bool useReflection = true;
    if (useReflection)
    {
        arguments.push_back(const_cast<LPWSTR>(L"-fspv-reflect"));
    }

    IDxcResult* result;
    guardSuccess(compiler->Compile(&buffer, arguments.data(), arguments.size(), nullptr, __emulated_uuidof<IDxcResult>(), reinterpret_cast<void**>(&result)));

    IDxcBlobEncoding* errors;
    guardSuccess(result->GetErrorBuffer(&errors));

    if (errors != nullptr && errors->GetBufferPointer() != nullptr)
    {
        bool isEncodingKnown;
        uint32_t codePage;
        errors->GetEncoding(&isEncodingKnown, &codePage);

        guardIsTrue(codePage == CP_UTF8);

        std::string errorMessage = static_cast<LPSTR>(errors->GetBufferPointer());
        if (!errorMessage.empty())
        {
            throw std::runtime_error(errorMessage);
        }
    }

    return 0;
}
