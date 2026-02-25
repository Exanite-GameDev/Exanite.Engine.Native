# This file can be included multiple times, but intentionally has no guard statement
# This is to ensure the variable values are up to date

set(EXANITE_EXTERNAL_PROJECT_ARGS
    "-DCMAKE_TOOLCHAIN_FILE=${CMAKE_TOOLCHAIN_FILE}"
    "-DCMAKE_BUILD_TYPE=${CMAKE_BUILD_TYPE}"
)
