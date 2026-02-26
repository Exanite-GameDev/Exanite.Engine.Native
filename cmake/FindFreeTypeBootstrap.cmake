if(NOT TARGET External.FreeTypeBootstrap)
    block()
        include("${CMAKE_CURRENT_LIST_DIR}/ExternalProjectUtility.cmake")
        find_package(ZLib REQUIRED)
        find_package(LibPng REQUIRED)
        find_package(Brotli REQUIRED)

        # Define build and install folders
        set(BUILD_PATH ${CMAKE_BINARY_DIR}/build/freetype-bootstrap)
        set(INSTALL_PATH ${CMAKE_BINARY_DIR}/install/freetype-bootstrap)

        # Define output names
        set(BASE_NAME "freetype")

        # Define outputs
        if(WIN32)
            set(OUTPUT_PATH "${INSTALL_PATH}/bin/${BASE_NAME}.dll")
            set(IMPORTED_IMPLIB "${INSTALL_PATH}/lib/${BASE_NAME}.lib")
        else()
            set(OUTPUT_PATH "${INSTALL_PATH}/lib/${CMAKE_SHARED_LIBRARY_PREFIX}${BASE_NAME}${CMAKE_SHARED_LIBRARY_SUFFIX}")
        endif()

        # Add as external project
        get_exanite_external_project_args(EXANITE_EXTERNAL_PROJECT_ARGS ${INSTALL_PATH})
        ExternalProject_Add(External.FreeTypeBootstrap
            SOURCE_DIR ${CMAKE_SOURCE_DIR}/native/freetype
            BINARY_DIR ${BUILD_PATH}
            INSTALL_DIR ${INSTALL_PATH}
            # Hack: Don't perform the install step.
            # Somehow, this still installs the shared object file successfully,
            # but avoids the errors caused by trying to symlink while so names are disabled
            INSTALL_COMMAND ""
            BUILD_BYPRODUCTS ${OUTPUT_PATH}
            CMAKE_ARGS
                # ----- Shared options -----

                ${EXANITE_EXTERNAL_PROJECT_ARGS}

                # ----- Dependency specific options -----

                # Specify paths for dependencies
                -DZLIB_ROOT=${CMAKE_BINARY_DIR}/install/zlib
                -DPNG_ROOT=${CMAKE_BINARY_DIR}/install/libpng
                -DBrotliDec_ROOT=${CMAKE_BINARY_DIR}/install/brotli

                # Build shared library
                -DBUILD_SHARED_LIBS=ON

                # Disable harfbuzz since this is the bootstrap build
                -DFT_REQUIRE_HARFBUZZ=OFF
                -DFT_DISABLE_HARFBUZZ=ON

                # zlib, brotli add support for compressed fonts
                # png adds support for colored emojis
                # harfbuzz adds support for improved hinting
                -DFT_REQUIRE_ZLIB=ON
                -DFT_REQUIRE_PNG=ON
                -DFT_REQUIRE_BROTLI=ON

                -DFT_DISABLE_ZLIB=OFF
                -DFT_DISABLE_PNG=OFF
                -DFT_DISABLE_BROTLI=OFF

                # Disable bzip since it only adds support for very old Linux fonts (.pcf.bz2)
                -DFT_DISABLE_BZIP2=ON
                -DFT_REQUIRE_BZIP2=OFF
        )
        add_dependencies(External.FreeTypeBootstrap External.ZLib)
        add_dependencies(External.FreeTypeBootstrap External.LibPng)
        add_dependencies(External.FreeTypeBootstrap External.Brotli)
    endblock()
endif()
