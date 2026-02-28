if(NOT TARGET External.TracyProfiler)
    block()
        include("${CMAKE_CURRENT_LIST_DIR}/Utility/ExternalProjectArgs.cmake")

        # Define build and install folders
        set(build_folder ${CMAKE_BINARY_DIR}/build/tracy-profiler)
        set(install_folder ${CMAKE_BINARY_DIR}/install/tracy-profiler)

        # Define outputs
        set(base_name "tracy-profiler")
        set(output_file "${install_folder}/lib/${base_name}${CMAKE_EXECUTABLE_SUFFIX}")

        # Add as external project
        exanite_get_external_project_args(exanite_external_project_args ${install_folder})
        ExternalProject_Add(External.TracyProfiler
            SOURCE_DIR ${CMAKE_SOURCE_DIR}/native/tracy/profiler
            BINARY_DIR ${build_folder}
            INSTALL_DIR ${install_folder}
            BUILD_BYPRODUCTS ${output_file}
            CMAKE_ARGS
                # ----- Shared options -----

                ${exanite_external_project_args}
        )
    endblock()
endif()
