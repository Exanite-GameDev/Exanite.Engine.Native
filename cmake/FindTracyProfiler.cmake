if(NOT TARGET External.TracyProfiler)
    block()
        include("${CMAKE_CURRENT_LIST_DIR}/ExternalProjectConfig.cmake")

        # Define build and install folders
        set(BUILD_DIR ${CMAKE_BINARY_DIR}/build/tracy-profiler)
        set(INSTALL_DIR ${CMAKE_BINARY_DIR}/install/tracy-profiler)

        # Define output names
        set(BASE_NAME "tracy-profiler")

        # Define outputs
        set(MAIN_OUTPUT_NAME "${INSTALL_DIR}/lib/${CMAKE_STATIC_LIBRARY_PREFIX}${BASE_NAME}${CMAKE_EXECUTABLE_SUFFIX}")

        # Add as external project
        ExternalProject_Add(External.TracyProfiler
            SOURCE_DIR ${CMAKE_SOURCE_DIR}/native/tracy/profiler
            BINARY_DIR ${BUILD_DIR}
            INSTALL_DIR ${INSTALL_DIR}
            BUILD_BYPRODUCTS ${MAIN_OUTPUT_NAME}
            CMAKE_ARGS
                # ----- Shared options -----

                ${EXANITE_EXTERNAL_PROJECT_ARGS}
                -DCMAKE_INSTALL_PREFIX=${INSTALL_DIR}

                # Force consistent output folders between Debug/Release
                -DCMAKE_ARCHIVE_OUTPUT_DIRECTORY=${INSTALL_DIR}/lib
                -DCMAKE_LIBRARY_OUTPUT_DIRECTORY=${INSTALL_DIR}/lib
                -DCMAKE_RUNTIME_OUTPUT_DIRECTORY=${INSTALL_DIR}/bin
        )
    endblock()
endif()
