# CMake Scripts

All 3rd party dependencies are handled using `ExternalProject_Add`. \
This is so that build settings and build targets are kept isolated.

Additionally, installation of outputs is done manually.
This is because many CMake build scripts have outputs inconsistent with what `find_package` expects and have different outputs depending on the platform.
