add_executable(Exanite.TypographyTestProject)
set_target_properties(Exanite.TypographyTestProject
    PROPERTIES
        CXX_STANDARD 23
        OUTPUT_NAME "Exanite.TypographyTestProject"
)

file(GLOB sources CONFIGURE_DEPENDS src/*.cpp)
target_sources(Exanite.TypographyTestProject PRIVATE ${sources})
target_include_directories(Exanite.TypographyTestProject PUBLIC "include")

target_link_libraries(Exanite.TypographyTestProject PRIVATE Exanite.Tracy)
target_link_libraries(Exanite.TypographyTestProject PRIVATE Exanite.FreeType)
target_link_libraries(Exanite.TypographyTestProject PRIVATE Imported.HarfBuzz)
exanite_copy_shared_libraries_to_executable(Exanite.TypographyTestProject)
