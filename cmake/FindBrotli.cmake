if(NOT TARGET Brotli::BrotliCommon)
    block()
        include("${CMAKE_CURRENT_LIST_DIR}/ExternalProjectConfig.cmake")

        # Define build and install folders
        set(BUILD_DIR ${CMAKE_BINARY_DIR}/build/brotli)
        set(INSTALL_DIR ${CMAKE_BINARY_DIR}/install/brotli)

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
        set(COMMON_OUTPUT_PATH "${INSTALL_DIR}/lib/${CMAKE_STATIC_LIBRARY_PREFIX}${COMMON_BASE_NAME}${CMAKE_STATIC_LIBRARY_SUFFIX}")
        set(DECODE_OUTPUT_PATH "${INSTALL_DIR}/lib/${CMAKE_STATIC_LIBRARY_PREFIX}${DECODE_BASE_NAME}${CMAKE_STATIC_LIBRARY_SUFFIX}")
        set(ENCODE_OUTPUT_PATH "${INSTALL_DIR}/lib/${CMAKE_STATIC_LIBRARY_PREFIX}${ENCODE_BASE_NAME}${CMAKE_STATIC_LIBRARY_SUFFIX}")

        # Add as external project
        ExternalProject_Add(External.Brotli
            SOURCE_DIR ${CMAKE_SOURCE_DIR}/native/brotli
            BINARY_DIR ${BUILD_DIR}
            INSTALL_DIR ${INSTALL_DIR}
            BUILD_BYPRODUCTS
                ${COMMON_OUTPUT_PATH}
                ${DECODE_OUTPUT_PATH}
                ${ENCODE_OUTPUT_PATH}
            CMAKE_ARGS
                # ----- Shared options -----

                ${EXANITE_EXTERNAL_PROJECT_ARGS}
                -DCMAKE_INSTALL_PREFIX=${INSTALL_DIR}

                # Force consistent output folders between Debug/Release
                -DCMAKE_ARCHIVE_OUTPUT_DIRECTORY=${INSTALL_DIR}/lib
                -DCMAKE_LIBRARY_OUTPUT_DIRECTORY=${INSTALL_DIR}/lib
                -DCMAKE_RUNTIME_OUTPUT_DIRECTORY=${INSTALL_DIR}/bin

                # ----- Dependency specific options -----

                # Build static library
                -DBUILD_SHARED_LIBS=OFF

                -DBROTLI_DISABLE_TESTS=ON

                # This ensures that install works
                -DBROTLI_BUNDLED_MODE=OFF
        )

        # Preemptively create include dir
        file(MAKE_DIRECTORY ${INSTALL_DIR}/include)

        # Define imported targets
        # Common
        add_library(BrotliCommon STATIC IMPORTED GLOBAL)
        set_target_properties(BrotliCommon
            PROPERTIES
                IMPORTED_LOCATION "${COMMON_OUTPUT_PATH}"
                INTERFACE_INCLUDE_DIRECTORIES "${INSTALL_DIR}/include"
        )
        add_dependencies(BrotliCommon External.Brotli)

        # Encode
        add_library(BrotliEncode STATIC IMPORTED GLOBAL)
        set_target_properties(BrotliEncode
            PROPERTIES
                IMPORTED_LOCATION "${ENCODE_OUTPUT_PATH}"
                INTERFACE_INCLUDE_DIRECTORIES "${INSTALL_DIR}/include"
                INTERFACE_LINK_LIBRARIES BrotliCommon
        )
        add_dependencies(BrotliEncode External.Brotli)

        # Decode
        add_library(BrotliDecode STATIC IMPORTED GLOBAL)
        set_target_properties(BrotliDecode
            PROPERTIES
                IMPORTED_LOCATION "${DECODE_OUTPUT_PATH}"
                INTERFACE_INCLUDE_DIRECTORIES "${INSTALL_DIR}/include"
                INTERFACE_LINK_LIBRARIES BrotliCommon
        )
        add_dependencies(BrotliDecode External.Brotli)

        # Define aliases
        add_library(Brotli::BrotliCommon ALIAS BrotliCommon)
        add_library(Brotli::BrotliEncode ALIAS BrotliEncode)
        add_library(Brotli::BrotliDecode ALIAS BrotliDecode)
    endblock()
endif()
