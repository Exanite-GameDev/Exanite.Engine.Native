cmake_minimum_required(VERSION 3.28)
project(Exanite.SlangTestProject LANGUAGES CXX)

# --- Dependencies ---

find_package(Slang REQUIRED)

# ----- Build -----

add_executable(Exanite.SlangTestProject)
set_target_properties(Exanite.SlangTestProject
    PROPERTIES
        CXX_STANDARD 23
        OUTPUT_NAME "Exanite.SlangTestProject"
)

file(GLOB sources CONFIGURE_DEPENDS src/*.cpp)
target_sources(Exanite.SlangTestProject PRIVATE ${sources})
target_include_directories(Exanite.SlangTestProject PUBLIC "include")

target_link_libraries(Exanite.SlangTestProject PRIVATE Slang::Slang)

# ----- Copy required DLLs -----

get_target_property(linked_libs Exanite.SlangTestProject LINK_LIBRARIES)
foreach(library ${linked_libs})
    if(TARGET ${library})
        get_target_property(library_type ${library} TYPE)
        if(library_type STREQUAL "SHARED_LIBRARY")
            add_custom_command(TARGET Exanite.SlangTestProject POST_BUILD
                COMMAND ${CMAKE_COMMAND} -E copy -t $<TARGET_FILE_DIR:Exanite.SlangTestProject> $<TARGET_FILE:${library}>
            )
        endif()
    endif()
endforeach()
