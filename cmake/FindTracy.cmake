if(NOT TARGET Tracy::TracyClient)
    block()
        include("${CMAKE_CURRENT_LIST_DIR}/Utility/ExternalProjectArgs.cmake")

        # Define build and install folders
        set(build_folder ${CMAKE_BINARY_DIR}/build/tracy)
        set(install_folder ${CMAKE_BINARY_DIR}/install/tracy)

        # Define outputs
        set(base_name "TracyClient")
        set(output_file "${install_folder}/lib/${CMAKE_STATIC_LIBRARY_PREFIX}${base_name}${CMAKE_STATIC_LIBRARY_SUFFIX}")

        # Add as external project
        exanite_get_external_project_args(EXANITE_EXTERNAL_PROJECT_ARGS ${install_folder})
        ExternalProject_Add(External.Tracy
            SOURCE_DIR ${CMAKE_SOURCE_DIR}/native/tracy
            BINARY_DIR ${build_folder}
            INSTALL_DIR ${install_folder}
            BUILD_BYPRODUCTS ${output_file}
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
        file(MAKE_DIRECTORY ${install_folder}/include/tracy)

        # Define imported targets
        add_library(TracyClient STATIC IMPORTED GLOBAL)
        set_target_properties(TracyClient PROPERTIES IMPORTED_LOCATION "${output_file}")
        target_include_directories(TracyClient INTERFACE "${install_folder}/include/tracy")

        add_dependencies(TracyClient External.Tracy)

        # Define aliases
        add_library(Tracy::TracyClient ALIAS TracyClient)
    endblock()
endif()
