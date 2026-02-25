if(NOT TARGET ZLib::ZLib)
    block()
        include("${CMAKE_CURRENT_LIST_DIR}/ExternalProjectUtility.cmake")

        # Define build and install folders
        set(BUILD_PATH ${CMAKE_BINARY_DIR}/build/zlib)
        set(INSTALL_PATH ${CMAKE_BINARY_DIR}/install/zlib)

        # ZLib is named zlibstatic on Windows
        if(WIN32)
            set(ZLIB_LIBRARY_NAME "zlibstatic")
        else()
            set(ZLIB_LIBRARY_NAME "z")
        endif()

        # Define outputs
        set(OUTPUT_PATH "${INSTALL_PATH}/lib/${CMAKE_STATIC_LIBRARY_PREFIX}${ZLIB_LIBRARY_NAME}${CMAKE_STATIC_LIBRARY_SUFFIX}")

        # Add as external project
        get_exanite_external_project_args(EXANITE_EXTERNAL_PROJECT_ARGS ${INSTALL_PATH})
        ExternalProject_Add(External.ZLib
            SOURCE_DIR ${CMAKE_SOURCE_DIR}/native/zlib
            BINARY_DIR ${BUILD_PATH}
            INSTALL_DIR ${INSTALL_PATH}
            BUILD_BYPRODUCTS ${OUTPUT_PATH}
            CMAKE_ARGS
                # ----- Shared options -----

                ${EXANITE_EXTERNAL_PROJECT_ARGS}

                # ----- Dependency specific options -----

                # Build static library
                -DZLIB_BUILD_SHARED=OFF
                -DZLIB_BUILD_STATIC=ON
        )

        # Preemptively create include dir
        file(MAKE_DIRECTORY ${INSTALL_PATH}/include)

        # Define imported targets
        add_library(ZLib STATIC IMPORTED GLOBAL)
        set_target_properties(ZLib
            PROPERTIES
                IMPORTED_LOCATION "${OUTPUT_PATH}"
                INTERFACE_INCLUDE_DIRECTORIES "${INSTALL_PATH}/include"
        )
        add_dependencies(ZLib External.ZLib)

        # Define aliases
        add_library(ZLib::ZLib ALIAS ZLib)
    endblock()
endif()
