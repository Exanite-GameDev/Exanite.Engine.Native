if(NOT TARGET LibPng::LibPng)
    block()
        include("${CMAKE_CURRENT_LIST_DIR}/ExternalProjectConfig.cmake")

        find_package(ZLib REQUIRED)

        # Define build and install folders
        set(BUILD_DIR ${CMAKE_BINARY_DIR}/build/libpng)
        set(INSTALL_DIR ${CMAKE_BINARY_DIR}/install/libpng)

        # LibPng is named libpng16_static on Windows
        if(WIN32)
            set(LIBPNG_LIBRARY_NAME "libpng16_static")
        else()
            set(LIBPNG_LIBRARY_NAME "libpng16")
        endif()

        # Define import paths
        set(IMPORTED_LOCATION "${INSTALL_DIR}/lib/${CMAKE_STATIC_LIBRARY_PREFIX}${LIBPNG_LIBRARY_NAME}${CMAKE_STATIC_LIBRARY_SUFFIX}")

        # Add as external project
        ExternalProject_Add(External.LibPng
            SOURCE_DIR ${CMAKE_SOURCE_DIR}/native/libpng
            BINARY_DIR ${BUILD_DIR}
            INSTALL_DIR ${INSTALL_DIR}
            BUILD_BYPRODUCTS "${INSTALL_DIR}/lib/${CMAKE_STATIC_LIBRARY_PREFIX}${LIBPNG_LIBRARY_NAME}${CMAKE_STATIC_LIBRARY_SUFFIX}"
            CMAKE_ARGS
                # Shared options
                ${EXANITE_EXTERNAL_PROJECT_ARGS}
                -DCMAKE_INSTALL_PREFIX=${INSTALL_DIR}

                # Force consistent output folders between Debug/Release
                -DCMAKE_ARCHIVE_OUTPUT_DIRECTORY_DEBUG=${INSTALL_DIR}/lib
                -DCMAKE_LIBRARY_OUTPUT_DIRECTORY_DEBUG=${INSTALL_DIR}/lib
                -DCMAKE_RUNTIME_OUTPUT_DIRECTORY_DEBUG=${INSTALL_DIR}/bin

                # Build static library
                -DBUILD_SHARED_LIBS=OFF

                # ----- Dependency specific options -----

                # Add prefixes for dependencies
                -DCMAKE_PREFIX_PATH=${CMAKE_BINARY_DIR}/install/zlib
        )

        # Preemptively create include dir
        file(MAKE_DIRECTORY ${INSTALL_DIR}/include)

        # Define imported target
        add_library(LibPng STATIC IMPORTED GLOBAL)
        set_target_properties(LibPng
            PROPERTIES
                IMPORTED_LOCATION "${IMPORTED_LOCATION}"
                INTERFACE_INCLUDE_DIRECTORIES "${INSTALL_DIR}/include"
        )
        add_dependencies(LibPng External.LibPng)

        # Define aliases
        add_library(LibPng::LibPng ALIAS LibPng)
    endblock()
endif()
