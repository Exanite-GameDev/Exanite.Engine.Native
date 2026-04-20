add_executable(Exanite.SlangTestProject)
set_target_properties(Exanite.SlangTestProject
    PROPERTIES
        CXX_STANDARD 23
        OUTPUT_NAME "Exanite.SlangTestProject"
)

file(GLOB sources CONFIGURE_DEPENDS src/*.cpp)
target_sources(Exanite.SlangTestProject PRIVATE ${sources})
target_include_directories(Exanite.SlangTestProject PUBLIC "include")

target_link_libraries(Exanite.SlangTestProject PRIVATE Imported.Slang)
exanite_copy_shared_libraries_to_executable(Exanite.SlangTestProject)
