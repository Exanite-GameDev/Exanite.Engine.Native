if(NOT TARGET External.FreeType)
    block()
        # Define build and install directories
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
                -DCMAKE_INSTALL_PREFIX=${INSTALL_DIR}
                -DCMAKE_POSITION_INDEPENDENT_CODE=ON

                -DCMAKE_BUILD_TYPE=${CMAKE_BUILD_TYPE}

                # Require Harfbuzz (improves hinting)
                -DFT_REQUIRE_HARFBUZZ=ON

                # Build shared library
                -DBUILD_SHARED_LIBS=ON

                # Force consistent output folders between Debug/Release
                -DCMAKE_ARCHIVE_OUTPUT_DIRECTORY_DEBUG=${INSTALL_DIR}/lib
                -DCMAKE_LIBRARY_OUTPUT_DIRECTORY_DEBUG=${INSTALL_DIR}/lib
                -DCMAKE_RUNTIME_OUTPUT_DIRECTORY_DEBUG=${INSTALL_DIR}/bin
        )

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
