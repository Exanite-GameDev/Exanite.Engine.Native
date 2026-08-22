# Define relevant folders
set(source_dir ${CMAKE_SOURCE_DIR}/projects/freetype)
set(build_dir ${CMAKE_BINARY_DIR}/build/freetype)
set(install_dir ${CMAKE_BINARY_DIR}/install/freetype)

# Define outputs
set(base_name "freetype")

set(output_bin "${install_dir}/${EXANITE_SHARED_LIBRARY_INSTALL_DIR}/${CMAKE_SHARED_LIBRARY_PREFIX}${base_name}${CMAKE_SHARED_LIBRARY_SUFFIX}")
set(output_lib "${install_dir}/${EXANITE_IMPORT_LIBRARY_INSTALL_DIR}/${CMAKE_IMPORT_LIBRARY_PREFIX}${base_name}${CMAKE_IMPORT_LIBRARY_SUFFIX}")

# Define external project
exanite_get_external_project_args(external_project_args ${install_dir})
ExternalProject_Add(External.FreeType
    SOURCE_DIR ${source_dir}
    BINARY_DIR ${build_dir}
    INSTALL_DIR ${install_dir}
    BUILD_BYPRODUCTS
        ${output_bin}
        ${output_lib}
    CMAKE_ARGS
        ${external_project_args}

        # Specify paths for dependencies
        -DCMAKE_PREFIX_PATH=${CMAKE_BINARY_DIR}/install/harfbuzz

        -DBrotliDec_ROOT=${CMAKE_BINARY_DIR}/install/brotli
        -DPNG_ROOT=${CMAKE_BINARY_DIR}/install/libpng
        -DZLIB_ROOT=${CMAKE_BINARY_DIR}/install/zlib

        # Specify custom config header
        -DFTCONFIG_H_NAME=${CMAKE_CURRENT_LIST_DIR}/include/freetype/config/ftoption.h

        # Build shared library
        -DBUILD_SHARED_LIBS=ON

        # Disable debug postfix
        -DDISABLE_FORCE_DEBUG_POSTFIX=ON

        # Enable harfbuzz since this is the final build
        -DFT_REQUIRE_HARFBUZZ=ON
        -DFT_DISABLE_HARFBUZZ=OFF

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
add_dependencies(External.FreeType External.HarfBuzz)

# Manually install custom headers
ExternalProject_Add_Step(External.FreeType manual_install
    COMMAND ${CMAKE_COMMAND}
        -DSOURCE_FOLDER=${CMAKE_CURRENT_LIST_DIR}/include
        -DDESTINATION_FOLDER=${install_dir}/include/freetype2
        -P "${CMAKE_SOURCE_DIR}/cmake/external/InstallHeaders.cmake"
    DEPENDEES build
)

# Preemptively create include dir
file(MAKE_DIRECTORY ${install_dir}/include/freetype2)

# Define imported targets
add_library(Imported.FreeType SHARED IMPORTED GLOBAL)
set_target_properties(Imported.FreeType PROPERTIES IMPORTED_LOCATION "${output_bin}" IMPORTED_IMPLIB "${output_lib}")
target_include_directories(Imported.FreeType INTERFACE "${install_dir}/include/freetype2")

add_dependencies(Imported.FreeType External.FreeType)
target_link_libraries(Imported.FreeType INTERFACE Imported.HarfBuzz)
