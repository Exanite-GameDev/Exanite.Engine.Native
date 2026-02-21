cmake_minimum_required(VERSION 3.28)
project(Exanite.TestProject LANGUAGES CXX)

# --- Build ---

add_executable(Exanite.TestProject)
set_target_properties(Exanite.TestProject
    PROPERTIES
        CXX_STANDARD 23
        OUTPUT_NAME "Exanite.TestProject"
)

file(GLOB sources CONFIGURE_DEPENDS src/*.cpp)
target_sources(Exanite.TestProject PRIVATE ${sources})

target_link_libraries(Exanite.TestProject PRIVATE Exanite.Tracy)

# --- Copy required DLLs -----

if(WIN32)
    add_custom_command(TARGET Exanite.TestProject POST_BUILD
        COMMAND ${CMAKE_COMMAND} -E copy -t $<TARGET_FILE_DIR:Exanite.TestProject> $<TARGET_RUNTIME_DLLS:Exanite.TestProject>
        COMMAND_EXPAND_LISTS
    )
endif()
