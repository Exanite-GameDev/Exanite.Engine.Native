if(NOT TARGET LibPng::LibPng)
    block()
        include("${CMAKE_CURRENT_LIST_DIR}/ExternalProjectConfig.cmake")

        find_package(ZLib REQUIRED)

        # Define build and install folders
        set(BUILD_DIR ${CMAKE_BINARY_DIR}/build/libpng)
        set(INSTALL_DIR ${CMAKE_BINARY_DIR}/install/libpng)

        # LibPng is named png_static on Windows
        if(WIN32)
            set(BASE_NAME "png_static")
        else()
            set(BASE_NAME "png")
        endif()

        # Define outputs
        set(OUTPUT_PATH "${INSTALL_DIR}/lib/${CMAKE_STATIC_LIBRARY_PREFIX}${BASE_NAME}${CMAKE_STATIC_LIBRARY_SUFFIX}")

        # Add as external project
        ExternalProject_Add(External.LibPng
            SOURCE_DIR ${CMAKE_SOURCE_DIR}/native/libpng
            BINARY_DIR ${BUILD_DIR}
            INSTALL_DIR ${INSTALL_DIR}
            BUILD_BYPRODUCTS ${OUTPUT_PATH}
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
                -DPNG_SHARED=OFF
                -DPNG_STATIC=ON

                # Specify paths for dependencies
                -DCMAKE_PREFIX_PATH=${CMAKE_BINARY_DIR}/install/zlib
                -DZLIB_ROOT=${CMAKE_BINARY_DIR}/install/zlib
        )
        add_dependencies(External.LibPng External.ZLib)

        # Preemptively create include dir
        file(MAKE_DIRECTORY ${INSTALL_DIR}/include)

        # Define imported target
        add_library(LibPng STATIC IMPORTED GLOBAL)
        set_target_properties(LibPng
            PROPERTIES
                IMPORTED_LOCATION "${OUTPUT_PATH}"
                INTERFACE_INCLUDE_DIRECTORIES "${INSTALL_DIR}/include"
        )
        add_dependencies(LibPng External.LibPng)

        # Define aliases
        add_library(LibPng::LibPng ALIAS LibPng)
    endblock()
endif()
