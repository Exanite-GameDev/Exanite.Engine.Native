if(NOT TARGET External.TracyProfiler)
    block()
        include("${CMAKE_CURRENT_LIST_DIR}/Utility/ExternalProjectArgs.cmake")

        # Define relevant folders
        set(build_dir ${CMAKE_BINARY_DIR}/build/tracy-profiler)
        set(install_dir ${CMAKE_BINARY_DIR}/install/tracy-profiler)

        # Define outputs
        set(base_name "tracy-profiler")
        set(output_bin "${install_dir}/lib/${base_name}${CMAKE_EXECUTABLE_SUFFIX}")

        # Define external project
        exanite_get_external_project_args(external_project_args ${install_dir})
        ExternalProject_Add(External.TracyProfiler
            SOURCE_DIR ${CMAKE_SOURCE_DIR}/native/tracy/profiler
            BINARY_DIR ${build_dir}
            INSTALL_DIR ${install_dir}
            BUILD_BYPRODUCTS ${output_bin}
            CMAKE_ARGS
                # ----- Shared options -----

                ${external_project_args}
        )
    endblock()
endif()
