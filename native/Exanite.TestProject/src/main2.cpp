#include <iostream>
#include <memory>
#include <slang-com-ptr.h>

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
        std::cout << "Hello from CustomFileSystem!" << std::endl;
        std::cout << std::format("Loading file at: {}", path) << std::endl;

        auto blob = new StringBlob("// Hello world!");;
        *outBlob = blob;

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

int main_disabled2()
{
    // Create global session
    Slang::ComPtr<slang::IGlobalSession> globalSession {};
    createGlobalSession(globalSession.writeRef());

    // Create file system
    auto fileSystem = Slang::ComPtr(new CustomFileSystem());

    // Create target
    slang::TargetDesc targetDesc {};
    {
        targetDesc.format = SLANG_GLSL;
        targetDesc.profile = globalSession->findProfile("spirv_1_5");
    }

    // Declare search path
    auto searchPath = "/";

    // Create session
    Slang::ComPtr<slang::ISession> session {};
    slang::SessionDesc sessionDesc {};
    {
        // Set file system
        sessionDesc.fileSystem = fileSystem;

        // Set search paths
        sessionDesc.searchPathCount = 1;
        sessionDesc.searchPaths = &searchPath;

        // Set target
        sessionDesc.targetCount = 1;
        sessionDesc.targets = &targetDesc;
    }

    globalSession->createSession(sessionDesc, session.writeRef());

    // Compile code by loading by string source code
    {
        Slang::ComPtr<slang::IModule> slangModule;
        {
            auto modulePath = "from-source.slang";

            Slang::ComPtr<ISlangBlob> diagnostics {};
            auto module = session->loadModuleFromSourceString(modulePath, modulePath, "[shader(\"compute\")] void main() {}", diagnostics.writeRef());

            if (diagnostics)
            {
                std::cout << static_cast<const char*>(diagnostics->getBufferPointer()) << std::endl;
            }

            if (!module)
            {
                throw std::runtime_error("Failed to compile module");
            }

            *slangModule.writeRef() = module;
        }

        for (int i = 0; i < slangModule->getDefinedEntryPointCount(); ++i)
        {
            Slang::ComPtr<slang::IEntryPoint> entrypoint {};
            slangModule->getDefinedEntryPoint(i, entrypoint.writeRef());

            if (!entrypoint)
            {
                throw std::runtime_error(std::format("Failed to get entrypoint: {}", i));
            }

            std::array<slang::IComponentType*, 2> componentTypes =
            {
                slangModule,
                entrypoint
            };

            Slang::ComPtr<slang::IComponentType> composedProgram;
            {
                Slang::ComPtr<slang::IBlob> diagnostics;
                session->createCompositeComponentType(componentTypes.data(), componentTypes.size(), composedProgram.writeRef(), diagnostics.writeRef());

                if (diagnostics)
                {
                    std::cout << static_cast<const char*>(diagnostics->getBufferPointer()) << std::endl;
                }

                if (composedProgram)
                {
                    throw std::runtime_error(std::format("Failed to compose entrypoint with program: {}", i));
                }
            }

            Slang::ComPtr<slang::IComponentType> linkedProgram;
            {
                Slang::ComPtr<slang::IBlob> diagnostics;
                SlangResult result = composedProgram->link(linkedProgram.writeRef(), diagnostics.writeRef());

                if (diagnostics)
                {
                    std::cout << static_cast<const char*>(diagnostics->getBufferPointer()) << std::endl;
                }

                if (linkedProgram)
                {
                    throw std::runtime_error(std::format("Failed to compose link program for entrypoint: {}", i));
                }
            }

            Slang::ComPtr<slang::IBlob> code;
            {
                Slang::ComPtr<slang::IBlob> diagnostics;
                linkedProgram->getEntryPointCode(0, 0, code.writeRef(), diagnostics.writeRef());

                if (code)
                {
                    std::cout << static_cast<const char*>(diagnostics->getBufferPointer()) << std::endl;
                }

                if (code)
                {
                    throw std::runtime_error(std::format("Failed to get code for entrypoint: {}", i));
                }
            }

            std::cout << "Compiled " << code->getBufferSize() << " bytes of SPIR-V" << std::endl;

            // Slang::ComPtr<ISlangBlob> code {};
            // Slang::ComPtr<ISlangBlob> diagnostics {};
            // entrypoint->getEntryPointCode(0, 0, code.writeRef(), diagnostics.writeRef());
            // // , 0, code.writeRef(), diagnostics.writeRef()
            //
            // if (diagnostics)
            // {
            //     std::cout << static_cast<const char*>(diagnostics->getBufferPointer()) << std::endl;
            // }
            //
            // if (!code)
            // {
            //     throw std::runtime_error(std::format("Failed to get code for entrypoint: {}", i));
            // }
            //
            // if (diagnostics)
            // {
            //     std::cout << std::format("Code for entrypoint {}:\n{}", i, static_cast<const char*>(code->getBufferPointer())) << std::endl;
            // }
        }
    }

    // Compile code by loading by module path
    {
        Slang::ComPtr<slang::IModule> slangModule;
        {
            auto modulePath = "from-path.slang";

            Slang::ComPtr<ISlangBlob> diagnostics {};
            auto module = session->loadModule(modulePath, diagnostics.writeRef());

            if (diagnostics)
            {
                std::cout << static_cast<const char*>(diagnostics->getBufferPointer()) << std::endl;
            }

            if (!module)
            {
                throw std::runtime_error("Failed to compile module");
            }

            *slangModule.writeRef() = module;
        }
    }
}
