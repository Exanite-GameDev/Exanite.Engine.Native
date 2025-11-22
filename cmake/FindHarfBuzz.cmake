if(NOT TARGET External.HarfBuzz)
    block()
        # Define build and install directories
        set(BUILD_DIR ${CMAKE_BINARY_DIR}/build/harfbuzz)
        set(INSTALL_DIR ${CMAKE_BINARY_DIR}/install/harfbuzz)

        # Define import paths
        if(WIN32)
            set(IMPORTED_LOCATION "${INSTALL_DIR}/bin/harfbuzz.dll")
            set(IMPORTED_IMPLIB "${INSTALL_DIR}/lib/harfbuzz.lib")
        else()
            set(IMPORTED_LOCATION "${INSTALL_DIR}/lib/${CMAKE_SHARED_LIBRARY_PREFIX}harfbuzz${CMAKE_SHARED_LIBRARY_SUFFIX}")
        endif()

        # Add as external project
        ExternalProject_Add(External.HarfBuzz
            SOURCE_DIR ${CMAKE_SOURCE_DIR}/native/harfbuzz
            BINARY_DIR ${BUILD_DIR}
            INSTALL_DIR ${INSTALL_DIR}
            BUILD_BYPRODUCTS "${INSTALL_DIR}/lib/${CMAKE_SHARED_LIBRARY_PREFIX}harfbuzz${CMAKE_SHARED_LIBRARY_SUFFIX}"
            CMAKE_ARGS
                -DCMAKE_INSTALL_PREFIX=<INSTALL_DIR>
                -DCMAKE_POSITION_INDEPENDENT_CODE=ON

                -DCMAKE_BUILD_TYPE=${CMAKE_BUILD_TYPE}
        )

        # Preemptively create include dir
        file(MAKE_DIRECTORY ${INSTALL_DIR}/include/harfbuzz)

        # Define imported target
        add_library(HarfBuzz SHARED IMPORTED GLOBAL)
        set_target_properties(HarfBuzz
            PROPERTIES
                IMPORTED_LOCATION "${IMPORTED_LOCATION}"
                IMPORTED_IMPLIB "${IMPORTED_IMPLIB}"
                INTERFACE_INCLUDE_DIRECTORIES "${INSTALL_DIR}/include/harfbuzz"
        )
        add_dependencies(HarfBuzz External.HarfBuzz)

        # Define aliases
        add_library(HarfBuzz::HarfBuzz ALIAS HarfBuzz)
    endblock()
endif()
