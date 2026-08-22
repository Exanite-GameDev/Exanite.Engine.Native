add_library(Exanite.FreeType INTERFACE)
set_target_properties(Exanite.FreeType
    PROPERTIES
        CXX_STANDARD 23
        OUTPUT_NAME "ExaniteFreeType"
)

target_include_directories(Exanite.FreeType INTERFACE "include")

target_link_libraries(Exanite.FreeType INTERFACE Imported.FreeType)
