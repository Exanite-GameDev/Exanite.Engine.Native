block()
    set(SOURCE_FOLDER "${CMAKE_SOURCE_DIR}/native/freetype")
    file(GLOB_RECURSE HEADERS "${SOURCE_FOLDER}/*.h" "${SOURCE_FOLDER}/*.hpp")

    foreach(HEADER ${HEADERS})
        file(RELATIVE_PATH RELATIVE_HEADER "${SOURCE_FOLDER}" "${HEADER}")
        get_filename_component(DESTINATION_FOLDER "${INSTALL_PATH}/${RELATIVE_HEADER}" DIRECTORY)

        file(INSTALL "${HEADER}" DESTINATION "${DESTINATION_FOLDER}")
    endforeach()
endblock()
