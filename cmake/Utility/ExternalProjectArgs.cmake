function(exanite_get_external_project_args return_variable install_folder)
    set(exanite_external_project_args
        -DCMAKE_TOOLCHAIN_FILE=${CMAKE_TOOLCHAIN_FILE}
        -DCMAKE_BUILD_TYPE=${CMAKE_BUILD_TYPE}

        # Set install directory
        -DCMAKE_INSTALL_PREFIX=${install_folder}
    )

    set(${return_variable} ${exanite_external_project_args} PARENT_SCOPE)
endfunction()
