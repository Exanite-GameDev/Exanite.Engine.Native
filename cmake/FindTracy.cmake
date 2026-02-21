if(NOT TARGET Tracy::TracyClient)
    block()
        # Define build and install directories
        set(BUILD_DIR ${CMAKE_BINARY_DIR}/build/tracy)
        set(INSTALL_DIR ${CMAKE_BINARY_DIR}/install/tracy)

        # Define import paths
        set(IMPORTED_LOCATION "${INSTALL_DIR}/lib/${CMAKE_STATIC_LIBRARY_PREFIX}TracyClient${CMAKE_STATIC_LIBRARY_SUFFIX}")

        # Add as external project
        ExternalProject_Add(External.Tracy
            SOURCE_DIR ${CMAKE_SOURCE_DIR}/native/tracy
            BINARY_DIR ${BUILD_DIR}
            INSTALL_DIR ${INSTALL_DIR}
            BUILD_BYPRODUCTS "${INSTALL_DIR}/lib/${CMAKE_STATIC_LIBRARY_PREFIX}TracyClient${CMAKE_STATIC_LIBRARY_SUFFIX}"
            CMAKE_ARGS
                -DCMAKE_INSTALL_PREFIX=${INSTALL_DIR}
                -DCMAKE_POSITION_INDEPENDENT_CODE=ON

                -DCMAKE_BUILD_TYPE=${CMAKE_BUILD_TYPE}

                -DTRACY_ENABLE=ON
                -DTRACY_ON_DEMAND=ON

                # Build static library
                -DBUILD_SHARED_LIBS=OFF
                -DTRACY_STATIC=ON
                -DTRACY_LTO=OFF

                # Force consistent output folders between Debug/Release
                -DCMAKE_ARCHIVE_OUTPUT_DIRECTORY_DEBUG=${INSTALL_DIR}/lib
                -DCMAKE_LIBRARY_OUTPUT_DIRECTORY_DEBUG=${INSTALL_DIR}/lib
                -DCMAKE_RUNTIME_OUTPUT_DIRECTORY_DEBUG=${INSTALL_DIR}/bin
        )

        # Preemptively create include dir
        file(MAKE_DIRECTORY ${INSTALL_DIR}/include/tracy)

        # Define imported target
        add_library(TracyClient STATIC IMPORTED GLOBAL)
        set_target_properties(TracyClient
            PROPERTIES
                IMPORTED_LOCATION "${IMPORTED_LOCATION}"
                INTERFACE_INCLUDE_DIRECTORIES "${INSTALL_DIR}/include/tracy"
        )
        add_dependencies(TracyClient External.Tracy)

        # Define aliases
        add_library(Tracy::TracyClient ALIAS TracyClient)
    endblock()
endif()
