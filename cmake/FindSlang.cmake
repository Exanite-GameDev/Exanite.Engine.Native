if(NOT TARGET Slang::Slang)
    block()
        include("${CMAKE_CURRENT_LIST_DIR}/ExternalProjectUtility.cmake")

        # Define build and install folders
        set(BUILD_PATH ${CMAKE_BINARY_DIR}/build/slang)
        set(INSTALL_PATH ${CMAKE_BINARY_DIR}/install/slang)

        # Define output names
        set(BASE_NAME "slang-compiler")

        # Define outputs
        if(WIN32)
            set(OUTPUT_PATH "${INSTALL_PATH}/bin/${BASE_NAME}.dll")
            set(IMPORTED_IMPLIB "${INSTALL_PATH}/lib/${BASE_NAME}.lib")
        else()
            set(OUTPUT_PATH "${INSTALL_PATH}/lib/${CMAKE_SHARED_LIBRARY_PREFIX}${BASE_NAME}${CMAKE_SHARED_LIBRARY_SUFFIX}")
        endif()

        # Define targets
        # slang-proxy and slang-glsl-module are both not used, but required by Slang's install step
        set(TARGETS "slang" "slang-glsl-module")
        if(WIN32)
            list(APPEND TARGETS "slang-proxy")
        endif()

        # Add as external project
        get_exanite_external_project_args(EXANITE_EXTERNAL_PROJECT_ARGS ${INSTALL_PATH})
        ExternalProject_Add(External.Slang
            SOURCE_DIR ${CMAKE_SOURCE_DIR}/native/slang
            BINARY_DIR ${BUILD_PATH}
            INSTALL_DIR ${INSTALL_PATH}
            BUILD_COMMAND ${CMAKE_COMMAND} --build <BINARY_DIR> --config $<CONFIG> --target ${TARGETS}
            INSTALL_COMMAND ${CMAKE_COMMAND} --install <BINARY_DIR> --config $<CONFIG>
            BUILD_BYPRODUCTS ${OUTPUT_PATH}
            CMAKE_ARGS
                # ----- Shared options -----

                ${EXANITE_EXTERNAL_PROJECT_ARGS}

                # ----- Dependency specific options -----

                # Build shared library
                -DSLANG_LIB_TYPE=SHARED

                # This is defined by slang/external/miniz/CMakeLists.txt
                # This changes miniz be statically linked
                # Not sure how Slang does it normally though
                # Their release binaries don't have a dynamic dependency to miniz
                -DAMALGAMATE_SOURCES=ON

                # Disable unnecessary features
                -DSLANG_ENABLE_DXIL=OFF
                -DSLANG_ENABLE_EXAMPLES=OFF
                -DSLANG_ENABLE_GFX=OFF
                -DSLANG_ENABLE_RELEASE_DEBUG_INFO=OFF
                -DSLANG_ENABLE_SLANGC=OFF
                -DSLANG_ENABLE_SLANGD=OFF
                -DSLANG_ENABLE_SLANGI=OFF
                -DSLANG_ENABLE_SLANGRT=OFF
                -DSLANG_ENABLE_SLANG_GLSLANG=OFF
                -DSLANG_ENABLE_TESTS=OFF

                -DSLANG_ENABLE_CUDA=OFF
                -DSLANG_ENABLE_OPTIX=OFF
                -DSLANG_ENABLE_NVAPI=OFF
                -DSLANG_ENABLE_AFTERMATH=OFF
                -DSLANG_ENABLE_XLIB=OFF

                -DSLANG_ENABLE_SLANG_RHI=OFF

                -DSLANG_SLANG_LLVM_FLAVOR=DISABLE
        )

        # Preemptively create include dir
        file(MAKE_DIRECTORY ${INSTALL_PATH}/include)

        # Define imported targets
        add_library(Slang SHARED IMPORTED GLOBAL)
        set_target_properties(Slang
            PROPERTIES
                IMPORTED_LOCATION "${OUTPUT_PATH}"
                IMPORTED_IMPLIB "${IMPORTED_IMPLIB}"
                INTERFACE_INCLUDE_DIRECTORIES "${INSTALL_PATH}/include"
        )
        add_dependencies(Slang External.Slang)

        # Define aliases
        add_library(Slang::Slang ALIAS Slang)
    endblock()
endif()
