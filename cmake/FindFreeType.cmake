if(NOT TARGET External.FreeType)
    block()
        include("${CMAKE_CURRENT_LIST_DIR}/ExternalProjectConfig.cmake")

        find_package(HarfBuzz REQUIRED)

        # Define build and install folders
        set(BUILD_DIR ${CMAKE_BINARY_DIR}/build/freetype)
        set(INSTALL_DIR ${CMAKE_BINARY_DIR}/install/freetype)

        # Define import paths
        if(WIN32)
            set(IMPORTED_LOCATION "${INSTALL_DIR}/bin/freetype.dll")
            set(IMPORTED_IMPLIB "${INSTALL_DIR}/lib/freetype.lib")
        else()
            set(IMPORTED_LOCATION "${INSTALL_DIR}/lib/${CMAKE_SHARED_LIBRARY_PREFIX}freetype${CMAKE_SHARED_LIBRARY_SUFFIX}")
        endif()

        # Add as external project
        ExternalProject_Add(External.FreeType
            SOURCE_DIR ${CMAKE_SOURCE_DIR}/native/freetype
            BINARY_DIR ${BUILD_DIR}
            INSTALL_DIR ${INSTALL_DIR}
            BUILD_BYPRODUCTS "${INSTALL_DIR}/lib/${CMAKE_SHARED_LIBRARY_PREFIX}freetype${CMAKE_SHARED_LIBRARY_SUFFIX}"
            CMAKE_ARGS
                # Shared options
                ${EXANITE_EXTERNAL_PROJECT_ARGS}
                -DCMAKE_INSTALL_PREFIX=${INSTALL_DIR}

                # Force consistent output folders between Debug/Release
                -DCMAKE_ARCHIVE_OUTPUT_DIRECTORY_DEBUG=${INSTALL_DIR}/lib
                -DCMAKE_LIBRARY_OUTPUT_DIRECTORY_DEBUG=${INSTALL_DIR}/lib
                -DCMAKE_RUNTIME_OUTPUT_DIRECTORY_DEBUG=${INSTALL_DIR}/bin

                # Build shared library
                -DBUILD_SHARED_LIBS=ON

                # ----- Dependency specific options -----

                # Specify paths for dependencies
                -DCMAKE_PREFIX_PATH=${CMAKE_BINARY_DIR}/install/harfbuzz

                # Enable dependencies since this is the final build
                # zlib, brotli add support for compressed fonts
                # png adds support for colored emojis
                # harfbuzz adds support for improved hinting
                -DFT_DISABLE_ZLIB=OFF
                -DFT_DISABLE_PNG=OFF
                -DFT_DISABLE_HARFBUZZ=OFF
                -DFT_DISABLE_BROTLI=OFF

                -DFT_REQUIRE_ZLIB=ON
                -DFT_REQUIRE_PNG=ON
                -DFT_REQUIRE_HARFBUZZ=ON
                -DFT_REQUIRE_BROTLI=ON

                # Disable bzip since it only adds support for very old Linux fonts (.pcf.bz2)
                -DFT_DISABLE_BZIP2=ON
                -DFT_REQUIRE_BZIP2=OFF
        )
        add_dependencies(External.FreeType External.HarfBuzz)

        # Preemptively create include dir
        file(MAKE_DIRECTORY ${INSTALL_DIR}/include/freetype2)

        # Define imported target
        add_library(FreeType SHARED IMPORTED GLOBAL)
        set_target_properties(FreeType
            PROPERTIES
                IMPORTED_LOCATION "${IMPORTED_LOCATION}"
                IMPORTED_IMPLIB "${IMPORTED_IMPLIB}"
                INTERFACE_INCLUDE_DIRECTORIES "${INSTALL_DIR}/include/freetype2"
        )
        add_dependencies(FreeType External.FreeType)

        # Define aliases
        add_library(FreeType::FreeType ALIAS FreeType)
    endblock()
endif()
