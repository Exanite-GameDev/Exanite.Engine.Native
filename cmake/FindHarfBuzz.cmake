if(NOT TARGET External.HarfBuzz)
    block()
        include("${CMAKE_CURRENT_LIST_DIR}/ExternalProjectConfig.cmake")

        find_package(FreeTypeBootstrap REQUIRED)

        # Define build and install folders
        set(BUILD_DIR ${CMAKE_BINARY_DIR}/build/harfbuzz)
        set(INSTALL_DIR ${CMAKE_BINARY_DIR}/install/harfbuzz)

        # Define output names
        set(BASE_NAME "harfbuzz")

        # Define outputs
        if(WIN32)
            set(OUTPUT_PATH "${INSTALL_DIR}/bin/${BASE_NAME}.dll")
            set(IMPORTED_IMPLIB "${INSTALL_DIR}/lib/${BASE_NAME}.lib")
        else()
            set(OUTPUT_PATH "${INSTALL_DIR}/lib/${CMAKE_SHARED_LIBRARY_PREFIX}${BASE_NAME}${CMAKE_SHARED_LIBRARY_SUFFIX}")
        endif()

        # Add as external project
        ExternalProject_Add(External.HarfBuzz
            SOURCE_DIR ${CMAKE_SOURCE_DIR}/native/harfbuzz
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

                # Build shared library
                -DBUILD_SHARED_LIBS=ON

                # Specify paths for dependencies
                -DCMAKE_PREFIX_PATH=${CMAKE_BINARY_DIR}/install/freetype-bootstrap

                # Enable freetype integration
                -DHB_HAVE_FREETYPE=ON
        )
        add_dependencies(External.HarfBuzz External.FreeTypeBootstrap)

        # Preemptively create include dir
        file(MAKE_DIRECTORY ${INSTALL_DIR}/include/harfbuzz)

        # Define imported target
        add_library(HarfBuzz SHARED IMPORTED GLOBAL)
        set_target_properties(HarfBuzz
            PROPERTIES
                IMPORTED_LOCATION "${OUTPUT_PATH}"
                IMPORTED_IMPLIB "${IMPORTED_IMPLIB}"
                INTERFACE_INCLUDE_DIRECTORIES "${INSTALL_DIR}/include/harfbuzz"
        )
        add_dependencies(HarfBuzz External.HarfBuzz)

        # Define aliases
        add_library(HarfBuzz::HarfBuzz ALIAS HarfBuzz)
    endblock()
endif()
