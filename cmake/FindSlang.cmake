if(NOT TARGET Slang::Slang)
    block()
        # Define install directory
        set(SLANG_INSTALL_DIR ${CMAKE_BINARY_DIR}/install/slang)

        # Add as external project
        ExternalProject_Add(External.Slang
            SOURCE_DIR ${CMAKE_SOURCE_DIR}/native/slang
            INSTALL_DIR ${SLANG_INSTALL_DIR}
            BUILD_BYPRODUCTS "${SLANG_INSTALL_DIR}/lib/${CMAKE_SHARED_LIBRARY_PREFIX}slang${CMAKE_SHARED_LIBRARY_SUFFIX}"
            CMAKE_ARGS
                -DCMAKE_INSTALL_PREFIX=<INSTALL_DIR>
                -DCMAKE_POSITION_INDEPENDENT_CODE=ON

                -DCMAKE_BUILD_TYPE=Release

                -DSLANG_ENABLE_DXIL=FALSE
                -DSLANG_ENABLE_EXAMPLES=FALSE
                -DSLANG_ENABLE_GFX=FALSE
                -DSLANG_ENABLE_OPTIX=FALSE
                -DSLANG_ENABLE_RELEASE_DEBUG_INFO=FALSE
                -DSLANG_ENABLE_SLANGD=FALSE
                -DSLANG_ENABLE_SLANGI=FALSE
                -DSLANG_ENABLE_SLANGRT=FALSE
                -DSLANG_ENABLE_SLANG_GLSLANG=FALSE
                -DSLANG_ENABLE_TESTS=FALSE

                -DSLANG_SLANG_LLVM_FLAVOR=DISABLE

                # Build shared library
                -DSLANG_LIB_TYPE=SHARED
        )

        # Preemptively create include dir
        file(MAKE_DIRECTORY ${SLANG_INSTALL_DIR}/include)

        # Define imported target
        add_library(Slang SHARED IMPORTED GLOBAL)
        set_target_properties(Slang PROPERTIES
            IMPORTED_LOCATION "${SLANG_INSTALL_DIR}/lib/${CMAKE_SHARED_LIBRARY_PREFIX}slang${CMAKE_SHARED_LIBRARY_SUFFIX}"
            INTERFACE_INCLUDE_DIRECTORIES "${SLANG_INSTALL_DIR}/include"
        )
        add_dependencies(Slang External.Slang)

        # Define aliases
        add_library(Slang::Slang ALIAS Slang)
    endblock()
endif()
