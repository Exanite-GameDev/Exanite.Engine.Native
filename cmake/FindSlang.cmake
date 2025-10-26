if(NOT TARGET Slang::Slang)
    add_subdirectory(${CMAKE_SOURCE_DIR}/native/slang ${CMAKE_BINARY_DIR}/native/slang)
    add_library(Slang::Slang ALIAS slang)
endif()
