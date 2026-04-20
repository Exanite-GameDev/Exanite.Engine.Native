block()
    include("${CMAKE_CURRENT_LIST_DIR}/Utility/ExternalProjectArgs.cmake")

    # Define relevant folders
    set(build_dir ${CMAKE_BINARY_DIR}/build/libpng)
    set(install_dir ${CMAKE_BINARY_DIR}/install/libpng)

    # Define outputs
    if(WIN32)
        set(base_name "png16_static")
    else()
        set(base_name "png16")
    endif()

    set(output_bin "${install_dir}/lib/${CMAKE_STATIC_LIBRARY_PREFIX}${base_name}${CMAKE_STATIC_LIBRARY_SUFFIX}")

    # Define external project
    exanite_get_external_project_args(external_project_args ${install_dir})
    ExternalProject_Add(External.LibPng
        SOURCE_DIR ${CMAKE_SOURCE_DIR}/native/libpng
        BINARY_DIR ${build_dir}
        INSTALL_DIR ${install_dir}
        BUILD_BYPRODUCTS ${output_bin}
        CMAKE_ARGS
            # ----- Shared options -----

            ${external_project_args}

            # ----- Dependency specific options -----

            # Build static library
            -DPNG_SHARED=OFF
            -DPNG_STATIC=ON
            -DPNG_FRAMEWORK=OFF

            # Specify paths for dependencies
            -DZLIB_ROOT=${CMAKE_BINARY_DIR}/install/zlib
    )

    # Define dependencies
    find_package(ZLib REQUIRED)
    add_dependencies(External.LibPng External.ZLib)

    # Preemptively create include dir
    file(MAKE_DIRECTORY ${install_dir}/include)

    # Define imported targets
    add_library(LibPng STATIC IMPORTED GLOBAL)
    set_target_properties(LibPng PROPERTIES IMPORTED_LOCATION "${output_bin}")
    target_include_directories(LibPng INTERFACE  "${install_dir}/include")

    add_dependencies(LibPng External.LibPng)

    # Define aliases
    add_library(LibPng::LibPng ALIAS LibPng)
endblock()
