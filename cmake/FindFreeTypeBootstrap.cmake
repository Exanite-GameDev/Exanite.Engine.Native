if(NOT TARGET External.FreeTypeBootstrap)
    block()
        include("${CMAKE_CURRENT_LIST_DIR}/ExternalProjectConfig.cmake")

        # Define build and install folders
        set(BUILD_DIR "${CMAKE_BINARY_DIR}/build/freetype-bootstrap")
        set(INSTALL_DIR "${CMAKE_BINARY_DIR}/install/freetype-bootstrap")

        # Define import paths
        if(WIN32)
            set(IMPORTED_LOCATION "${INSTALL_DIR}/bin/freetype.dll")
            set(IMPORTED_IMPLIB "${INSTALL_DIR}/lib/freetype.lib")
        else()
            set(IMPORTED_LOCATION "${INSTALL_DIR}/lib/${CMAKE_SHARED_LIBRARY_PREFIX}freetype${CMAKE_SHARED_LIBRARY_SUFFIX}")
        endif()

        # Add as external project
        ExternalProject_Add(External.FreeTypeBootstrap
            SOURCE_DIR "${CMAKE_SOURCE_DIR}/native/freetype"
            BINARY_DIR "${BUILD_DIR}"
            INSTALL_DIR "${INSTALL_DIR}"
            BUILD_BYPRODUCTS "${IMPORTED_LOCATION}"
            CMAKE_ARGS
                # Shared options
                ${EXANITE_EXTERNAL_PROJECT_ARGS}
                -DCMAKE_INSTALL_PREFIX="${INSTALL_DIR}"

                # Force consistent output folders between Debug/Release
                -DCMAKE_ARCHIVE_OUTPUT_DIRECTORY_DEBUG="${INSTALL_DIR}/lib"
                -DCMAKE_LIBRARY_OUTPUT_DIRECTORY_DEBUG="${INSTALL_DIR}/lib"
                -DCMAKE_RUNTIME_OUTPUT_DIRECTORY_DEBUG="${INSTALL_DIR}/bin"

                # Build shared library
                -DBUILD_SHARED_LIBS=ON

                # ----- Dependency specific options -----

                # Disable dependencies since this is the bootstrap build
                -DFT_DISABLE_ZLIB=ON
                -DFT_DISABLE_BZIP2=ON
                -DFT_DISABLE_PNG=ON
                -DFT_DISABLE_HARFBUZZ=ON
                -DFT_DISABLE_BROTLI=ON

                -DFT_REQUIRE_ZLIB=OFF
                -DFT_REQUIRE_BZIP2=OFF
                -DFT_REQUIRE_PNG=OFF
                -DFT_REQUIRE_HARFBUZZ=OFF
                -DFT_REQUIRE_BROTLI=OFF
        )
    endblock()
endif()
