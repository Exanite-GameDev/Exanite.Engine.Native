if(NOT TARGET Tracy::TracyClient)
    set(TRACY_ENABLE ON)
    set(TRACY_ON_DEMAND ON)
    set(TRACY_CALLSTACK ON)

    add_subdirectory(${CMAKE_SOURCE_DIR}/native/tracy ${CMAKE_BINARY_DIR}/native/tracy)
endif()
