# --- CMake options ---

# Set option variable policy
# The NEW policy enables the use of the option() function
cmake_policy(SET CMP0077 NEW)
set(CMAKE_POLICY_DEFAULT_CMP0077 NEW)

# Set IPO policy
# The NEW policy enables IPO flags for all compilers if possible and to error if not
# We check for compatibility below so using the new policy is safe
cmake_policy(SET CMP0069 NEW)
set(CMAKE_POLICY_DEFAULT_CMP0069 NEW)

# --- Compilation options ---

# Enable architecture specific optimizations
if(NOT MSVC)
    set(CMAKE_CXX_FLAGS_INIT "${CMAKE_CXX_FLAGS_INIT} -march=native")
    set(CMAKE_C_FLAGS_INIT "${CMAKE_C_FLAGS_INIT} -march=native")
endif()

# --- Linking options ---

# Use shared libraries by default
set(BUILD_SHARED_LIBS ON CACHE BOOL "" FORCE)

# This allows shared libraries to be loaded at different memory addresses
set(CMAKE_POSITION_INDEPENDENT_CODE ON CACHE BOOL "" FORCE)

# Hide symbols by default to prevent cross-platform issues
# This ensures that symbols are consistently exported
# Windows is strict and requires explicit exports
# Linux and Mac will export most symbols by default
set(CMAKE_CXX_VISIBILITY_PRESET "hidden" CACHE STRING "" FORCE)
set(CMAKE_VISIBILITY_INLINES_HIDDEN ON CACHE BOOL "" FORCE)

# Ensure RPath is set for built binaries
if(APPLE)
    set(CMAKE_INSTALL_RPATH "@loader_path" CACHE STRING "" FORCE)
elseif(UNIX)
    set(CMAKE_INSTALL_RPATH "$ORIGIN" CACHE STRING "" FORCE)
endif()

# Statically link to the C++ runtime
if(UNIX AND NOT APPLE)
    set(CMAKE_EXE_LINKER_FLAGS_INIT "${CMAKE_EXE_LINKER_FLAGS_INIT} -static-libstdc++ -static-libgcc")
    set(CMAKE_SHARED_LINKER_FLAGS_INIT "${CMAKE_SHARED_LINKER_FLAGS_INIT} -static-libstdc++ -static-libgcc")
endif()

# Target Windows 10 or later
# See: https://learn.microsoft.com/en-us/cpp/porting/modifying-winver-and-win32-winnt
if(WIN32)
    add_compile_definitions(_WIN32_WINNT=0x0A00)
endif()

# --- Output options ---

# Globally disable shared library prefix for Windows
if(WIN32)
    set(CMAKE_SHARED_LIBRARY_PREFIX "" CACHE STRING "" FORCE)
endif()
