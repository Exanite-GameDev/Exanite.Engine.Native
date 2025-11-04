cmake_minimum_required(VERSION 3.28)
project(Exanite.TracyClient LANGUAGES CXX)

# --- Dependencies ---

find_package(Tracy REQUIRED)

# --- Build ---

add_library(Exanite.TracyClient SHARED src/placeholder.cpp)
set_target_properties(Exanite.TracyClient
    PROPERTIES
        CXX_STANDARD 23
        OUTPUT_NAME "TracyClient"
)

target_link_libraries(Exanite.TracyClient PUBLIC Tracy::TracyClient)
