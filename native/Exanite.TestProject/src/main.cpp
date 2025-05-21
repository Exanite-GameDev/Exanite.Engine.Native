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
        auto blob = new StringBlob("// Hello world!");;
        *outBlob = blob;

        std::cout << "Hello from CustomFileSystem!" << std::endl;

        return SlangUtility::resultUnspecifiedFailure;
    }

    void* castAs(const SlangUUID& guid) override
    {
        return this;
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
    std::cout << "hello world" << std::endl;

    // Create global session
    Slang::ComPtr<slang::IGlobalSession> globalSession {};
    createGlobalSession(globalSession.writeRef());

    // Create file system
    auto fileSystem = Slang::ComPtr(new CustomFileSystem());
    std::cout << fileSystem->addRef() << std::endl;
    std::cout << fileSystem->release() << std::endl;

    // Create target
    slang::TargetDesc targetDesc {};
    {
        targetDesc.format = SLANG_GLSL;
        targetDesc.profile = globalSession->findProfile("glsl_460");
    }

    // Create session
    Slang::ComPtr<slang::ISession> session {};
    slang::SessionDesc sessionDesc {};
    {
        // Set file system
        sessionDesc.fileSystem = fileSystem;

        // Set target
        sessionDesc.targetCount = 1;
        sessionDesc.targets = &targetDesc;
    }

    globalSession->createSession(sessionDesc, session.writeRef());

    // Compile some code
    Slang::ComPtr<SlangCompileRequest> request {};
    session->createCompileRequest(request.writeRef());

    auto translationUnitIndex = request->addTranslationUnit(SLANG_SOURCE_LANGUAGE_SLANG, "source-test.slang");
    request->addTranslationUnitSourceString(translationUnitIndex, "source-test.slang", "[shader(\"compute\")] void main() {}");

    request->compile();

    // Get the compiled code
    size_t codeSize;
    auto pCode = request->getEntryPointCode(0, &codeSize);

    std::cout << static_cast<const char*>(pCode) << std::endl;
}