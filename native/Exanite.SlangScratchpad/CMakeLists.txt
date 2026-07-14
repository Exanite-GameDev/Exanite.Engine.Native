add_executable(Exanite.SlangScratchpad)
set_target_properties(Exanite.SlangScratchpad
    PROPERTIES
        CXX_STANDARD 23
        OUTPUT_NAME "Exanite.SlangScratchpad"
)

file(GLOB sources CONFIGURE_DEPENDS src/*.cpp)
target_sources(Exanite.SlangScratchpad PRIVATE ${sources})
target_include_directories(Exanite.SlangScratchpad PUBLIC "include")

target_link_libraries(Exanite.SlangScratchpad PRIVATE Imported.Slang)
exanite_copy_shared_libraries_to_executable(Exanite.SlangScratchpad)
