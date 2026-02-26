if(NOT TARGET External.HarfBuzz)
    block()
        include("${CMAKE_CURRENT_LIST_DIR}/ExternalProjectUtility.cmake")
        find_package(FreeTypeBootstrap REQUIRED)

        # Define build and install folders
        set(BUILD_PATH ${CMAKE_BINARY_DIR}/build/harfbuzz)
        set(INSTALL_PATH ${CMAKE_BINARY_DIR}/install/harfbuzz)

        # Define output names
        set(BASE_NAME "harfbuzz")

        # Define outputs
        if(WIN32)
            set(OUTPUT_PATH "${INSTALL_PATH}/bin/${BASE_NAME}.dll")
            set(IMPORTED_IMPLIB "${INSTALL_PATH}/lib/${BASE_NAME}.lib")
        else()
            set(OUTPUT_PATH "${INSTALL_PATH}/lib/${CMAKE_SHARED_LIBRARY_PREFIX}${BASE_NAME}${CMAKE_SHARED_LIBRARY_SUFFIX}")
        endif()

        # Add as external project
        get_exanite_external_project_args(EXANITE_EXTERNAL_PROJECT_ARGS ${INSTALL_PATH})
        ExternalProject_Add(External.HarfBuzz
            SOURCE_DIR ${CMAKE_SOURCE_DIR}/native/harfbuzz
            BINARY_DIR ${BUILD_PATH}
            INSTALL_DIR ${INSTALL_PATH}
            # Hack: Don't perform the install step.
            # Somehow, this still installs the shared object file successfully,
            # but avoids the errors caused by trying to symlink while so names are disabled
            INSTALL_COMMAND ""
            BUILD_BYPRODUCTS ${OUTPUT_PATH}
            CMAKE_ARGS
                # ----- Shared options -----

                ${EXANITE_EXTERNAL_PROJECT_ARGS}

                # ----- Dependency specific options -----

                # Build shared library
                -DBUILD_SHARED_LIBS=ON

                # Specify paths for dependencies
                -DCMAKE_PREFIX_PATH=${CMAKE_BINARY_DIR}/install/freetype-bootstrap

                # Enable freetype integration
                -DHB_HAVE_FREETYPE=ON
        )
        add_dependencies(External.HarfBuzz External.FreeTypeBootstrap)

        # Preemptively create include dir
        file(MAKE_DIRECTORY ${INSTALL_PATH}/include/harfbuzz)

        # Define imported targets
        add_library(HarfBuzz SHARED IMPORTED GLOBAL)
        set_target_properties(HarfBuzz
            PROPERTIES
                IMPORTED_LOCATION "${OUTPUT_PATH}"
                IMPORTED_IMPLIB "${IMPORTED_IMPLIB}"
                INTERFACE_INCLUDE_DIRECTORIES "${INSTALL_PATH}/include/harfbuzz"
        )
        add_dependencies(HarfBuzz External.HarfBuzz)

        # Define aliases
        add_library(HarfBuzz::HarfBuzz ALIAS HarfBuzz)
    endblock()
endif()
