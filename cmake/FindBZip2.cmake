if(NOT TARGET BZip2::BZip2)
    block()
        include("${CMAKE_CURRENT_LIST_DIR}/ExternalProjectConfig.cmake")

        # Define build and install folders
        set(BUILD_DIR ${CMAKE_BINARY_DIR}/build/bzip2)
        set(INSTALL_DIR ${CMAKE_BINARY_DIR}/install/bzip2)

        # BZip2 is named libbz2 on Windows
        if(WIN32)
            set(BZIP_LIBRARY_NAME "libbz2")
        else()
            set(BZIP_LIBRARY_NAME "bz2")
        endif()

        # Define import paths
        set(IMPORTED_LOCATION "${INSTALL_DIR}/lib/${CMAKE_STATIC_LIBRARY_PREFIX}${BZIP_LIBRARY_NAME}${CMAKE_STATIC_LIBRARY_SUFFIX}")

        # Add as external project
        ExternalProject_Add(External.BZip2
            SOURCE_DIR ${CMAKE_SOURCE_DIR}/native/bzip2
            BINARY_DIR ${BUILD_DIR}
            INSTALL_DIR ${INSTALL_DIR}
            BUILD_BYPRODUCTS "${INSTALL_DIR}/lib/${CMAKE_STATIC_LIBRARY_PREFIX}${BZIP_LIBRARY_NAME}${CMAKE_STATIC_LIBRARY_SUFFIX}"
            CMAKE_ARGS
                # Shared options
                ${EXANITE_EXTERNAL_PROJECT_ARGS}
                -DCMAKE_INSTALL_PREFIX=${INSTALL_DIR}

                # Force consistent output folders between Debug/Release
                -DCMAKE_ARCHIVE_OUTPUT_DIRECTORY_DEBUG=${INSTALL_DIR}/lib
                -DCMAKE_LIBRARY_OUTPUT_DIRECTORY_DEBUG=${INSTALL_DIR}/lib
                -DCMAKE_RUNTIME_OUTPUT_DIRECTORY_DEBUG=${INSTALL_DIR}/bin

                # ----- Dependency specific options -----

                # Build static library
                -DENABLE_STATIC_LIB=ON
                -DENABLE_SHARED_LIB=OFF

                -DENABLE_LIB_ONLY=ON
        )

        # Preemptively create include dir
        file(MAKE_DIRECTORY ${INSTALL_DIR}/include)

        # Define imported target
        add_library(BZip2 STATIC IMPORTED GLOBAL)
        set_target_properties(BZip2
            PROPERTIES
                IMPORTED_LOCATION "${IMPORTED_LOCATION}"
                INTERFACE_INCLUDE_DIRECTORIES "${INSTALL_DIR}/include"
        )
        add_dependencies(BZip2 External.BZip2)

        # Define aliases
        add_library(BZip2::BZip2 ALIAS BZip2)
    endblock()
endif()
