cmake_minimum_required(VERSION 3.28)
project(Exanite.Tracy LANGUAGES CXX)

# --- Dependencies ---

find_package(Tracy REQUIRED)

# --- Build ---

add_library(Exanite.Tracy SHARED)
set_target_properties(Exanite.Tracy
    PROPERTIES
        CXX_STANDARD 23
        OUTPUT_NAME "ExaniteTracyClient"
        WINDOWS_EXPORT_ALL_SYMBOLS TRUE
)

file(GLOB sources CONFIGURE_DEPENDS src/*.cpp src/*.def)
target_sources(Exanite.Tracy PRIVATE ${sources})
target_include_directories(Exanite.Tracy PUBLIC "include")

target_compile_definitions(Exanite.Tracy PRIVATE EXANITE_TRACY_EXPORT)

target_link_libraries(Exanite.Tracy PUBLIC "$<LINK_LIBRARY:WHOLE_ARCHIVE,Tracy::TracyClient>")
