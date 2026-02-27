if(NOT TARGET LibPng::LibPng)
    block()
        include("${CMAKE_CURRENT_LIST_DIR}/Utility/ExternalProjectArgs.cmake")
        find_package(ZLib REQUIRED)

        # Define build and install folders
        set(BUILD_FOLDER ${CMAKE_BINARY_DIR}/build/libpng)
        set(INSTALL_FOLDER ${CMAKE_BINARY_DIR}/install/libpng)

        # Define outputs
        if(WIN32)
            set(BASE_NAME "png16_static")
        else()
            set(BASE_NAME "png16")
        endif()

        set(OUTPUT_FILE "${INSTALL_FOLDER}/lib/${CMAKE_STATIC_LIBRARY_PREFIX}${BASE_NAME}${CMAKE_STATIC_LIBRARY_SUFFIX}")

        # Add as external project
        get_exanite_external_project_args(EXANITE_EXTERNAL_PROJECT_ARGS ${INSTALL_FOLDER})
        ExternalProject_Add(External.LibPng
            SOURCE_DIR ${CMAKE_SOURCE_DIR}/native/libpng
            BINARY_DIR ${BUILD_FOLDER}
            INSTALL_DIR ${INSTALL_FOLDER}
            BUILD_BYPRODUCTS ${OUTPUT_FILE}
            CMAKE_ARGS
                # ----- Shared options -----

                ${EXANITE_EXTERNAL_PROJECT_ARGS}

                # ----- Dependency specific options -----

                # Build static library
                -DPNG_SHARED=OFF
                -DPNG_STATIC=ON
                -DPNG_FRAMEWORK=OFF

                # Specify paths for dependencies
                -DZLIB_ROOT=${CMAKE_BINARY_DIR}/install/zlib
        )
        add_dependencies(External.LibPng External.ZLib)

        # Preemptively create include dir
        file(MAKE_DIRECTORY ${INSTALL_FOLDER}/include)

        # Define imported targets
        add_library(LibPng STATIC IMPORTED GLOBAL)
        set_target_properties(LibPng
            PROPERTIES
                IMPORTED_LOCATION "${OUTPUT_FILE}"
                INTERFACE_INCLUDE_DIRECTORIES "${INSTALL_FOLDER}/include"
        )
        add_dependencies(LibPng External.LibPng)

        # Define aliases
        add_library(LibPng::LibPng ALIAS LibPng)
    endblock()
endif()
