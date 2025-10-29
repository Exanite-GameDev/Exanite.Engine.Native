include(ExternalProject)

if(NOT TARGET Tracy::TracyClient)
    block()
        # Define install directory
        set(TRACY_INSTALL_DIR ${CMAKE_BINARY_DIR}/install/tracy)

        # Add as external project
        ExternalProject_Add(External.Tracy
            SOURCE_DIR ${CMAKE_SOURCE_DIR}/native/tracy
            INSTALL_DIR ${TRACY_INSTALL_DIR}
            BUILD_BYPRODUCTS "${TRACY_INSTALL_DIR}/lib/${CMAKE_STATIC_LIBRARY_PREFIX}TracyClient${CMAKE_STATIC_LIBRARY_SUFFIX}"
            CMAKE_ARGS
                -DCMAKE_INSTALL_PREFIX=<INSTALL_DIR>
                -DCMAKE_POSITION_INDEPENDENT_CODE=ON

                -DCMAKE_BUILD_TYPE=${CMAKE_BUILD_TYPE}
                -DCMAKE_C_COMPILER=${CMAKE_C_COMPILER}
                -DCMAKE_CXX_COMPILER=${CMAKE_CXX_COMPILER}
                -DCMAKE_C_STANDARD=${CMAKE_C_STANDARD}
                -DCMAKE_CXX_STANDARD=${CMAKE_CXX_STANDARD}

                -DTRACY_ENABLE=ON
                -DTRACY_ON_DEMAND=ON
                -DTRACY_CALLSTACK=ON

                # Build static library
                -DTRACY_STATIC=ON
                -DBUILD_SHARED_LIBS=OFF
                -DTRACY_LTO=OFF
        )

        # Preemptively create include dir
        file(MAKE_DIRECTORY ${TRACY_INSTALL_DIR}/include)

        # Define imported target
        add_library(TracyClient STATIC IMPORTED GLOBAL)
        set_target_properties(TracyClient PROPERTIES
            IMPORTED_LOCATION "${TRACY_INSTALL_DIR}/lib/${CMAKE_STATIC_LIBRARY_PREFIX}TracyClient${CMAKE_STATIC_LIBRARY_SUFFIX}"
            INTERFACE_INCLUDE_DIRECTORIES "${TRACY_INSTALL_DIR}/include"
        )
        add_dependencies(TracyClient External.Tracy)

        # Define aliases
        add_library(Tracy::TracyClient ALIAS TracyClient)
    endblock()
endif()
