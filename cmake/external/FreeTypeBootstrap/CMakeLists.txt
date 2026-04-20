# Define relevant folders
set(source_dir ${CMAKE_SOURCE_DIR}/native/freetype)
set(build_dir ${CMAKE_BINARY_DIR}/build/freetype-bootstrap)
set(install_dir ${CMAKE_BINARY_DIR}/install/freetype-bootstrap)

# Define outputs
set(base_name "freetype")

set(output_bin "${install_dir}/bin/${CMAKE_SHARED_LIBRARY_PREFIX}${base_name}${CMAKE_SHARED_LIBRARY_SUFFIX}")
set(output_lib "${install_dir}/lib/${CMAKE_IMPORT_LIBRARY_PREFIX}${base_name}${CMAKE_IMPORT_LIBRARY_SUFFIX}")

# Define external project
exanite_get_external_project_args(external_project_args ${install_dir})
ExternalProject_Add(External.FreeTypeBootstrap
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

        # Specify paths for dependencies
        -DBrotliDec_ROOT=${CMAKE_BINARY_DIR}/install/brotli
        -DPNG_ROOT=${CMAKE_BINARY_DIR}/install/libpng
        -DZLIB_ROOT=${CMAKE_BINARY_DIR}/install/zlib

        # Specify custom config header
        -DFTCONFIG_H_NAME=${CMAKE_CURRENT_LIST_DIR}/FreeTypeBootstrap/include/freetype/config/ftoption.h

        # Build shared library
        -DBUILD_SHARED_LIBS=ON

        # Disable debug postfix
        -DDISABLE_FORCE_DEBUG_POSTFIX=ON

        # Disable harfbuzz since this is the bootstrap build
        -DFT_REQUIRE_HARFBUZZ=OFF
        -DFT_DISABLE_HARFBUZZ=ON

        # bzip2, zlib, brotli add support for compressed fonts
        # png adds support for colored emojis
        # harfbuzz adds support for improved hinting
        -DFT_REQUIRE_BROTLI=ON
        -DFT_REQUIRE_PNG=ON
        -DFT_REQUIRE_ZLIB=ON

        -DFT_DISABLE_BROTLI=OFF
        -DFT_DISABLE_PNG=OFF
        -DFT_DISABLE_ZLIB=OFF

        # Disable bzip since it only adds support for very old Linux fonts (.pcf.bz2)
        -DFT_REQUIRE_BZIP2=OFF
        -DFT_DISABLE_BZIP2=ON
)
add_dependencies(External.FreeTypeBootstrap External.Brotli)
add_dependencies(External.FreeTypeBootstrap External.LibPng)
add_dependencies(External.FreeTypeBootstrap External.ZLib)

# Manually install custom headers
ExternalProject_Add_Step(External.FreeTypeBootstrap manual_install
    COMMAND ${CMAKE_COMMAND}
        -DSOURCE_FOLDER=${CMAKE_CURRENT_LIST_DIR}/include
        -DDESTINATION_FOLDER=${install_dir}/include/freetype2
        -P "${CMAKE_SOURCE_DIR}/cmake/external/InstallHeaders.cmake"
    DEPENDEES install
)
