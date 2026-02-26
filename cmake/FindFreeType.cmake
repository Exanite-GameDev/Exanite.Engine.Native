if(NOT TARGET External.FreeType)
    block()
        include("${CMAKE_CURRENT_LIST_DIR}/ExternalProjectUtility.cmake")
        find_package(HarfBuzz REQUIRED)

        # Define build and install folders
        set(BUILD_PATH ${CMAKE_BINARY_DIR}/build/freetype)
        set(INSTALL_PATH ${CMAKE_BINARY_DIR}/install/freetype)

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
        ExternalProject_Add(External.FreeType
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

                # Build shared library
                -DBUILD_SHARED_LIBS=ON

                # Specify paths for dependencies
                -DCMAKE_PREFIX_PATH=${CMAKE_BINARY_DIR}/install/harfbuzz
                -DZLIB_ROOT=${CMAKE_BINARY_DIR}/install/zlib
                -DPNG_ROOT=${CMAKE_BINARY_DIR}/install/libpng
                -DBrotliDec_ROOT=${CMAKE_BINARY_DIR}/install/brotli

                # Specify custom config header
                -DFTCONFIG_H_NAME=${CMAKE_CURRENT_LIST_DIR}/FreeType/ftoption.h

                # Enable harfbuzz since this is the final build
                -DFT_REQUIRE_HARFBUZZ=ON
                -DFT_DISABLE_HARFBUZZ=OFF

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
                -DFT_REQUIRE_BZIP2=OFF
                -DFT_DISABLE_BZIP2=ON
        )
        add_dependencies(External.FreeType External.HarfBuzz)

        # Preemptively create include dir
        file(MAKE_DIRECTORY ${INSTALL_PATH}/include/freetype2)

        # Define imported targets
        add_library(FreeType SHARED IMPORTED GLOBAL)
        set_target_properties(FreeType
            PROPERTIES
                IMPORTED_LOCATION "${OUTPUT_PATH}"
                IMPORTED_IMPLIB "${IMPORTED_IMPLIB}"
                INTERFACE_INCLUDE_DIRECTORIES "${INSTALL_PATH}/include/freetype2"
        )
        add_dependencies(FreeType External.FreeType)

        # Define aliases
        add_library(FreeType::FreeType ALIAS FreeType)
    endblock()
endif()
