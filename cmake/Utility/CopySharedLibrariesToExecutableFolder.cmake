function(exanite_copy_shared_libraries_to_executable_folder target)
    get_target_property(linked_libs ${target} LINK_LIBRARIES)
    foreach(library ${linked_libs})
        if(TARGET ${library})
            get_target_property(library_type ${library} TYPE)
            if(library_type STREQUAL "SHARED_LIBRARY")
                add_custom_command(TARGET ${target} POST_BUILD
                    COMMAND ${CMAKE_COMMAND} -E copy -t $<TARGET_FILE_DIR:${target}> $<TARGET_FILE:${library}>
                )
            endif()
        endif()
    endforeach()
endfunction()
