# Define relevant folders
set(source_dir ${CMAKE_SOURCE_DIR}/native/harfbuzz)
set(build_dir ${CMAKE_BINARY_DIR}/build/harfbuzz)
set(install_dir ${CMAKE_BINARY_DIR}/install/harfbuzz)

# Define outputs
set(base_name "harfbuzz")

set(output_bin "${install_dir}/bin/${CMAKE_SHARED_LIBRARY_PREFIX}${base_name}${CMAKE_SHARED_LIBRARY_SUFFIX}")
set(output_lib "${install_dir}/lib/${CMAKE_IMPORT_LIBRARY_PREFIX}${base_name}${CMAKE_IMPORT_LIBRARY_SUFFIX}")

# Define external project
exanite_get_external_project_args(external_project_args ${install_dir})
ExternalProject_Add(External.HarfBuzz
    SOURCE_DIR ${source_dir}
    BINARY_DIR ${build_dir}
    INSTALL_DIR ${install_dir}
    BUILD_BYPRODUCTS
        ${output_bin}
        ${output_lib}
    CMAKE_ARGS
        # ----- Shared options -----

        ${external_project_args}

        # ----- Dependency specific options -----

        # Build shared library
        -DBUILD_SHARED_LIBS=ON

        # Specify paths for dependencies
        -DCMAKE_PREFIX_PATH=${CMAKE_BINARY_DIR}/install/freetype-bootstrap

        # Enable FreeType integration
        -DHB_HAVE_FREETYPE=ON

        # HarfBuzz's function existence checks seem to be flaky and look at the system libraries instead
        # Let's override them
        -DHAVE_FT_GET_VAR_BLEND_COORDINATES=TRUE
        -DHAVE_FT_SET_VAR_BLEND_COORDINATES=TRUE
        -DHAVE_FT_DONE_MM_VAR=TRUE
        -DHAVE_FT_GET_TRANSFORM=TRUE
)

# Define dependencies
add_dependencies(External.HarfBuzz External.FreeTypeBootstrap)

# Preemptively create include dir
file(MAKE_DIRECTORY ${install_dir}/include/harfbuzz)

# Define imported targets
add_library(Imported.HarfBuzz SHARED IMPORTED GLOBAL)
set_target_properties(Imported.HarfBuzz PROPERTIES IMPORTED_LOCATION "${output_bin}" IMPORTED_IMPLIB "${output_lib}")
target_include_directories(Imported.HarfBuzz INTERFACE "${install_dir}/include/harfbuzz")

add_dependencies(Imported.HarfBuzz External.HarfBuzz)
target_link_libraries(Imported.HarfBuzz INTERFACE Imported.FreeType)
