cmake_minimum_required(VERSION 3.28)
project(Exanite.TracyClient LANGUAGES CXX)

# --- Dependencies ---

find_package(Tracy REQUIRED)

# --- Build ---

add_library(Exanite.TracyClient SHARED)
set_target_properties(Exanite.TracyClient
    PROPERTIES
        CXX_STANDARD 23
        OUTPUT_NAME "TracyClient"
)

file(GLOB sources CONFIGURE_DEPENDS src/*.cpp)
target_sources(Exanite.TracyClient PRIVATE ${sources})

target_link_libraries(Exanite.TracyClient PUBLIC Tracy::TracyClient)
