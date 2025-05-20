#include <slang-com-ptr.h>
#include <iostream>

int main()
{
    std::cout << "hello world" << std::endl;

    // Create global session
    Slang::ComPtr<slang::IGlobalSession> globalSession;
    createGlobalSession(globalSession.writeRef());

    // globalSession.

    // Create file system

    // Create target
    slang::TargetDesc targetDesc {};
    {
        targetDesc.format = SLANG_SPIRV;
        targetDesc.profile = globalSession->findProfile("spirv_1_5");
    }

    // Create local session
    Slang::ComPtr<slang::ISession> session;
    slang::SessionDesc sessionDesc {};
    {
        // Set file system
        // TODO
        sessionDesc.fileSystem;

        // Set target
        sessionDesc.targetCount = 1;
        sessionDesc.targets = &targetDesc;
    }

    globalSession->createSession(sessionDesc, session.writeRef());
}

class CustomFileSystem : public ISlangFileSystem
{
private:
    static constexpr SlangResult resultOk = 0;
    static constexpr SlangResult resultUnspecifiedFailure = -2147467259;

public:
    SlangResult loadFile(char const* path, ISlangBlob** outBlob) override
    {
        return resultUnspecifiedFailure;
    }
};

// class CustomIncludeHandler : public IDxcIncludeHandler
// {
// public:
//     HRESULT STDMETHODCALLTYPE LoadSource(_In_ LPCWSTR pFilename, _COM_Outptr_result_maybenull_ IDxcBlob** ppIncludeSource) override
//     {
//         ComPtr<IDxcBlobEncoding> pEncoding;
//         std::string path = Paths::Normalize(UNICODE_TO_MULTIBYTE(pFilename));
//         if (IncludedFiles.find(path) != IncludedFiles.end())
//         {
//             // Return empty string blob if this file has been included before
//             static const char nullStr[] = " ";
//             pUtils->CreateBlobFromPinned(nullStr, ARRAYSIZE(nullStr), DXC_CP_ACP, pEncoding.GetAddressOf());
//             *ppIncludeSource = pEncoding.Detach();
//             return S_OK;
//         }
//
//         HRESULT hr = pUtils->LoadFile(pFilename, nullptr, pEncoding.GetAddressOf());
//         if (SUCCEEDED(hr))
//         {
//             IncludedFiles.insert(path);
//             *ppIncludeSource = pEncoding.Detach();
//         }
//         return hr;
//     }
//
//     HRESULT STDMETHODCALLTYPE QueryInterface(REFIID riid, _COM_Outptr_ void __RPC_FAR* __RPC_FAR* ppvObject) override { return E_NOINTERFACE; }
//     ULONG STDMETHODCALLTYPE AddRef(void) override {	return 0; }
//     ULONG STDMETHODCALLTYPE Release(void) override { return 0; }
//
//     std::unordered_set<std::string> IncludedFiles;
// };