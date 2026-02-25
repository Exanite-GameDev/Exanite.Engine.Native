if(NOT TARGET Slang::Slang)
    block()
        include("${CMAKE_CURRENT_LIST_DIR}/ExternalProjectConfig.cmake")

        # Define build and install directories
        set(BUILD_DIR ${CMAKE_BINARY_DIR}/build/slang)
        set(INSTALL_DIR ${CMAKE_BINARY_DIR}/install/slang)

        # Define import paths
        if(WIN32)
            set(IMPORTED_LOCATION "${INSTALL_DIR}/bin/slang-compiler.dll")
            set(IMPORTED_IMPLIB "${INSTALL_DIR}/lib/slang-compiler.lib")
        else()
            set(IMPORTED_LOCATION "${INSTALL_DIR}/lib/${CMAKE_SHARED_LIBRARY_PREFIX}slang-compiler${CMAKE_SHARED_LIBRARY_SUFFIX}")
        endif()

        # Add as external project
        ExternalProject_Add(External.Slang
            SOURCE_DIR ${CMAKE_SOURCE_DIR}/native/slang
            BINARY_DIR ${BUILD_DIR}
            INSTALL_DIR ${INSTALL_DIR}
            # slang-glsl-module is included because the install step fails without it
            # slang-glsl-module is otherwise not used
            BUILD_COMMAND ${CMAKE_COMMAND} --build <BINARY_DIR> --config $<CONFIG> --target slang slang-glsl-module
            INSTALL_COMMAND ${CMAKE_COMMAND} --install <BINARY_DIR> --config $<CONFIG>
            BUILD_BYPRODUCTS "${INSTALL_DIR}/lib/${CMAKE_SHARED_LIBRARY_PREFIX}slang-compiler${CMAKE_SHARED_LIBRARY_SUFFIX}"
            CMAKE_ARGS
                # Shared options
                ${EXANITE_EXTERNAL_PROJECT_ARGS}
                -DCMAKE_INSTALL_PREFIX=${INSTALL_DIR}

                # Force consistent output folders between Debug/Release
                -DCMAKE_ARCHIVE_OUTPUT_DIRECTORY_DEBUG=${INSTALL_DIR}/lib
                -DCMAKE_LIBRARY_OUTPUT_DIRECTORY_DEBUG=${INSTALL_DIR}/lib
                -DCMAKE_RUNTIME_OUTPUT_DIRECTORY_DEBUG=${INSTALL_DIR}/bin

                # Build shared library
                -DSLANG_LIB_TYPE=SHARED

                # ----- Dependency specific options -----

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
        )

        # Preemptively create include dir
        file(MAKE_DIRECTORY ${INSTALL_DIR}/include)

        # Define imported target
        add_library(Slang SHARED IMPORTED GLOBAL)
        set_target_properties(Slang
            PROPERTIES
                IMPORTED_LOCATION "${IMPORTED_LOCATION}"
                IMPORTED_IMPLIB "${IMPORTED_IMPLIB}"
                INTERFACE_INCLUDE_DIRECTORIES "${INSTALL_DIR}/include"
        )
        add_dependencies(Slang External.Slang)

        # Define aliases
        add_library(Slang::Slang ALIAS Slang)
    endblock()
endif()
