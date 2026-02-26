if(NOT TARGET External.HarfBuzz)
    block()
        include("${CMAKE_CURRENT_LIST_DIR}/Utility/ExternalProjectArgs.cmake")
        find_package(FreeTypeBootstrap REQUIRED)

        # Define build and install folders
        set(BUILD_FOLDER ${CMAKE_BINARY_DIR}/build/harfbuzz)
        set(INSTALL_FOLDER ${CMAKE_BINARY_DIR}/install/harfbuzz)

        # Define output names
        set(BASE_NAME "harfbuzz")

        # Define outputs
        if(WIN32)
            set(OUTPUT_FILE "${INSTALL_FOLDER}/bin/${BASE_NAME}.dll")
            set(IMPORTED_IMPLIB "${INSTALL_FOLDER}/lib/${BASE_NAME}.lib")
        else()
            set(OUTPUT_FILE "${INSTALL_FOLDER}/lib/${CMAKE_SHARED_LIBRARY_PREFIX}${BASE_NAME}${CMAKE_SHARED_LIBRARY_SUFFIX}")
        endif()

        # Add as external project
        get_exanite_external_project_args(EXANITE_EXTERNAL_PROJECT_ARGS ${INSTALL_FOLDER})
        ExternalProject_Add(External.HarfBuzz
            SOURCE_DIR ${CMAKE_SOURCE_DIR}/native/harfbuzz
            BINARY_DIR ${BUILD_FOLDER}
            INSTALL_DIR ${INSTALL_FOLDER}
            # Hack: Don't perform the install step.
            # This avoids the errors caused by trying to symlink while so names are disabled
            INSTALL_COMMAND ""
            BUILD_BYPRODUCTS ${OUTPUT_FILE}
            CMAKE_ARGS
                # ----- Shared options -----

                ${EXANITE_EXTERNAL_PROJECT_ARGS}

                # ----- Dependency specific options -----

                # Build shared library
                -DBUILD_SHARED_LIBS=ON

                # Specify paths for dependencies
                -DCMAKE_PREFIX_PATH=${CMAKE_BINARY_DIR}/install/freetype-bootstrap

                # Enable FreeType integration
                -DHB_HAVE_FREETYPE=ON

                # HarfBuzz's function existence checks seem to be flaky and look at the system libraries instead
                # Let's override them
                -DHAVE_FT_GET_VAR_BLEND_COORDINATES=TRUE
                -DHAVE_FT_SET_VAR_BLEND_COORDINATES=TRUE
                -DHAVE_FT_DONE_MM_VAR=TRUE
                -DHAVE_FT_GET_TRANSFORM=TRUE
        )
        add_dependencies(External.HarfBuzz External.FreeTypeBootstrap)

        # Manually install relevant outputs
        ExternalProject_Add_Step(External.HarfBuzz manual_install
            COMMAND ${CMAKE_COMMAND}
                -DSOURCE_FOLDER=${CMAKE_SOURCE_DIR}/native/harfbuzz/src
                -DINSTALL_FOLDER=${INSTALL_FOLDER}/include/harfbuzz
                -P "${CMAKE_CURRENT_LIST_DIR}/Utility/InstallHeaders.cmake"
            DEPENDEES build
        )

        # Preemptively create include dir
        file(MAKE_DIRECTORY ${INSTALL_FOLDER}/include/harfbuzz)

        # Define imported targets
        add_library(HarfBuzz SHARED IMPORTED GLOBAL)
        set_target_properties(HarfBuzz
            PROPERTIES
                IMPORTED_LOCATION "${OUTPUT_FILE}"
                IMPORTED_IMPLIB "${IMPORTED_IMPLIB}"
                INTERFACE_INCLUDE_DIRECTORIES "${INSTALL_FOLDER}/include/harfbuzz"
        )
        add_dependencies(HarfBuzz External.HarfBuzz)

        # Define aliases
        add_library(HarfBuzz::HarfBuzz ALIAS HarfBuzz)
    endblock()
endif()
