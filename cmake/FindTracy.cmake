if(NOT TARGET Tracy::TracyClient)
    block()
        include("${CMAKE_CURRENT_LIST_DIR}/Utility/ExternalProjectArgs.cmake")

        # Define build and install folders
        set(BUILD_FOLDER ${CMAKE_BINARY_DIR}/build/tracy)
        set(INSTALL_FOLDER ${CMAKE_BINARY_DIR}/install/tracy)

        # Define output names
        set(BASE_NAME "TracyClient")

        # Define outputs
        set(OUTPUT_FILE "${INSTALL_FOLDER}/lib/${CMAKE_STATIC_LIBRARY_PREFIX}${BASE_NAME}${CMAKE_STATIC_LIBRARY_SUFFIX}")

        # Add as external project
        get_exanite_external_project_args(EXANITE_EXTERNAL_PROJECT_ARGS ${INSTALL_FOLDER})
        ExternalProject_Add(External.Tracy
            SOURCE_DIR ${CMAKE_SOURCE_DIR}/native/tracy
            BINARY_DIR ${BUILD_FOLDER}
            INSTALL_DIR ${INSTALL_FOLDER}
            BUILD_BYPRODUCTS ${OUTPUT_FILE}
            CMAKE_ARGS
                # ----- Shared options -----

                ${EXANITE_EXTERNAL_PROJECT_ARGS}

                # ----- Dependency specific options -----

                # Build static library
                -DBUILD_SHARED_LIBS=OFF
                -DTRACY_STATIC=ON
                -DTRACY_LTO=OFF

                -DTRACY_ENABLE=ON
                -DTRACY_ON_DEMAND=ON
        )

        # Preemptively create include dir
        file(MAKE_DIRECTORY ${INSTALL_FOLDER}/include/tracy)

        # Define imported targets
        add_library(TracyClient STATIC IMPORTED GLOBAL)
        set_target_properties(TracyClient
            PROPERTIES
                IMPORTED_LOCATION "${OUTPUT_FILE}"
                INTERFACE_INCLUDE_DIRECTORIES "${INSTALL_FOLDER}/include/tracy"
        )
        add_dependencies(TracyClient External.Tracy)

        # Define aliases
        add_library(Tracy::TracyClient ALIAS TracyClient)
    endblock()
endif()
