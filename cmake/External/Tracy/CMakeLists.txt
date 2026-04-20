if(NOT TARGET Tracy::TracyClient)
    block()
        include("${CMAKE_CURRENT_LIST_DIR}/Utility/ExternalProjectArgs.cmake")

        # Define relevant folders
        set(build_dir ${CMAKE_BINARY_DIR}/build/tracy)
        set(install_dir ${CMAKE_BINARY_DIR}/install/tracy)

        # Define outputs
        set(base_name "TracyClient")
        set(output_bin "${install_dir}/lib/${CMAKE_STATIC_LIBRARY_PREFIX}${base_name}${CMAKE_STATIC_LIBRARY_SUFFIX}")

        # Define external project
        exanite_get_external_project_args(external_project_args ${install_dir})
        ExternalProject_Add(External.Tracy
            SOURCE_DIR ${CMAKE_SOURCE_DIR}/native/tracy
            BINARY_DIR ${build_dir}
            INSTALL_DIR ${install_dir}
            BUILD_BYPRODUCTS ${output_bin}
            CMAKE_ARGS
                # ----- Shared options -----

                ${external_project_args}

                # ----- Dependency specific options -----

                # Build static library
                -DBUILD_SHARED_LIBS=OFF
                -DTRACY_STATIC=ON
                -DTRACY_LTO=OFF

                -DTRACY_ENABLE=ON
                -DTRACY_ON_DEMAND=ON
        )

        # Preemptively create include dir
        file(MAKE_DIRECTORY ${install_dir}/include/tracy)

        # Define imported targets
        add_library(TracyClient STATIC IMPORTED GLOBAL)
        set_target_properties(TracyClient PROPERTIES IMPORTED_LOCATION "${output_bin}")
        target_include_directories(TracyClient INTERFACE "${install_dir}/include/tracy")

        add_dependencies(TracyClient External.Tracy)

        # Define aliases
        add_library(Tracy::TracyClient ALIAS TracyClient)
    endblock()
endif()
