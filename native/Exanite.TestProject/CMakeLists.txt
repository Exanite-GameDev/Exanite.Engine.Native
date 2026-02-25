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

get_target_property(linked_libs Exanite.TestProject LINK_LIBRARIES)
foreach(library ${linked_libs})
    if(TARGET ${library})
        get_target_property(library_type ${library} TYPE)
        if(library_type STREQUAL "SHARED_LIBRARY")
            add_custom_command(TARGET Exanite.TestProject POST_BUILD
                COMMAND ${CMAKE_COMMAND} -E copy -t $<TARGET_FILE_DIR:Exanite.TestProject> $<TARGET_FILE:${library}>
                COMMENT "Copying ${library} to executable directory"
            )
        endif()
    endif()
endforeach()
