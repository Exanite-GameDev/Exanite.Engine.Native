if(NOT TARGET BZip2::BZip2)
    block()
        include("${CMAKE_CURRENT_LIST_DIR}/ExternalProjectUtility.cmake")

        # Define build and install folders
        set(BUILD_PATH ${CMAKE_BINARY_DIR}/build/bzip2)
        set(INSTALL_PATH ${CMAKE_BINARY_DIR}/install/bzip2)

        # Define output names
        if(WIN32)
            set(BASE_NAME "libbz2")
        else()
            set(BASE_NAME "bz2")
        endif()

        # Define outputs
        set(OUTPUT_PATH "${INSTALL_PATH}/lib/${CMAKE_STATIC_LIBRARY_PREFIX}${BASE_NAME}${CMAKE_STATIC_LIBRARY_SUFFIX}")

        # Add as external project
        get_exanite_external_project_args(EXANITE_EXTERNAL_PROJECT_ARGS ${INSTALL_PATH})
        ExternalProject_Add(External.BZip2
            SOURCE_DIR ${CMAKE_SOURCE_DIR}/native/bzip2
            BINARY_DIR ${BUILD_PATH}
            INSTALL_DIR ${INSTALL_PATH}
            BUILD_BYPRODUCTS ${OUTPUT_PATH}
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
        file(MAKE_DIRECTORY ${INSTALL_PATH}/include)

        # Define imported targets
        add_library(BZip2 STATIC IMPORTED GLOBAL)
        set_target_properties(BZip2
            PROPERTIES
                IMPORTED_LOCATION "${OUTPUT_PATH}"
                INTERFACE_INCLUDE_DIRECTORIES "${INSTALL_PATH}/include"
        )
        add_dependencies(BZip2 External.BZip2)

        # Define aliases
        add_library(BZip2::BZip2 ALIAS BZip2)
    endblock()
endif()
