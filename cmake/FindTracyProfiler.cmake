if(NOT TARGET External.TracyProfiler)
    block()
        include("${CMAKE_CURRENT_LIST_DIR}/Utility/ExternalProjectArgs.cmake")

        # Define build and install folders
        set(BUILD_FOLDER ${CMAKE_BINARY_DIR}/build/tracy-profiler)
        set(INSTALL_FOLDER ${CMAKE_BINARY_DIR}/install/tracy-profiler)

        # Define output names
        set(BASE_NAME "tracy-profiler")

        # Define outputs
        set(OUTPUT_FILE "${INSTALL_FOLDER}/lib/${BASE_NAME}${CMAKE_EXECUTABLE_SUFFIX}")

        # Add as external project
        get_exanite_external_project_args(EXANITE_EXTERNAL_PROJECT_ARGS ${INSTALL_FOLDER})
        ExternalProject_Add(External.TracyProfiler
            SOURCE_DIR ${CMAKE_SOURCE_DIR}/native/tracy/profiler
            BINARY_DIR ${BUILD_FOLDER}
            INSTALL_DIR ${INSTALL_FOLDER}
            BUILD_BYPRODUCTS ${OUTPUT_FILE}
            CMAKE_ARGS
                # ----- Shared options -----

                ${EXANITE_EXTERNAL_PROJECT_ARGS}
        )
    endblock()
endif()
