if(NOT TARGET Brotli::BrotliCommon)
    block()
        include("${CMAKE_CURRENT_LIST_DIR}/ExternalProjectConfig.cmake")

        # Define build and install folders
        set(BUILD_DIR ${CMAKE_BINARY_DIR}/build/brotli-common)
        set(INSTALL_DIR ${CMAKE_BINARY_DIR}/install/brotli-common)

        # Define output names
        set(COMMON_OUTPUT_NAME "brotlicommon")

        # Define outputs
        set(COMMON_OUTPUT "${INSTALL_DIR}/lib/${CMAKE_STATIC_LIBRARY_PREFIX}${COMMON_OUTPUT_NAME}${CMAKE_STATIC_LIBRARY_SUFFIX}")

        # Add as external project
        ExternalProject_Add(External.Brotli
                SOURCE_DIR ${CMAKE_SOURCE_DIR}/native/brotli
                BINARY_DIR ${BUILD_DIR}
                INSTALL_DIR ${INSTALL_DIR}
                BUILD_BYPRODUCTS ${COMMON_OUTPUT}
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

        # Define imported target
        add_library(BrotliCommon STATIC IMPORTED GLOBAL)
        set_target_properties(BrotliCommon
                PROPERTIES
                IMPORTED_LOCATION "${COMMON_OUTPUT}"
                INTERFACE_INCLUDE_DIRECTORIES "${INSTALL_DIR}/include"
        )
        add_dependencies(BrotliCommon External.Brotli)

        # Define aliases
        add_library(Brotli::BrotliCommon ALIAS BrotliCommon)
    endblock()
endif()
