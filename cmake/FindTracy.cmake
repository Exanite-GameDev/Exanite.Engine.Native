if(NOT TARGET Tracy::TracyClient)
    block()
        include("${CMAKE_CURRENT_LIST_DIR}/ExternalProjectConfig.cmake")

        # Define build and install folders
        set(BUILD_DIR ${CMAKE_BINARY_DIR}/build/tracy)
        set(INSTALL_DIR ${CMAKE_BINARY_DIR}/install/tracy)

        # Define output names
        set(BASE_NAME "TracyClient")

        # Define outputs
        set(OUTPUT_PATH "${INSTALL_DIR}/lib/${CMAKE_STATIC_LIBRARY_PREFIX}${BASE_NAME}${CMAKE_STATIC_LIBRARY_SUFFIX}")

        # Add as external project
        ExternalProject_Add(External.Tracy
            SOURCE_DIR ${CMAKE_SOURCE_DIR}/native/tracy
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
                -DBUILD_SHARED_LIBS=OFF
                -DTRACY_STATIC=ON
                -DTRACY_LTO=OFF

                -DTRACY_ENABLE=ON
                -DTRACY_ON_DEMAND=ON
        )

        # Preemptively create include dir
        file(MAKE_DIRECTORY ${INSTALL_DIR}/include/tracy)

        # Define imported targets
        add_library(TracyClient STATIC IMPORTED GLOBAL)
        set_target_properties(TracyClient
            PROPERTIES
                IMPORTED_LOCATION "${OUTPUT_PATH}"
                INTERFACE_INCLUDE_DIRECTORIES "${INSTALL_DIR}/include/tracy"
        )
        add_dependencies(TracyClient External.Tracy)

        # Define aliases
        add_library(Tracy::TracyClient ALIAS TracyClient)
    endblock()
endif()
