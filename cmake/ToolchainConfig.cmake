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

# Ensure RPath is set for built binaries
set(CMAKE_BUILD_WITH_INSTALL_RPATH TRUE CACHE BOOL "" FORCE)
if(APPLE)
    set(CMAKE_INSTALL_RPATH "@loader_path" CACHE STRING "" FORCE)
elseif(UNIX)
    set(CMAKE_INSTALL_RPATH "\$ORIGIN" CACHE STRING "" FORCE)
endif()

# Ensure RPath is set for installed binaries
set(CMAKE_INSTALL_RPATH_USE_LINK_PATH TRUE CACHE BOOL "" FORCE)

# Statically link to the C++ runtime
if(UNIX AND NOT APPLE)
    set(CMAKE_EXE_LINKER_FLAGS_INIT "${CMAKE_EXE_LINKER_FLAGS_INIT} -static-libstdc++ -static-libgcc")
    set(CMAKE_SHARED_LINKER_FLAGS_INIT "${CMAKE_SHARED_LINKER_FLAGS_INIT} -static-libstdc++ -static-libgcc")
endif()

if(WIN32)
    set(CMAKE_MSVC_RUNTIME_LIBRARY "MultiThreaded$<$<CONFIG:Debug>:Debug>" CACHE STRING "" FORCE)
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
