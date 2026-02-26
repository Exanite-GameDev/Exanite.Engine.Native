cmake_minimum_required(VERSION 3.28)
project(Exanite.FreeType LANGUAGES CXX)

# --- Dependencies ---

find_package(FreeType REQUIRED)

# --- Build ---

add_library(Exanite.FreeType SHARED)
set_target_properties(Exanite.FreeType
    PROPERTIES
        CXX_STANDARD 23
        OUTPUT_NAME "ExaniteFreeType"
        WINDOWS_EXPORT_ALL_SYMBOLS TRUE
)

file(GLOB sources CONFIGURE_DEPENDS src/*.cpp)
target_sources(Exanite.FreeType PRIVATE ${sources})
target_include_directories(Exanite.FreeType PUBLIC "include")

target_link_libraries(Exanite.FreeType PRIVATE FreeType::FreeType)
