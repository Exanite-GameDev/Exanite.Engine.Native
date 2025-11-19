if(NOT TARGET Tracy::TracyClient)
    block()
        # Define install directory
        set(TRACY_INSTALL_DIR ${CMAKE_BINARY_DIR}/install/tracy)

        # Define import paths
        if(WIN32)
            set(TRACY_IMPORTED_LOCATION "${TRACY_INSTALL_DIR}/bin/TracyClient.dll")
            set(TRACY_IMPORTED_IMPLIB "${TRACY_INSTALL_DIR}/lib/TracyClient.lib")
        else()
            set(TRACY_IMPORTED_LOCATION "${TRACY_INSTALL_DIR}/lib/${CMAKE_SHARED_LIBRARY_PREFIX}TracyClient${CMAKE_SHARED_LIBRARY_SUFFIX}")
        endif()

        # Add as external project
        ExternalProject_Add(External.Tracy
            SOURCE_DIR ${CMAKE_SOURCE_DIR}/native/tracy
            INSTALL_DIR ${TRACY_INSTALL_DIR}
            BUILD_BYPRODUCTS "${TRACY_INSTALL_DIR}/lib/${CMAKE_SHARED_LIBRARY_PREFIX}TracyClient${CMAKE_SHARED_LIBRARY_SUFFIX}"
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
        file(MAKE_DIRECTORY ${TRACY_INSTALL_DIR}/include/tracy)

        # Define imported target
        add_library(TracyClient SHARED IMPORTED GLOBAL)
        set_target_properties(TracyClient
            PROPERTIES
                IMPORTED_LOCATION "${SLANG_IMPORTED_LOCATION}"
                IMPORTED_IMPLIB "${SLANG_IMPORTED_IMPLIB}"
                INTERFACE_INCLUDE_DIRECTORIES "${TRACY_INSTALL_DIR}/include/tracy"
        )
        add_dependencies(TracyClient External.Tracy)

        # Define aliases
        add_library(Tracy::TracyClient ALIAS TracyClient)
    endblock()
endif()
