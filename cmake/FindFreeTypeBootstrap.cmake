if(NOT TARGET External.FreeTypeBootstrap)
    block()
        include("${CMAKE_CURRENT_LIST_DIR}/ExternalProjectUtility.cmake")

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
            BUILD_BYPRODUCTS ${OUTPUT_PATH}
            CMAKE_ARGS
                # ----- Shared options -----

                ${EXANITE_EXTERNAL_PROJECT_ARGS}

                # ----- Dependency specific options -----

                # Build shared library
                -DBUILD_SHARED_LIBS=ON

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

        # Preemptively create include dir
        file(MAKE_DIRECTORY ${INSTALL_PATH}/include/freetype2)
    endblock()
endif()
