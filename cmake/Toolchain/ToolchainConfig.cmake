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

# This section emulates Windows DLL loading behavior for Linux and Mac
# Specifically, it makes shared libraries look beside themselves for dependencies
# and makes so names / install names match the shared library file names
if(TRUE)
    # Ensure CMake does not skip the setting of RPaths
    set(CMAKE_INSTALL_SKIP_RPATH FALSE CACHE BOOL "" FORCE)

    # Ensure RPath is set for installed binaries
    # This has the effect of CMake adding RPaths pointing to the install directories of the dependencies of shared objects
    set(CMAKE_INSTALL_RPATH_USE_LINK_PATH TRUE CACHE BOOL "" FORCE)

    if(APPLE)
        # Tells CMake to use @rpath in the LC_ID_DYLIB field of the library
        set(CMAKE_MACOSX_RPATH TRUE CACHE BOOL "" FORCE)

        # When building the library, this sets its internal ID to @rpath/libname.dylib
        set(CMAKE_INSTALL_NAME_DIR "@rpath" CACHE STRING "" FORCE)

        # The executable looks in its own directory for @rpath
        set(CMAKE_INSTALL_RPATH "@loader_path" CACHE STRING "" FORCE)
    endif()

    if(UNIX AND NOT APPLE)
        set(CMAKE_INSTALL_RPATH "\$ORIGIN")

        # This prevents libfoo.so.1.2.3 from being the so name and keeps it as libfoo.so
        set(CMAKE_PLATFORM_NO_VERSIONED_SONAME TRUE CACHE BOOL "" FORCE)
    endif()
endif()

# --- Output options ---

# Globally disable shared library prefix for Windows
if(WIN32)
    set(CMAKE_SHARED_LIBRARY_PREFIX "" CACHE STRING "" FORCE)
endif()
