if(NOT TARGET External.Brotli)
    block()
        include("${CMAKE_CURRENT_LIST_DIR}/Utility/ExternalProjectArgs.cmake")

        # Define build and install folders
        set(build_folder ${CMAKE_BINARY_DIR}/build/brotli)
        set(install_folder ${CMAKE_BINARY_DIR}/install/brotli)

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

        set(common_output_file "${install_folder}/lib/${CMAKE_STATIC_LIBRARY_PREFIX}${common_base_name}${CMAKE_STATIC_LIBRARY_SUFFIX}")
        set(decode_output_file "${install_folder}/lib/${CMAKE_STATIC_LIBRARY_PREFIX}${decode_base_name}${CMAKE_STATIC_LIBRARY_SUFFIX}")
        set(encode_output_file "${install_folder}/lib/${CMAKE_STATIC_LIBRARY_PREFIX}${encode_base_name}${CMAKE_STATIC_LIBRARY_SUFFIX}")

        # Add as external project
        get_exanite_external_project_args(EXANITE_EXTERNAL_PROJECT_ARGS ${install_folder})
        ExternalProject_Add(External.Brotli
            SOURCE_DIR ${CMAKE_SOURCE_DIR}/native/brotli
            BINARY_DIR ${build_folder}
            INSTALL_DIR ${install_folder}
            BUILD_BYPRODUCTS
                ${common_output_file}
                ${decode_output_file}
                ${encode_output_file}
            CMAKE_ARGS
                # ----- Shared options -----

                ${EXANITE_EXTERNAL_PROJECT_ARGS}

                # ----- Dependency specific options -----

                # Build static library
                -DBUILD_SHARED_LIBS=OFF
                -DBROTLI_BUILD_FOR_PACKAGE=OFF
                -DBROTLI_BUNDLED_MODE=OFF

                -DBROTLI_DISABLE_TESTS=ON
                -DBROTLI_BUILD_TOOLS=OFF
        )

        # Preemptively create include dir
        file(MAKE_DIRECTORY ${install_folder}/include)

        # Define imported targets
        # Common
        add_library(BrotliCommon STATIC IMPORTED GLOBAL)
        set_target_properties(BrotliCommon
            PROPERTIES
                IMPORTED_LOCATION "${common_output_file}"
                INTERFACE_INCLUDE_DIRECTORIES "${install_folder}/include"
        )
        add_dependencies(BrotliCommon External.Brotli)

        # Encode
        add_library(BrotliEncode STATIC IMPORTED GLOBAL)
        set_target_properties(BrotliEncode
            PROPERTIES
                IMPORTED_LOCATION "${encode_output_file}"
                INTERFACE_INCLUDE_DIRECTORIES "${install_folder}/include"
                INTERFACE_LINK_LIBRARIES BrotliCommon
        )
        add_dependencies(BrotliEncode External.Brotli)

        # Decode
        add_library(BrotliDecode STATIC IMPORTED GLOBAL)
        set_target_properties(BrotliDecode
            PROPERTIES
                IMPORTED_LOCATION "${decode_output_file}"
                INTERFACE_INCLUDE_DIRECTORIES "${install_folder}/include"
                INTERFACE_LINK_LIBRARIES BrotliCommon
        )
        add_dependencies(BrotliDecode External.Brotli)

        # Define aliases
        add_library(Brotli::BrotliCommon ALIAS BrotliCommon)
        add_library(Brotli::BrotliEncode ALIAS BrotliEncode)
        add_library(Brotli::BrotliDecode ALIAS BrotliDecode)
    endblock()
endif()
