if(NOT TARGET External.TracyProfiler)
    block()
        # Define install directory
        set(INSTALL_DIR ${CMAKE_BINARY_DIR}/install/tracy)

        # Add as external project
        ExternalProject_Add(External.TracyProfiler
            SOURCE_DIR ${CMAKE_SOURCE_DIR}/native/tracy/profiler
            INSTALL_DIR ${INSTALL_DIR}
            BUILD_BYPRODUCTS "${INSTALL_DIR}/bin/tracy-profiler${CMAKE_EXECUTABLE_SUFFIX}"
            CMAKE_ARGS
                -DCMAKE_INSTALL_PREFIX=<INSTALL_DIR>
                -DCMAKE_POSITION_INDEPENDENT_CODE=ON

                -DCMAKE_BUILD_TYPE=Release
        )
    endblock()
endif()
