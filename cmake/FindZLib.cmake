if(NOT TARGET ZLib::ZLib)
    block()
        include("${CMAKE_CURRENT_LIST_DIR}/Utility/ExternalProjectArgs.cmake")

        # Define build and install folders
        set(BUILD_FOLDER ${CMAKE_BINARY_DIR}/build/zlib)
        set(INSTALL_FOLDER ${CMAKE_BINARY_DIR}/install/zlib)

        # Define outputs
        if(WIN32)
            set(BASE_NAME "zlibstatic")
        else()
            set(BASE_NAME "z")
        endif()

        set(OUTPUT_FILE "${INSTALL_FOLDER}/lib/${CMAKE_STATIC_LIBRARY_PREFIX}${BASE_NAME}${CMAKE_STATIC_LIBRARY_SUFFIX}")

        # Add as external project
        get_exanite_external_project_args(EXANITE_EXTERNAL_PROJECT_ARGS ${INSTALL_FOLDER})
        ExternalProject_Add(External.ZLib
            SOURCE_DIR ${CMAKE_SOURCE_DIR}/native/zlib
            BINARY_DIR ${BUILD_FOLDER}
            INSTALL_DIR ${INSTALL_FOLDER}
            BUILD_BYPRODUCTS ${OUTPUT_FILE}
            CMAKE_ARGS
                # ----- Shared options -----

                ${EXANITE_EXTERNAL_PROJECT_ARGS}

                # ----- Dependency specific options -----

                # Build static library
                -DZLIB_BUILD_SHARED=OFF
                -DZLIB_BUILD_STATIC=ON
        )

        # Preemptively create include dir
        file(MAKE_DIRECTORY ${INSTALL_FOLDER}/include)

        # Define imported targets
        add_library(ZLib STATIC IMPORTED GLOBAL)
        set_target_properties(ZLib
            PROPERTIES
                IMPORTED_LOCATION "${OUTPUT_FILE}"
                INTERFACE_INCLUDE_DIRECTORIES "${INSTALL_FOLDER}/include"
        )
        add_dependencies(ZLib External.ZLib)

        # Define aliases
        add_library(ZLib::ZLib ALIAS ZLib)
    endblock()
endif()
