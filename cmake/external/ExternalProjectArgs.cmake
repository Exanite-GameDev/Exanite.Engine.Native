function(exanite_get_external_project_args return_variable install_dir)
    set(external_project_args
        -DCMAKE_TOOLCHAIN_FILE=${CMAKE_TOOLCHAIN_FILE}
        -DCMAKE_BUILD_TYPE=${CMAKE_BUILD_TYPE}

        # Set install directory
        -DCMAKE_INSTALL_PREFIX=${install_dir}
    )

    set(${return_variable} ${external_project_args} PARENT_SCOPE)
endfunction()
