block()
    include("${CMAKE_CURRENT_LIST_DIR}/Utility/ExternalProjectArgs.cmake")

    # Define relevant folders
    set(build_dir ${CMAKE_BINARY_DIR}/build/slang)
    set(install_dir ${CMAKE_BINARY_DIR}/install/slang)

    # Define outputs
    set(base_name "slang-compiler")
    if(WIN32)
        set(output_bin "${install_dir}/bin/${base_name}.dll")
        set(output_lib "${install_dir}/lib/${base_name}.lib")
    else()
        set(output_bin "${install_dir}/lib/${CMAKE_SHARED_LIBRARY_PREFIX}${base_name}${CMAKE_SHARED_LIBRARY_SUFFIX}")
    endif()

    # Define targets
    # slang-proxy and slang-glsl-module are both not used, but required by Slang's install step
    set(TARGETS "slang" "slang-glsl-module")
    if(WIN32)
        list(APPEND TARGETS "slang-proxy")
    endif()

    # Define external project
    exanite_get_external_project_args(external_project_args ${install_dir})
    ExternalProject_Add(External.Slang
        SOURCE_DIR ${CMAKE_SOURCE_DIR}/native/slang
        BINARY_DIR ${build_dir}
        INSTALL_DIR ${install_dir}
        BUILD_COMMAND ${CMAKE_COMMAND} --build <BINARY_DIR> --config $<CONFIG> --target ${TARGETS}
        INSTALL_COMMAND ${CMAKE_COMMAND} --install <BINARY_DIR> --config $<CONFIG>
        BUILD_BYPRODUCTS
            ${output_bin}
            ${output_lib}
        CMAKE_ARGS
            # ----- Shared options -----

            ${external_project_args}

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
    file(MAKE_DIRECTORY ${install_dir}/include)

    # Define imported targets
    add_library(Slang SHARED IMPORTED GLOBAL)
    set_target_properties(Slang PROPERTIES IMPORTED_LOCATION "${output_bin}" IMPORTED_IMPLIB "${output_lib}")
    target_include_directories(Slang INTERFACE "${install_dir}/include")

    add_dependencies(Slang External.Slang)

    # Define aliases
    add_library(Slang::Slang ALIAS Slang)
endblock()
