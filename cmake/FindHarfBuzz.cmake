if(NOT TARGET External.HarfBuzz)
    block()
        include("${CMAKE_CURRENT_LIST_DIR}/Utility/ExternalProjectArgs.cmake")

        # Define build and install folders
        set(build_folder ${CMAKE_BINARY_DIR}/build/harfbuzz)
        set(install_folder ${CMAKE_BINARY_DIR}/install/harfbuzz)

        # Define outputs
        set(base_name "harfbuzz")
        if(WIN32)
            set(output_file "${install_folder}/bin/${base_name}.dll")
            set(output_lib "${install_folder}/lib/${base_name}.lib")
        else()
            set(output_file "${install_folder}/lib/${CMAKE_SHARED_LIBRARY_PREFIX}${base_name}${CMAKE_SHARED_LIBRARY_SUFFIX}")
        endif()

        # Add as external project
        exanite_get_external_project_args(EXANITE_EXTERNAL_PROJECT_ARGS ${install_folder})
        ExternalProject_Add(External.HarfBuzz
            SOURCE_DIR ${CMAKE_SOURCE_DIR}/native/harfbuzz
            BINARY_DIR ${build_folder}
            INSTALL_DIR ${install_folder}
            BUILD_BYPRODUCTS
                ${output_file}
                ${output_lib}
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

        # Define dependencies
        find_package(FreeType REQUIRED)
        find_package(FreeTypeBootstrap REQUIRED)
        add_dependencies(External.HarfBuzz External.FreeTypeBootstrap)

        # Preemptively create include dir
        file(MAKE_DIRECTORY ${install_folder}/include/harfbuzz)

        # Define imported targets
        add_library(HarfBuzz SHARED IMPORTED GLOBAL)
        set_target_properties(HarfBuzz PROPERTIES IMPORTED_LOCATION "${output_file}" IMPORTED_IMPLIB "${output_lib}")
        target_include_directories(HarfBuzz INTERFACE "${install_folder}/include/harfbuzz")

        add_dependencies(HarfBuzz External.HarfBuzz)
        target_link_libraries(HarfBuzz INTERFACE FreeType::FreeType)

        # Define aliases
        add_library(HarfBuzz::HarfBuzz ALIAS HarfBuzz)
    endblock()
endif()
