function(get_exanite_external_project_args return_variable install_folder)
    set(EXANITE_EXTERNAL_PROJECT_ARGS
        -DCMAKE_TOOLCHAIN_FILE=${CMAKE_TOOLCHAIN_FILE}

        # Always use release for external projects
        -DCMAKE_BUILD_TYPE=Release

        # Set install directory
        -DCMAKE_INSTALL_PREFIX=${install_folder}
    )

    set(${return_variable} ${EXANITE_EXTERNAL_PROJECT_ARGS} PARENT_SCOPE)
endfunction()
