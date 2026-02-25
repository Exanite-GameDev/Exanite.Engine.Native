# Exanite.Engine.Native

## Folder structure

- `/runtimes-debug`: Shared libraries in this folder will be included in the packaged `runtimes` folder when the build configuration is `Debug`.
- `/runtimes-release`: Shared libraries in this folder will be included in the packaged `runtimes` folder when the build configuration is `Release`.
- `/runtimes-debug`: Shared libraries in this folder will always be included in the packaged `runtimes` folder.

The folder structure beneath these runtime folders should be the following:
- `runtimes-*/[RID]/native`

RID should be a .NET RID like `win-x64` or `linux-x64`.