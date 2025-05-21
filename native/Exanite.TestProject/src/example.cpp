#include <slang.h>
#include <slang-com-helper.h>
#include <slang-com-ptr.h>
#include <array>
#include <iostream>

const char* shortestShader =
"RWStructuredBuffer<float> result;"
"[shader(\"compute\")]"
"[numthreads(1,1,1)]"
"void computeMain(uint3 threadId : SV_DispatchThreadID)"
"{"
"    result[threadId.x] = threadId.x;"
"}";

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

class CustomFileSystem : public ISlangFileSystem
{
private:
    int refCount = 0;

public:
    SlangResult loadFile(char const* path, ISlangBlob** outBlob) override
    {
        std::cout << std::format("Loading file at: {}", path) << std::endl;

        if (std::string(path) == std::string("shortest.slang"))
        {
            auto blob = Slang::ComPtr(new StringBlob(shortestShader));
            blob->addRef(); // TODO: Not sure why this is required
            *outBlob = blob;

            std::cout << std::format("Successfully loaded") << std::endl;

            return SlangUtility::resultOk;
        }

        std::cout << std::format("Failed to load") << std::endl;

        return SlangUtility::resultUnspecifiedFailure;
    }

    void* castAs(const SlangUUID& guid) override
    {
        return nullptr;
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

int main()
{
    // 1. Create Global Session
    Slang::ComPtr<slang::IGlobalSession> globalSession;
    createGlobalSession(globalSession.writeRef());

    // 1.5. Create target
    slang::TargetDesc targetDesc = {};

    targetDesc.format = SLANG_GLSL;
    targetDesc.profile = globalSession->findProfile("spirv_1_5");

    // 2. Create Session
    slang::SessionDesc sessionDesc = {};

    Slang::ComPtr<CustomFileSystem> fileSystem = Slang::ComPtr(new CustomFileSystem);
    sessionDesc.fileSystem = fileSystem;

    sessionDesc.targets = &targetDesc;
    sessionDesc.targetCount = 1;

    auto searchPath = "/";
    sessionDesc.searchPathCount = 1;
    sessionDesc.searchPaths = &searchPath;

    Slang::ComPtr<slang::ISession> session;
    globalSession->createSession(sessionDesc, session.writeRef());

    // 3. Load module
    Slang::ComPtr<slang::IModule> slangModule;
    {
        Slang::ComPtr<slang::IBlob> diagnosticsBlob;
        // slangModule = session->loadModuleFromSourceString(
        //     "shortest.slang",                        // Module name
        //     "shortest.slang",                        // Module path
        //     shortestShader,                          // Shader source code
        //     diagnosticsBlob.writeRef()); // Optional diagnostic container

        slangModule = session->loadModule("shortest.slang", diagnosticsBlob.writeRef());
        diagnoseIfNeeded(diagnosticsBlob);
        if (!slangModule)
        {
            return -1;
        }
    }

    // 4. Query Entry Points
    Slang::ComPtr<slang::IEntryPoint> entryPoint;
    {
        Slang::ComPtr<slang::IBlob> diagnosticsBlob;
        slangModule->findEntryPointByName("computeMain", entryPoint.writeRef());
        if (!entryPoint)
        {
            std::cout << "Error getting entry point" << std::endl;
            return -1;
        }
    }

    // 5. Compose Modules + Entry Points
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

    // 6. Link
    Slang::ComPtr<slang::IComponentType> linkedProgram;
    {
        Slang::ComPtr<slang::IBlob> diagnosticsBlob;
        SlangResult result = composedProgram->link(
            linkedProgram.writeRef(),
            diagnosticsBlob.writeRef());
        diagnoseIfNeeded(diagnosticsBlob);
        SLANG_RETURN_ON_FAIL(result);
    }

    // 7. Get Target Kernel Code
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
}
