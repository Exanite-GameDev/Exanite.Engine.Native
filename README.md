# Exanite.Engine.Native

Repo containing Exanite.Engine's C/C++ code and dependencies.

## Repo structure

### /outputs

The `outputs` folder contains build outputs for this repo.

This is the overall structure:
- /outputs
    - /cache
        - /cmake-user - CMake build folder used when building from an IDE.
        - /cmake-ci - CMake build folder used by the Exanite.Engine build system and CI.
    - /binaries - Built application binaries. Often copied into the tools folder.
    - /runtimes - Built application libraries. Often copied into the Exanite.Engine.Native project.

### /projects

The `projects` folder contains different 1st party and 3rd party projects. These projects use C or C++.

Only the Exanite-prefixed projects are 1st party projects.

Explanation of columns:
- In engine - Whether the project is used in the C# engine. Not necessarily used directly.

| Project                       | Description                           | In engine |
|:------------------------------|:--------------------------------------|:---------:|
| Exanite.CppScratchpad         | Scratchpad for C++ code               |           |
| Exanite.SlangScratchpad       | Scratchpad for Slang code             |           |
| Exanite.TypographyScratchpad  | Scratchpad for FreeType/HarfBuzz code |           |
| Exanite.FreeType              | Wrapper around FreeType               |     ✓     |
| Exanite.Tracy                 | Wrapper around Tracy                  |     ✓     |
| Exanite.VulkanMemoryAllocator | Wrapper around VulkanMemoryAllocator  |     ✓     |
| freetype                      | Font rendering library                |     ✓     |
| harfbuzz                      | Text shaping library                  |     ✓     |
| slang                         | Shader compiler                       |     ✓     |
| tracy                         | CPU/GPU profiler                      |     ✓     |
| Vulkan-Headers                | Vulkan C headers                      |     ✓     |
| VulkanMemoryAllocator         | Simplifies Vulkan memory management   |     ✓     |
| brotli                        | Compression library                   |     ✓     |
| libpng                        | Image loading library                 |     ✓     |
| zlib                          | Compression library                   |     ✓     |
