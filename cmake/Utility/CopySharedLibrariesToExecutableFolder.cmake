set(_exanite_copy_shared_libraries_to_executable_folder_enable_logs OFF)

function(_exanite_copy_shared_libraries_to_executable_folder_visit root_target current_target visited_variable)
    if(NOT TARGET ${current_target})
        return()
    endif()

    # Resolve alias
    get_target_property(is_alias ${current_target} ALIAS_GLOBAL)
    if(is_alias)
        get_target_property(current_target ${current_target} ALIASED_TARGET)
    endif()

    # Ignore if already visited
    if(current_target IN_LIST ${visited_variable})
        return()
    endif()

    if(_exanite_copy_shared_libraries_to_executable_folder_enable_logs)
        message("-----")
        message("Current: ${current_target}")
    endif()

    # Add to visited
    list(APPEND ${visited_variable} ${current_target})

    # Only copy if the current is a shared library and not the root target
    if(NOT current_target STREQUAL root_target)
        get_target_property(current_type ${current_target} TYPE)
        if(current_type STREQUAL "SHARED_LIBRARY")
            if(_exanite_copy_shared_libraries_to_executable_folder_enable_logs)
                message("Copying target: ${current_target}")
            endif()

            add_custom_command(TARGET ${root_target} POST_BUILD
                COMMAND ${CMAKE_COMMAND} -E copy_if_different -t $<TARGET_FILE_DIR:${root_target}> $<TARGET_FILE:${current_target}>
            )
        endif()
    endif()

    # Continue visiting dependencies
    get_target_property(link_dependencies ${current_target} LINK_LIBRARIES)
    get_target_property(interface_link_dependencies ${current_target} INTERFACE_LINK_LIBRARIES)

    if(_exanite_copy_shared_libraries_to_executable_folder_enable_logs)
        message("LINK_LIBRARIES: ${link_dependencies}")
        message("INTERFACE_LINK_LIBRARIES: ${interface_link_dependencies}")
    endif()

    set(dependencies "")
    if (link_dependencies)
        list(APPEND dependencies ${link_dependencies})
    endif()
    if (interface_link_dependencies)
        list(APPEND dependencies ${interface_link_dependencies})
    endif()

    foreach(dependency ${dependencies})
        _exanite_copy_shared_libraries_to_executable_folder_visit(${root_target} ${dependency} ${visited_variable})
    endforeach()

    # Ensure visited is propagated upwards
    set(${visited_variable} ${${visited_variable}} PARENT_SCOPE)
endfunction()

function(exanite_copy_shared_libraries_to_executable_folder target)
    if(_exanite_copy_shared_libraries_to_executable_folder_enable_logs)
        message("----------")
        message("Processing target: ${target}")
    endif()

    set(visited_targets "")
    _exanite_copy_shared_libraries_to_executable_folder_visit(${target} ${target} visited_targets)
endfunction()
