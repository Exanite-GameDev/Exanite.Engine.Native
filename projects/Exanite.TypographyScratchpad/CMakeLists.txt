add_executable(Exanite.TypographyScratchpad)
set_target_properties(Exanite.TypographyScratchpad
    PROPERTIES
        CXX_STANDARD 23
        OUTPUT_NAME "Exanite.TypographyScratchpad"
)

file(GLOB sources CONFIGURE_DEPENDS src/*.cpp)
target_sources(Exanite.TypographyScratchpad PRIVATE ${sources})
target_include_directories(Exanite.TypographyScratchpad PUBLIC "include")

target_link_libraries(Exanite.TypographyScratchpad PRIVATE Exanite.Tracy)
target_link_libraries(Exanite.TypographyScratchpad PRIVATE Exanite.FreeType)
target_link_libraries(Exanite.TypographyScratchpad PRIVATE Imported.HarfBuzz)
exanite_copy_shared_libraries_to_executable(Exanite.TypographyScratchpad)
