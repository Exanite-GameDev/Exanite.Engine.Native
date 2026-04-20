block()
    include("${CMAKE_CURRENT_LIST_DIR}/Utility/ExternalProjectArgs.cmake")

    # Define relevant folders
    set(build_dir ${CMAKE_BINARY_DIR}/build/zlib)
    set(install_dir ${CMAKE_BINARY_DIR}/install/zlib)

    # Define outputs
    if(WIN32)
        set(base_name "zlibstatic")
    else()
        set(base_name "z")
    endif()

    set(output_bin "${install_dir}/lib/${CMAKE_STATIC_LIBRARY_PREFIX}${base_name}${CMAKE_STATIC_LIBRARY_SUFFIX}")

    # Define external project
    exanite_get_external_project_args(external_project_args ${install_dir})
    ExternalProject_Add(External.ZLib
        SOURCE_DIR ${CMAKE_SOURCE_DIR}/native/zlib
        BINARY_DIR ${build_dir}
        INSTALL_DIR ${install_dir}
        BUILD_BYPRODUCTS ${output_bin}
        CMAKE_ARGS
            # ----- Shared options -----

            ${external_project_args}

            # ----- Dependency specific options -----

            # Build static library
            -DZLIB_BUILD_SHARED=OFF
            -DZLIB_BUILD_STATIC=ON
    )

    # Preemptively create include dir
    file(MAKE_DIRECTORY ${install_dir}/include)

    # Define imported targets
    add_library(ZLib STATIC IMPORTED GLOBAL)
    set_target_properties(ZLib PROPERTIES IMPORTED_LOCATION "${output_bin}")
    target_include_directories(ZLib INTERFACE "${install_dir}/include")

    add_dependencies(ZLib External.ZLib)

    # Define aliases
    add_library(ZLib::ZLib ALIAS ZLib)
endblock()
