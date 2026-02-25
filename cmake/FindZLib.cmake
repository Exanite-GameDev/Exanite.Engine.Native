if(NOT TARGET ZLib::ZLib)
    block()
        include("${CMAKE_CURRENT_LIST_DIR}/ExternalProjectConfig.cmake")

        # Define build and install folders
        set(BUILD_DIR ${CMAKE_BINARY_DIR}/build/zlib)
        set(INSTALL_DIR ${CMAKE_BINARY_DIR}/install/zlib)

        # ZLib is named zlibstatic on Windows
        if(WIN32)
            set(ZLIB_LIBRARY_NAME "zlibstatic")
        else()
            set(ZLIB_LIBRARY_NAME "z")
        endif()

        # Define outputs
        set(OUTPUT_PATH "${INSTALL_DIR}/lib/${CMAKE_STATIC_LIBRARY_PREFIX}${ZLIB_LIBRARY_NAME}${CMAKE_STATIC_LIBRARY_SUFFIX}")

        # Add as external project
        ExternalProject_Add(External.ZLib
            SOURCE_DIR ${CMAKE_SOURCE_DIR}/native/zlib
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
                -DZLIB_BUILD_SHARED=OFF
                -DZLIB_BUILD_STATIC=ON
        )

        # Preemptively create include dir
        file(MAKE_DIRECTORY ${INSTALL_DIR}/include)

        # Define imported targets
        add_library(ZLib STATIC IMPORTED GLOBAL)
        set_target_properties(ZLib
            PROPERTIES
                IMPORTED_LOCATION "${OUTPUT_PATH}"
                INTERFACE_INCLUDE_DIRECTORIES "${INSTALL_DIR}/include"
        )
        add_dependencies(ZLib External.ZLib)

        # Define aliases
        add_library(ZLib::ZLib ALIAS ZLib)
    endblock()
endif()
