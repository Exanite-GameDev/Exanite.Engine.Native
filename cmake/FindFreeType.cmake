if(NOT TARGET External.FreeType)
    block()
        include("${CMAKE_CURRENT_LIST_DIR}/ExternalProjectConfig.cmake")

        find_package(HarfBuzz REQUIRED)

        # Define build and install folders
        set(BUILD_DIR ${CMAKE_BINARY_DIR}/build/freetype)
        set(INSTALL_DIR ${CMAKE_BINARY_DIR}/install/freetype)

        # Define output names
        set(OUTPUT_NAME "freetype")

        # Define outputs
        if(WIN32)
            set(MAIN_OUTPUT "${INSTALL_DIR}/bin/${OUTPUT_NAME}.dll")
            set(IMPORTED_IMPLIB "${INSTALL_DIR}/lib/${OUTPUT_NAME}.lib")
        else()
            set(MAIN_OUTPUT "${INSTALL_DIR}/lib/${CMAKE_SHARED_LIBRARY_PREFIX}${OUTPUT_NAME}${CMAKE_SHARED_LIBRARY_SUFFIX}")
        endif()

        # Add as external project
        ExternalProject_Add(External.FreeType
            SOURCE_DIR ${CMAKE_SOURCE_DIR}/native/freetype
            BINARY_DIR ${BUILD_DIR}
            INSTALL_DIR ${INSTALL_DIR}
            BUILD_BYPRODUCTS ${MAIN_OUTPUT}
            CMAKE_ARGS

                # ----- Shared options -----

                ${EXANITE_EXTERNAL_PROJECT_ARGS}
                -DCMAKE_INSTALL_PREFIX=${INSTALL_DIR}

                # Force consistent output folders between Debug/Release
                -DCMAKE_ARCHIVE_OUTPUT_DIRECTORY=${INSTALL_DIR}/lib
                -DCMAKE_LIBRARY_OUTPUT_DIRECTORY=${INSTALL_DIR}/lib
                -DCMAKE_RUNTIME_OUTPUT_DIRECTORY=${INSTALL_DIR}/bin

                # ----- Dependency specific options -----

                # Build shared library
                -DBUILD_SHARED_LIBS=ON

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
                IMPORTED_LOCATION "${MAIN_OUTPUT}"
                IMPORTED_IMPLIB "${IMPORTED_IMPLIB}"
                INTERFACE_INCLUDE_DIRECTORIES "${INSTALL_DIR}/include/freetype2"
        )
        add_dependencies(FreeType External.FreeType)

        # Define aliases
        add_library(FreeType::FreeType ALIAS FreeType)
    endblock()
endif()
