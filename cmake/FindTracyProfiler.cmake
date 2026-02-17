if(NOT TARGET External.TracyProfiler)
    block()
        # Define build and install directories
        set(BUILD_DIR ${CMAKE_BINARY_DIR}/build/tracy-profiler)
        set(INSTALL_DIR ${CMAKE_BINARY_DIR}/install/tracy-profiler)

        # Add as external project
        ExternalProject_Add(External.TracyProfiler
            SOURCE_DIR ${CMAKE_SOURCE_DIR}/native/tracy/profiler
            BINARY_DIR ${BUILD_DIR}
            INSTALL_DIR ${INSTALL_DIR}
            BUILD_BYPRODUCTS "${INSTALL_DIR}/bin/tracy-profiler${CMAKE_EXECUTABLE_SUFFIX}"
            CMAKE_ARGS
                -DCMAKE_INSTALL_PREFIX=${INSTALL_DIR}
                -DCMAKE_POSITION_INDEPENDENT_CODE=ON

                -DCMAKE_BUILD_TYPE=${CMAKE_BUILD_TYPE}

                # Force consistent output folders between Debug/Release
                -DCMAKE_ARCHIVE_OUTPUT_DIRECTORY_DEBUG=${INSTALL_DIR}/lib
                -DCMAKE_LIBRARY_OUTPUT_DIRECTORY_DEBUG=${INSTALL_DIR}/lib
                -DCMAKE_RUNTIME_OUTPUT_DIRECTORY_DEBUG=${INSTALL_DIR}/bin
        )
    endblock()
endif()
