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

# Currently none

# --- Linking options ---

# Use shared libraries by default
set(BUILD_SHARED_LIBS ON CACHE BOOL "" FORCE)

# This allows shared libraries to be loaded at different memory addresses
set(CMAKE_POSITION_INDEPENDENT_CODE ON CACHE BOOL "" FORCE)

# Target Windows 10 or later
# See: https://learn.microsoft.com/en-us/cpp/porting/modifying-winver-and-win32-winnt
if(WIN32)
    add_compile_definitions(_WIN32_WINNT=0x0A00)
endif()

# Dynamically link to the MSVC C++ runtime
if(MSVC)
    set(CMAKE_MSVC_RUNTIME_LIBRARY "MultiThreadedDLL" CACHE STRING "" FORCE)
endif()

# Ensure RPath is set for built binaries
set(CMAKE_BUILD_WITH_INSTALL_RPATH TRUE CACHE BOOL "" FORCE)
if(APPLE)
    set(CMAKE_INSTALL_RPATH "@loader_path" CACHE STRING "" FORCE)
elseif(UNIX)
    set(CMAKE_INSTALL_RPATH "\$ORIGIN" CACHE STRING "" FORCE)
endif()

# Ensure RPath is set for installed binaries
# This has the effect of CMake adding RPaths pointing to the install directories of the dependencies of shared objects
set(CMAKE_INSTALL_RPATH_USE_LINK_PATH TRUE CACHE BOOL "" FORCE)

# Ensure CMake does not skip the setting of RPaths
# This doesn't seem to change any behavior regardless of the value
# Not sure what it does
set(CMAKE_INSTALL_SKIP_RPATH FALSE CACHE BOOL "" FORCE)

# TODO: Not sure if does anything
## Disable versioned SoNames for Linux
## This is because Exanite.Engine bundles all dependencies as a complete set
#set(CMAKE_PLATFORM_NO_VERSIONED_SONAME OFF CACHE BOOL "" FORCE)

# --- Output options ---

# Globally disable shared library prefix for Windows
if(WIN32)
    set(CMAKE_SHARED_LIBRARY_PREFIX "" CACHE STRING "" FORCE)
endif()
