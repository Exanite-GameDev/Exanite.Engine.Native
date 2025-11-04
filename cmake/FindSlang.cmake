if(NOT TARGET Slang::Slang)
    block()
        # Define install directory
        set(SLANG_INSTALL_DIR ${CMAKE_BINARY_DIR}/install/slang)

        # Define import paths
        if(WIN32)
            set(SLANG_IMPORTED_LOCATION "${SLANG_INSTALL_DIR}/bin/slang-compiler.dll")
            set(SLANG_IMPORTED_IMPLIB "${SLANG_INSTALL_DIR}/lib/slang-compiler.lib")
        else()
            set(SLANG_IMPORTED_LOCATION "${SLANG_INSTALL_DIR}/lib/${CMAKE_SHARED_LIBRARY_PREFIX}slang-compiler${CMAKE_SHARED_LIBRARY_SUFFIX}")
        endif()

        # Add as external project
        ExternalProject_Add(External.Slang
            SOURCE_DIR ${CMAKE_SOURCE_DIR}/native/slang
            INSTALL_DIR ${SLANG_INSTALL_DIR}
            BUILD_BYPRODUCTS "${SLANG_INSTALL_DIR}/lib/${CMAKE_SHARED_LIBRARY_PREFIX}slang-compiler${CMAKE_SHARED_LIBRARY_SUFFIX}"
            CMAKE_ARGS
                -DCMAKE_INSTALL_PREFIX=<INSTALL_DIR>
                -DCMAKE_POSITION_INDEPENDENT_CODE=ON

                -DCMAKE_BUILD_TYPE=Release

                # Set version
                -DSLANG_VERSION_NUMERIC=2025.21

                # Disable unnecessary features
                -DSLANG_ENABLE_DXIL=FALSE
                -DSLANG_ENABLE_EXAMPLES=FALSE
                -DSLANG_ENABLE_GFX=FALSE
                -DSLANG_ENABLE_RELEASE_DEBUG_INFO=FALSE
                -DSLANG_ENABLE_SLANGC=FALSE
                -DSLANG_ENABLE_SLANGD=FALSE
                -DSLANG_ENABLE_SLANGI=FALSE
                -DSLANG_ENABLE_SLANGRT=FALSE
                -DSLANG_ENABLE_SLANG_GLSLANG=FALSE
                -DSLANG_ENABLE_TESTS=FALSE

                -DSLANG_ENABLE_CUDA=FALSE
                -DSLANG_ENABLE_OPTIX=FALSE
                -DSLANG_ENABLE_NVAPI=FALSE
                -DSLANG_ENABLE_AFTERMATH=FALSE
                -DSLANG_ENABLE_XLIB=FALSE

                -DSLANG_ENABLE_SLANG_RHI=FALSE

                -DSLANG_SLANG_LLVM_FLAVOR=DISABLE

                # Build shared library
                -DSLANG_LIB_TYPE=SHARED
        )

        # Preemptively create include dir
        file(MAKE_DIRECTORY ${SLANG_INSTALL_DIR}/include)

        # Define imported target
        add_library(Slang SHARED IMPORTED GLOBAL)
        set_target_properties(Slang
            PROPERTIES
                IMPORTED_LOCATION "${SLANG_IMPORTED_LOCATION}"
                IMPORTED_IMPLIB "${SLANG_IMPORTED_IMPLIB}"
                INTERFACE_INCLUDE_DIRECTORIES "${SLANG_INSTALL_DIR}/include"
        )
        add_dependencies(Slang External.Slang)

        # Define aliases
        add_library(Slang::Slang ALIAS Slang)
    endblock()
endif()
