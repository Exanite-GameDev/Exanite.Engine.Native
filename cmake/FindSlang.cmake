if(NOT TARGET Slang::Slang)
    block()
        # Define install directory
        set(SLANG_INSTALL_DIR ${CMAKE_BINARY_DIR}/install/slang)

        # Add as external project
        ExternalProject_Add(External.Slang
            SOURCE_DIR ${CMAKE_SOURCE_DIR}/native/slang
            INSTALL_DIR ${SLANG_INSTALL_DIR}
            BUILD_BYPRODUCTS "${SLANG_INSTALL_DIR}/lib/${CMAKE_STATIC_LIBRARY_PREFIX}slang${CMAKE_STATIC_LIBRARY_SUFFIX}"
            CMAKE_ARGS
                -DCMAKE_INSTALL_PREFIX=<INSTALL_DIR>
                -DCMAKE_POSITION_INDEPENDENT_CODE=ON

                -DCMAKE_BUILD_TYPE=${CMAKE_BUILD_TYPE}
                -DCMAKE_C_COMPILER=${CMAKE_C_COMPILER}
                -DCMAKE_CXX_COMPILER=${CMAKE_CXX_COMPILER}
                -DCMAKE_C_STANDARD=${CMAKE_C_STANDARD}
                -DCMAKE_CXX_STANDARD=${CMAKE_CXX_STANDARD}

                -DSLANG_ENABLE_TESTS=OFF
                -DSLANG_ENABLE_EXAMPLES=OFF
                -DSLANG_ENABLE_GFX=OFF
                -DSLANG_ENABLE_SLANGD=OFF

                # Build static library
                -DSLANG_LIB_TYPE=STATIC
        )

        # Preemptively create include dir
        file(MAKE_DIRECTORY ${SLANG_INSTALL_DIR}/include)

        # Define imported target
        add_library(Slang STATIC IMPORTED GLOBAL)
        set_target_properties(Slang PROPERTIES
            IMPORTED_LOCATION "${SLANG_INSTALL_DIR}/lib/${CMAKE_STATIC_LIBRARY_PREFIX}slang${CMAKE_STATIC_LIBRARY_SUFFIX}"
            INTERFACE_INCLUDE_DIRECTORIES "${SLANG_INSTALL_DIR}/include"
        )
        add_dependencies(Slang External.Slang)

        # Define aliases
        add_library(Slang::Slang ALIAS Slang)
    endblock()
endif()
