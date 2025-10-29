include(ExternalProject)

if(NOT TARGET Tracy::TracyClient)
    block()
        set(TRACY_INSTALL_DIR ${CMAKE_BINARY_DIR}/install/tracy)

        ExternalProject_Add(Tracy_External
            SOURCE_DIR ${CMAKE_SOURCE_DIR}/native/tracy
            INSTALL_DIR ${TRACY_INSTALL_DIR}
            CMAKE_ARGS
                -DCMAKE_INSTALL_PREFIX=<INSTALL_DIR>
                -DCMAKE_POSITION_INDEPENDENT_CODE=ON

                -DTRACY_ENABLE=ON
                -DTRACY_ON_DEMAND=ON
                -DTRACY_CALLSTACK=ON

                # Build shared library
                -DBUILD_SHARED_LIBS=OFF
                -DTRACY_STATIC=ON
                -DTRACY_LTO=OFF
        )

        file(MAKE_DIRECTORY ${TRACY_INSTALL_DIR}/include)
        add_library(TracyClient STATIC IMPORTED GLOBAL)
        set_target_properties(TracyClient PROPERTIES
            IMPORTED_LOCATION "${TRACY_INSTALL_DIR}/lib/${CMAKE_STATIC_LIBRARY_PREFIX}TracyClient${CMAKE_STATIC_LIBRARY_SUFFIX}"
            INTERFACE_INCLUDE_DIRECTORIES "${TRACY_INSTALL_DIR}/include"
        )
        add_library(Tracy::TracyClient ALIAS TracyClient)

        add_dependencies(TracyClient Tracy_External)
    endblock()
endif()
