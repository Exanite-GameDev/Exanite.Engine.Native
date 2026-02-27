cmake_minimum_required(VERSION 3.28)
project(Exanite.FreeType LANGUAGES CXX)

# --- Dependencies ---

find_package(FreeType REQUIRED)

# ----- Build -----

add_library(Exanite.FreeType INTERFACE)
set_target_properties(Exanite.FreeType
    PROPERTIES
        CXX_STANDARD 23
        OUTPUT_NAME "ExaniteFreeType"
        WINDOWS_EXPORT_ALL_SYMBOLS TRUE
)

target_include_directories(Exanite.FreeType INTERFACE "include")

target_link_libraries(Exanite.FreeType INTERFACE FreeType::FreeType)
