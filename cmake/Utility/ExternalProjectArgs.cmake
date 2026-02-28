function(get_exanite_external_project_args return_variable install_folder)
    set(EXANITE_EXTERNAL_PROJECT_ARGS
        -DCMAKE_TOOLCHAIN_FILE=${CMAKE_TOOLCHAIN_FILE}

        # Set install directory
        -DCMAKE_INSTALL_PREFIX=${install_folder}
    )

    set(${return_variable} ${EXANITE_EXTERNAL_PROJECT_ARGS} PARENT_SCOPE)
endfunction()
