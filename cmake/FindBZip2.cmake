if(NOT TARGET BZip2::BZip2)
    block()
        include("${CMAKE_CURRENT_LIST_DIR}/ExternalProjectUtility.cmake")

        # Define build and install folders
        set(BUILD_FOLDER ${CMAKE_BINARY_DIR}/build/bzip2)
        set(INSTALL_FOLDER ${CMAKE_BINARY_DIR}/install/bzip2)

        # Define output names
        if(WIN32)
            set(BASE_NAME "libbz2")
        else()
            set(BASE_NAME "bz2")
        endif()

        # Define outputs
        set(OUTPUT_FILE "${INSTALL_FOLDER}/lib/${CMAKE_STATIC_LIBRARY_PREFIX}${BASE_NAME}${CMAKE_STATIC_LIBRARY_SUFFIX}")

        # Add as external project
        get_exanite_external_project_args(EXANITE_EXTERNAL_PROJECT_ARGS ${INSTALL_FOLDER})
        ExternalProject_Add(External.BZip2
            SOURCE_DIR ${CMAKE_SOURCE_DIR}/native/bzip2
            BINARY_DIR ${BUILD_FOLDER}
            INSTALL_DIR ${INSTALL_FOLDER}
            BUILD_BYPRODUCTS ${OUTPUT_FILE}
            CMAKE_ARGS
                # ----- Shared options -----

                ${EXANITE_EXTERNAL_PROJECT_ARGS}

                # ----- Dependency specific options -----

                # Build static library
                -DENABLE_STATIC_LIB=ON
                -DENABLE_SHARED_LIB=OFF

                -DENABLE_LIB_ONLY=ON
        )

        # Preemptively create include dir
        file(MAKE_DIRECTORY ${INSTALL_FOLDER}/include)

        # Define imported targets
        add_library(BZip2 STATIC IMPORTED GLOBAL)
        set_target_properties(BZip2
            PROPERTIES
                IMPORTED_LOCATION "${OUTPUT_FILE}"
                INTERFACE_INCLUDE_DIRECTORIES "${INSTALL_FOLDER}/include"
        )
        add_dependencies(BZip2 External.BZip2)

        # Define aliases
        add_library(BZip2::BZip2 ALIAS BZip2)
    endblock()
endif()
