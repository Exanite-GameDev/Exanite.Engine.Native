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

# Target macOS 11.0 or later (Required for arm64 support)
if(APPLE)
    set(CMAKE_OSX_DEPLOYMENT_TARGET "11.0" CACHE STRING "" FORCE)
endif()

# Target Linux (Equivalent to Ubuntu 22.04, glibc 2.35 or later)
if(UNIX AND NOT APPLE)
    # 202405L = POSIX.1-2024
    add_compile_definitions(_POSIX_C_SOURCE=202405L)

    # Allows glibc-specific optimizations without breaking the POSIX baseline
    add_compile_definitions(_GNU_SOURCE)
endif()

# Dynamically link to the MSVC C++ runtime
if(MSVC)
    set(CMAKE_MSVC_RUNTIME_LIBRARY "MultiThreadedDLL" CACHE STRING "" FORCE)
endif()

# This section emulates Windows DLL loading behavior for Linux and Mac
# Specifically, it makes shared libraries look beside themselves for dependencies
# and makes so names / install names match the shared library file names
#
# This is fine because Exanite.Engine ships all required binaries together
# so version incompatibilities isn't a concern
if(TRUE)
    # Ensure CMake does not skip the setting of RPaths
    set(CMAKE_INSTALL_SKIP_RPATH FALSE CACHE BOOL "" FORCE)

    if(APPLE)
        # Ensure that RPaths are set
        set(CMAKE_MACOSX_RPATH TRUE CACHE BOOL "" FORCE)

        # Set the binary install name to @rpath/libname.dylib
        set(CMAKE_INSTALL_NAME_DIR "@rpath" CACHE STRING "" FORCE)

        # Tells the binary to use its own folder for the @rpath value
        # In conjunction with the setting above, this tells the binary to look in its own folder first
        set(CMAKE_INSTALL_RPATH "@loader_path" CACHE STRING "" FORCE)
    endif()

    if(UNIX AND NOT APPLE)
        # Tells the binary to look in its own folder first
        set(CMAKE_INSTALL_RPATH "\$ORIGIN")
    endif()

    if(UNIX)
        # This works on both Linux and Mac
        #
        # Prevent versioned shared library names
        # Eg: libname.so.1.2.3 stays as libname.so
        # Eg: libname.1.2.3.dylib stays as libname.dylib
        set(CMAKE_PLATFORM_NO_VERSIONED_SONAME TRUE CACHE BOOL "" FORCE)
    endif()
endif()

# --- Output options ---

# Globally disable shared library prefix for Windows
if(WIN32)
    set(CMAKE_SHARED_LIBRARY_PREFIX "" CACHE STRING "" FORCE)
endif()
