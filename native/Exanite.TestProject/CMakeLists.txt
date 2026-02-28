cmake_minimum_required(VERSION 3.28)
project(Exanite.TestProject LANGUAGES CXX)

# ----- Dependencies -----

find_package(FreeType REQUIRED)

# ----- Build -----

add_executable(Exanite.TestProject)
set_target_properties(Exanite.TestProject
    PROPERTIES
        CXX_STANDARD 23
        OUTPUT_NAME "Exanite.TestProject"
)

file(GLOB sources CONFIGURE_DEPENDS src/*.cpp)
target_sources(Exanite.TestProject PRIVATE ${sources})
target_include_directories(Exanite.TestProject PUBLIC "include")

target_link_libraries(Exanite.TestProject PRIVATE Exanite.Tracy)
target_link_libraries(Exanite.TestProject PRIVATE Exanite.FreeType)
target_link_libraries(Exanite.TestProject PRIVATE HarfBuzz::HarfBuzz)
exanite_copy_shared_libraries_to_executable_folder(Exanite.TestProject)
