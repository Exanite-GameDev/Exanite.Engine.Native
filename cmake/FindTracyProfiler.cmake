if(NOT TARGET External.TracyProfiler)
    block()
        include("${CMAKE_CURRENT_LIST_DIR}/ExternalProjectUtility.cmake")

        # Define build and install folders
        set(BUILD_PATH ${CMAKE_BINARY_DIR}/build/tracy-profiler)
        set(INSTALL_PATH ${CMAKE_BINARY_DIR}/install/tracy-profiler)

        # Define output names
        set(BASE_NAME "tracy-profiler")

        # Define outputs
        set(OUTPUT_PATH "${INSTALL_PATH}/lib/${CMAKE_STATIC_LIBRARY_PREFIX}${BASE_NAME}${CMAKE_EXECUTABLE_SUFFIX}")

        # Add as external project
        get_exanite_external_project_args(EXANITE_EXTERNAL_PROJECT_ARGS ${INSTALL_PATH})
        ExternalProject_Add(External.TracyProfiler
            SOURCE_DIR ${CMAKE_SOURCE_DIR}/native/tracy/profiler
            BINARY_DIR ${BUILD_PATH}
            INSTALL_DIR ${INSTALL_PATH}
            BUILD_BYPRODUCTS ${OUTPUT_PATH}
            CMAKE_ARGS
                # ----- Shared options -----

                ${EXANITE_EXTERNAL_PROJECT_ARGS}
        )
    endblock()
endif()
