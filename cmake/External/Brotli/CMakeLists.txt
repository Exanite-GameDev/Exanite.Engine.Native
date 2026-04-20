block()
    include("${CMAKE_CURRENT_LIST_DIR}/Utility/ExternalProjectArgs.cmake")

    # Define relevant folders
    set(build_dir ${CMAKE_SOURCE_DIR}/native/brotli)
    set(build_dir ${CMAKE_BINARY_DIR}/build/brotli)
    set(install_dir ${CMAKE_BINARY_DIR}/install/brotli)

    # Define outputs
    if(WIN32)
        set(common_base_name "brotlicommon-static")
        set(decode_base_name "brotlidec-static")
        set(encode_base_name "brotlienc-static")
    else()
        set(common_base_name "brotlicommon")
        set(decode_base_name "brotlidec")
        set(encode_base_name "brotlienc")
    endif()

    set(common_output_bin "${install_dir}/lib/${CMAKE_STATIC_LIBRARY_PREFIX}${common_base_name}${CMAKE_STATIC_LIBRARY_SUFFIX}")
    set(decode_output_bin "${install_dir}/lib/${CMAKE_STATIC_LIBRARY_PREFIX}${decode_base_name}${CMAKE_STATIC_LIBRARY_SUFFIX}")
    set(encode_output_bin "${install_dir}/lib/${CMAKE_STATIC_LIBRARY_PREFIX}${encode_base_name}${CMAKE_STATIC_LIBRARY_SUFFIX}")

    # Define external project
    exanite_get_external_project_args(external_project_args ${install_dir})
    ExternalProject_Add(External.Brotli
        SOURCE_DIR ${source_dir}
        BINARY_DIR ${build_dir}
        INSTALL_DIR ${install_dir}
        BUILD_BYPRODUCTS
            ${common_output_bin}
            ${decode_output_bin}
            ${encode_output_bin}
        CMAKE_ARGS
            # ----- Shared options -----

            ${external_project_args}

            # ----- Dependency specific options -----

            # Build static library
            -DBUILD_SHARED_LIBS=OFF
            -DBROTLI_BUILD_FOR_PACKAGE=OFF
            -DBROTLI_BUNDLED_MODE=OFF

            -DBROTLI_DISABLE_TESTS=ON
            -DBROTLI_BUILD_TOOLS=OFF
    )

    # Preemptively create include dir
    file(MAKE_DIRECTORY ${install_dir}/include)

    # Define imported targets
    # Common
    add_library(Imported.BrotliCommon STATIC IMPORTED GLOBAL)
    set_target_properties(Imported.BrotliCommon PROPERTIES IMPORTED_LOCATION "${common_output_bin}")
    target_include_directories(Imported.BrotliCommon INTERFACE "${install_dir}/include")

    add_dependencies(Imported.BrotliCommon External.Brotli)

    # Encode
    add_library(Imported.BrotliEncode STATIC IMPORTED GLOBAL)
    set_target_properties(Imported.BrotliEncode PROPERTIES IMPORTED_LOCATION "${encode_output_bin}")
    target_include_directories(Imported.BrotliEncode INTERFACE "${install_dir}/include")

    target_link_libraries(Imported.BrotliEncode INTERFACE Imported.BrotliCommon)

    # Decode
    add_library(Imported.BrotliDecode STATIC IMPORTED GLOBAL)
    set_target_properties(Imported.BrotliDecode PROPERTIES IMPORTED_LOCATION "${decode_output_bin}")
    target_include_directories(Imported.BrotliDecode INTERFACE "${install_dir}/include")

    target_link_libraries(Imported.BrotliDecode INTERFACE Imported.BrotliCommon)
endblock()
