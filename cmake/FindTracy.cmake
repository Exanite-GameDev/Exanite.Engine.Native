if(NOT TARGET Tracy::TracyClient)
    block()
        # Define install directory
        set(INSTALL_DIR ${CMAKE_BINARY_DIR}/install/tracy)

        # Define import paths
        if(WIN32)
            set(IMPORTED_LOCATION "${INSTALL_DIR}/bin/TracyClient.dll")
            set(IMPORTED_IMPLIB "${INSTALL_DIR}/lib/TracyClient.lib")
        else()
            set(IMPORTED_LOCATION "${INSTALL_DIR}/lib/${CMAKE_SHARED_LIBRARY_PREFIX}TracyClient${CMAKE_SHARED_LIBRARY_SUFFIX}")
        endif()

        # Add as external project
        ExternalProject_Add(External.Tracy
            SOURCE_DIR ${CMAKE_SOURCE_DIR}/native/tracy
            INSTALL_DIR ${INSTALL_DIR}
            BUILD_BYPRODUCTS "${INSTALL_DIR}/lib/${CMAKE_SHARED_LIBRARY_PREFIX}TracyClient${CMAKE_SHARED_LIBRARY_SUFFIX}"
            CMAKE_ARGS
                -DCMAKE_INSTALL_PREFIX=<INSTALL_DIR>
                -DCMAKE_POSITION_INDEPENDENT_CODE=ON

                -DCMAKE_BUILD_TYPE=Release

                -DTRACY_ENABLE=ON
                -DTRACY_ON_DEMAND=ON
                -DTRACY_CALLSTACK=ON

                # Build shared library
                -DBUILD_SHARED_LIBS=ON
                -DTRACY_STATIC=OFF
                -DTRACY_LTO=OFF
        )

        # Preemptively create include dir
        file(MAKE_DIRECTORY ${INSTALL_DIR}/include/tracy)

        # Define imported target
        add_library(TracyClient SHARED IMPORTED GLOBAL)
        set_target_properties(TracyClient
            PROPERTIES
                IMPORTED_LOCATION "${IMPORTED_LOCATION}"
                IMPORTED_IMPLIB "${IMPORTED_IMPLIB}"
                INTERFACE_INCLUDE_DIRECTORIES "${INSTALL_DIR}/include/tracy"
        )
        add_dependencies(TracyClient External.Tracy)

        # Define aliases
        add_library(Tracy::TracyClient ALIAS TracyClient)
    endblock()
endif()
