function(_exanite_copy_shared_libraries_to_executable_folder_visit root_target current_target visited_variable)
    if(NOT TARGET ${current_target})
        return()
    endif()

    if(current_target IN_LIST ${visited_variable})
        return()
    endif()

    # message("-----")
    # message("Current: ${current_target}")

    # Add to visited
    list(APPEND ${visited_variable} ${current_target})

    # Only copy if the current is a shared library and not the root target
    if(NOT current_target STREQUAL root_target)
        get_target_property(current_type ${current_target} TYPE)
        if(current_type STREQUAL "SHARED_LIBRARY")
            # message("Copying target: ${current_target}")
            add_custom_command(TARGET ${root_target} POST_BUILD
                COMMAND ${CMAKE_COMMAND} -E copy -t $<TARGET_FILE_DIR:${root_target}> $<TARGET_FILE:${current_target}>
            )
        endif()
    endif()

    # Continue visiting dependencies
    get_target_property(dependencies ${current_target} LINK_LIBRARIES)
    # message("LINK_LIBRARIES: ${dependencies}")
    foreach(dependency ${dependencies})
        _exanite_copy_shared_libraries_to_executable_folder_visit(${root_target} ${dependency} ${visited_variable})
    endforeach()

    get_target_property(dependencies ${current_target} INTERFACE_LINK_LIBRARIES)
    # message("INTERFACE_LINK_LIBRARIES: ${dependencies}")
    foreach(dependency ${dependencies})
        _exanite_copy_shared_libraries_to_executable_folder_visit(${root_target} ${dependency} ${visited_variable})
    endforeach()

    # Ensure visited is propagated upwards
    set(${visited_variable} ${${visited_variable}} PARENT_SCOPE)
endfunction()

function(exanite_copy_shared_libraries_to_executable_folder target)
    # message("----------")
    # message("Processing target: ${target}")

    set(visited_targets "")
    _exanite_copy_shared_libraries_to_executable_folder_visit(${target} ${target} visited_targets)
endfunction()
