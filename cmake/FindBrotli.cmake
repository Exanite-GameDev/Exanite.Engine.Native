if(NOT TARGET Brotli::BrotliCommon)
    block()
        include("${CMAKE_CURRENT_LIST_DIR}/ExternalProjectUtility.cmake")

        # Define build and install folders
        set(BUILD_FOLDER ${CMAKE_BINARY_DIR}/build/brotli)
        set(INSTALL_FOLDER ${CMAKE_BINARY_DIR}/install/brotli)

        # Define output names
        if(WIN32)
            set(COMMON_BASE_NAME "brotlicommon-static")
            set(DECODE_BASE_NAME "brotlidec-static")
            set(ENCODE_BASE_NAME "brotlienc-static")
        else()
            set(COMMON_BASE_NAME "brotlicommon")
            set(DECODE_BASE_NAME "brotlidec")
            set(ENCODE_BASE_NAME "brotlienc")
        endif()

        # Define outputs
        set(COMMON_OUTPUT_FILE "${INSTALL_FOLDER}/lib/${CMAKE_STATIC_LIBRARY_PREFIX}${COMMON_BASE_NAME}${CMAKE_STATIC_LIBRARY_SUFFIX}")
        set(DECODE_OUTPUT_FILE "${INSTALL_FOLDER}/lib/${CMAKE_STATIC_LIBRARY_PREFIX}${DECODE_BASE_NAME}${CMAKE_STATIC_LIBRARY_SUFFIX}")
        set(ENCODE_OUTPUT_FILE "${INSTALL_FOLDER}/lib/${CMAKE_STATIC_LIBRARY_PREFIX}${ENCODE_BASE_NAME}${CMAKE_STATIC_LIBRARY_SUFFIX}")

        # Add as external project
        get_exanite_external_project_args(EXANITE_EXTERNAL_PROJECT_ARGS ${INSTALL_FOLDER})
        ExternalProject_Add(External.Brotli
            SOURCE_DIR ${CMAKE_SOURCE_DIR}/native/brotli
            BINARY_DIR ${BUILD_FOLDER}
            INSTALL_DIR ${INSTALL_FOLDER}
            BUILD_BYPRODUCTS
                ${COMMON_OUTPUT_FILE}
                ${DECODE_OUTPUT_FILE}
                ${ENCODE_OUTPUT_FILE}
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
        file(MAKE_DIRECTORY ${INSTALL_FOLDER}/include)

        # Define imported targets
        # Common
        add_library(BrotliCommon STATIC IMPORTED GLOBAL)
        set_target_properties(BrotliCommon
            PROPERTIES
                IMPORTED_LOCATION "${COMMON_OUTPUT_FILE}"
                INTERFACE_INCLUDE_DIRECTORIES "${INSTALL_FOLDER}/include"
        )
        add_dependencies(BrotliCommon External.Brotli)

        # Encode
        add_library(BrotliEncode STATIC IMPORTED GLOBAL)
        set_target_properties(BrotliEncode
            PROPERTIES
                IMPORTED_LOCATION "${ENCODE_OUTPUT_FILE}"
                INTERFACE_INCLUDE_DIRECTORIES "${INSTALL_FOLDER}/include"
                INTERFACE_LINK_LIBRARIES BrotliCommon
        )
        add_dependencies(BrotliEncode External.Brotli)

        # Decode
        add_library(BrotliDecode STATIC IMPORTED GLOBAL)
        set_target_properties(BrotliDecode
            PROPERTIES
                IMPORTED_LOCATION "${DECODE_OUTPUT_FILE}"
                INTERFACE_INCLUDE_DIRECTORIES "${INSTALL_FOLDER}/include"
                INTERFACE_LINK_LIBRARIES BrotliCommon
        )
        add_dependencies(BrotliDecode External.Brotli)

        # Define aliases
        add_library(Brotli::BrotliCommon ALIAS BrotliCommon)
        add_library(Brotli::BrotliEncode ALIAS BrotliEncode)
        add_library(Brotli::BrotliDecode ALIAS BrotliDecode)
    endblock()
endif()
