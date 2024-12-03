#include <slang.h>
#include <slang-com-ptr.h>

auto main(int argc, char** argv) -> int {
    Slang::ComPtr<slang::IGlobalSession> globalSession;
    slang::createGlobalSession(globalSession.writeRef());
    //
    // slang::TargetDesc targetDesc;
    // targetDesc.format = SLANG_SPIRV;
    //
    // slang::SessionDesc sessionDesc;
    // sessionDesc.targets = &targetDesc;
    // sessionDesc.targetCount = 1;
    //
    // slang::ISession* session;
    //
    // globalSession->createSession(sessionDesc, &session);

    return 0;
}
