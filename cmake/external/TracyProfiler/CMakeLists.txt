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
)
