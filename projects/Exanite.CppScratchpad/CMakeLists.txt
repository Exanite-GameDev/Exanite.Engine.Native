add_executable(Exanite.CppScratchpad)
set_target_properties(Exanite.CppScratchpad
    PROPERTIES
        CXX_STANDARD 23
        OUTPUT_NAME "Exanite.CppScratchpad"
)

file(GLOB sources CONFIGURE_DEPENDS src/*.cpp)
target_sources(Exanite.CppScratchpad PRIVATE ${sources})
target_include_directories(Exanite.CppScratchpad PUBLIC "include")
