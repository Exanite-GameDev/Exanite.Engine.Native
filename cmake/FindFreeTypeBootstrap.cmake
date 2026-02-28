if(NOT TARGET External.FreeTypeBootstrap)
    block()
        include("${CMAKE_CURRENT_LIST_DIR}/Utility/ExternalProjectArgs.cmake")
        find_package(ZLib REQUIRED)
        find_package(LibPng REQUIRED)
        find_package(Brotli REQUIRED)

        # Define build and install folders
        set(build_folder ${CMAKE_BINARY_DIR}/build/freetype-bootstrap)
        set(install_folder ${CMAKE_BINARY_DIR}/install/freetype-bootstrap)

        # Define outputs
        set(base_name "freetype")
        if(WIN32)
            set(output_file "${install_folder}/bin/${base_name}.dll")
            set(output_lib "${install_folder}/lib/${base_name}.lib")
        else()
            set(output_file "${install_folder}/lib/${CMAKE_SHARED_LIBRARY_PREFIX}${base_name}${CMAKE_SHARED_LIBRARY_SUFFIX}")
        endif()

        # Add as external project
        get_exanite_external_project_args(EXANITE_EXTERNAL_PROJECT_ARGS ${install_folder})
        ExternalProject_Add(External.FreeTypeBootstrap
            SOURCE_DIR ${CMAKE_SOURCE_DIR}/native/freetype
            BINARY_DIR ${build_folder}
            INSTALL_DIR ${install_folder}
            BUILD_BYPRODUCTS
                ${output_file}
                ${output_lib}
            CMAKE_ARGS
                # ----- Shared options -----

                ${EXANITE_EXTERNAL_PROJECT_ARGS}

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

        # Manually install relevant outputs
        ExternalProject_Add_Step(External.FreeTypeBootstrap manual_install
            COMMAND ${CMAKE_COMMAND}
                -DSOURCE_FOLDER=${CMAKE_CURRENT_LIST_DIR}/FreeTypeBootstrap/include
                -DDESTINATION_FOLDER=${install_folder}/include/freetype2
                -P "${CMAKE_CURRENT_LIST_DIR}/Utility/InstallHeaders.cmake"
            DEPENDEES install
        )
    endblock()
endif()
