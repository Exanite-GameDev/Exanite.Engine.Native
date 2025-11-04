#pragma once

#include <slang.h>
#include <slang-com-helper.h>
#include <slang-com-ptr.h>
#include <array>
#include <iostream>

const char* shaderSource = "struct Input\r\n{\r\n    uint VertexId : SV_VertexId;\r\n};\r\n\r\nstruct Output\r\n{\r\n    float4 Position : SV_Position;\r\n    float2 Uv : Uv;\r\n};\r\n\r\nvoid main(in Input input, out Output output)\r\n{\r\n    float4 positionUvs[3];\r\n    positionUvs[0] = float4(-1, -1, 0, 0);\r\n    positionUvs[1] = float4(3, -1, 2, 0);\r\n    positionUvs[2] = float4(-1, 3, 0, 2);\r\n\r\n    output.Position = float4(positionUvs[input.VertexId].xy, 0, 1);\r\n    output.Uv = float2(positionUvs[input.VertexId].zw);\r\n}";
// const char* shaderSource = "[shader(\"compute\")] void main() {}";

void diagnoseIfNeeded(slang::IBlob* diagnosticsBlob)
{
    if (diagnosticsBlob != nullptr)
    {
        std::cout << (const char*)diagnosticsBlob->getBufferPointer() << std::endl;
    }
}

class SlangUtility
{
public:
    static constexpr SlangResult resultOk = 0;
    static constexpr SlangResult resultUnspecifiedFailure = -2147467259;
    static constexpr SlangResult resultNoInterface = -2147467262;
};

class StringBlob : public ISlangBlob
{
private:
    std::string data {};
    int refCount = 0;

public:
    explicit StringBlob(const std::string& data)
    {
        this->data = data;
    }

    void const* getBufferPointer() override
    {
        return data.data();
    }

    size_t getBufferSize() override
    {
        return data.size();
    }

    SlangResult queryInterface(SlangUUID const& uuid, void** outObject) override
    {
        return SlangUtility::resultNoInterface;
    }

    uint32_t addRef() override
    {
        refCount++;
        return refCount;
    }

    uint32_t release() override
    {
        refCount--;
        if (refCount == 0)
        {
            delete this;
        }

        return refCount;
    }
};

int runSlangExample()
{
    // Create Global Session
    Slang::ComPtr<slang::IGlobalSession> globalSession;
    createGlobalSession(globalSession.writeRef());

    // Create target
    slang::TargetDesc targetDesc = {};

    targetDesc.format = SLANG_GLSL;
    targetDesc.profile = globalSession->findProfile("spirv_1_5");

    // Create Session
    slang::SessionDesc sessionDesc = {};

    sessionDesc.targets = &targetDesc;
    sessionDesc.targetCount = 1;

    auto searchPath = "/";
    sessionDesc.searchPathCount = 1;
    sessionDesc.searchPaths = &searchPath;

    Slang::ComPtr<slang::ISession> session;
    globalSession->createSession(sessionDesc, session.writeRef());

    // Load module
    Slang::ComPtr<slang::IModule> slangModule;
    {
        Slang::ComPtr<slang::IBlob> diagnosticsBlob;
        slangModule = session->loadModuleFromSourceString("shader.slang","shader.slang",shaderSource,diagnosticsBlob.writeRef());
        diagnoseIfNeeded(diagnosticsBlob);
        if (!slangModule)
        {
            return -1;
        }
    }

    // Query Entry Points
    Slang::ComPtr<slang::IEntryPoint> entryPoint;
    {
        Slang::ComPtr<slang::IBlob> diagnosticsBlob;
        slangModule->findAndCheckEntryPoint("main", SLANG_STAGE_VERTEX, entryPoint.writeRef(), diagnosticsBlob.writeRef());
        if (!entryPoint)
        {
            std::cout << "Error getting entry point" << std::endl;
            return -1;
        }
    }

    // Compose Modules + Entry Points
    std::array<slang::IComponentType*, 2> componentTypes =
    {
        slangModule,
        entryPoint
    };

    Slang::ComPtr<slang::IComponentType> composedProgram;
    {
        Slang::ComPtr<slang::IBlob> diagnosticsBlob;
        SlangResult result = session->createCompositeComponentType(
            componentTypes.data(),
            componentTypes.size(),
            composedProgram.writeRef(),
            diagnosticsBlob.writeRef());
        diagnoseIfNeeded(diagnosticsBlob);
        SLANG_RETURN_ON_FAIL(result);
    }

    // Link
    Slang::ComPtr<slang::IComponentType> linkedProgram;
    {
        Slang::ComPtr<slang::IBlob> diagnosticsBlob;
        SlangResult result = composedProgram->link(
            linkedProgram.writeRef(),
            diagnosticsBlob.writeRef());
        diagnoseIfNeeded(diagnosticsBlob);
        SLANG_RETURN_ON_FAIL(result);
    }

    // Get Target Kernel Code
    Slang::ComPtr<slang::IBlob> code;
    {
        Slang::ComPtr<slang::IBlob> diagnosticsBlob;
        SlangResult result = linkedProgram->getEntryPointCode(
            0,
            0,
            code.writeRef(),
            diagnosticsBlob.writeRef());
        diagnoseIfNeeded(diagnosticsBlob);
        SLANG_RETURN_ON_FAIL(result);
    }

    std::cout << static_cast<const char*>(code->getBufferPointer()) << std::endl;

    return 0;
}
