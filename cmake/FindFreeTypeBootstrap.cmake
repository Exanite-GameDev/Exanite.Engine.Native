if(NOT TARGET External.FreeTypeBootstrap)
    block()
        include("${CMAKE_CURRENT_LIST_DIR}/ExternalProjectConfig.cmake")

        # Define build and install folders
        set(BUILD_DIR ${CMAKE_BINARY_DIR}/build/freetype-bootstrap)
        set(INSTALL_DIR ${CMAKE_BINARY_DIR}/install/freetype-bootstrap)

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
        ExternalProject_Add(External.FreeTypeBootstrap
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
        file(MAKE_DIRECTORY ${INSTALL_DIR}/include/freetype2)
    endblock()
endif()
