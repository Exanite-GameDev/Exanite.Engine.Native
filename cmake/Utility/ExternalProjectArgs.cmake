function(get_exanite_external_project_args return_variable install_folder)
    set(EXANITE_EXTERNAL_PROJECT_ARGS
        -DCMAKE_TOOLCHAIN_FILE=${CMAKE_TOOLCHAIN_FILE}
        -DCMAKE_BUILD_TYPE=${CMAKE_BUILD_TYPE}

        # Set install directory
        -DCMAKE_INSTALL_PREFIX=${install_folder}

        # Force consistent output folders between Debug/Release
        -DCMAKE_ARCHIVE_OUTPUT_DIRECTORY=${install_folder}/lib
        -DCMAKE_LIBRARY_OUTPUT_DIRECTORY=${install_folder}/lib
        -DCMAKE_RUNTIME_OUTPUT_DIRECTORY=${install_folder}/bin

        -DCMAKE_ARCHIVE_OUTPUT_DIRECTORY_DEBUG=${install_folder}/lib
        -DCMAKE_LIBRARY_OUTPUT_DIRECTORY_DEBUG=${install_folder}/lib
        -DCMAKE_RUNTIME_OUTPUT_DIRECTORY_DEBUG=${install_folder}/bin

        -DCMAKE_ARCHIVE_OUTPUT_DIRECTORY_RELEASE=${install_folder}/lib
        -DCMAKE_LIBRARY_OUTPUT_DIRECTORY_RELEASE=${install_folder}/lib
        -DCMAKE_RUNTIME_OUTPUT_DIRECTORY_RELEASE=${install_folder}/bin
    )

    set(${return_variable} ${EXANITE_EXTERNAL_PROJECT_ARGS} PARENT_SCOPE)
endfunction()
