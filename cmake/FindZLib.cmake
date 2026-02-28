if(NOT TARGET ZLib::ZLib)
    block()
        include("${CMAKE_CURRENT_LIST_DIR}/Utility/ExternalProjectArgs.cmake")

        # Define build and install folders
        set(build_folder ${CMAKE_BINARY_DIR}/build/zlib)
        set(install_folder ${CMAKE_BINARY_DIR}/install/zlib)

        # Define outputs
        if(WIN32)
            set(base_name "zlibstatic")
        else()
            set(base_name "z")
        endif()

        set(output_file "${install_folder}/lib/${CMAKE_STATIC_LIBRARY_PREFIX}${base_name}${CMAKE_STATIC_LIBRARY_SUFFIX}")

        # Add as external project
        get_exanite_external_project_args(EXANITE_EXTERNAL_PROJECT_ARGS ${install_folder})
        ExternalProject_Add(External.ZLib
            SOURCE_DIR ${CMAKE_SOURCE_DIR}/native/zlib
            BINARY_DIR ${build_folder}
            INSTALL_DIR ${install_folder}
            BUILD_BYPRODUCTS ${output_file}
            CMAKE_ARGS
                # ----- Shared options -----

                ${EXANITE_EXTERNAL_PROJECT_ARGS}

                # ----- Dependency specific options -----

                # Build static library
                -DZLIB_BUILD_SHARED=OFF
                -DZLIB_BUILD_STATIC=ON
        )

        # Preemptively create include dir
        file(MAKE_DIRECTORY ${install_folder}/include)

        # Define imported targets
        add_library(ZLib STATIC IMPORTED GLOBAL)
        set_target_properties(ZLib
            PROPERTIES
                IMPORTED_LOCATION "${output_file}"
                INTERFACE_INCLUDE_DIRECTORIES "${install_folder}/include"
        )
        add_dependencies(ZLib External.ZLib)

        # Define aliases
        add_library(ZLib::ZLib ALIAS ZLib)
    endblock()
endif()
