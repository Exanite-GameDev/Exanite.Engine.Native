# Define relevant folders
set(source_dir ${CMAKE_SOURCE_DIR}/projects/tracy/profiler)
set(build_dir ${CMAKE_BINARY_DIR}/build/tracy-profiler)
set(install_dir ${CMAKE_BINARY_DIR}/install/tracy-profiler)

# Define outputs
set(base_name "tracy-profiler")

set(output_bin "${install_dir}/${EXANITE_EXECUTABLE_INSTALL_DIR}/${base_name}${CMAKE_EXECUTABLE_SUFFIX}")

# Define external project
exanite_get_external_project_args(external_project_args ${install_dir})
ExternalProject_Add(External.TracyProfiler
    SOURCE_DIR ${source_dir}
    BINARY_DIR ${build_dir}
    INSTALL_DIR ${install_dir}
    BUILD_BYPRODUCTS ${output_bin}
    CMAKE_ARGS
        ${external_project_args}

        # Tracy's own AppImage build disables this, and without this,
        # the build created by the Github Actions runner doesn't run on my local PC
        # due to the AVX-512 vmovdqu8 instruction not existing on Ryzen 9 5900x
        -DNO_ISA_EXTENSIONS=ON
)
