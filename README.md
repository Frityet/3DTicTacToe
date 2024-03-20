# ObjFW-Template

This is a template for creating new ObjFW projects. It uses xmake to manage project files and build the project.

## Usage

1. Clone this repository
2. Rename the target name in [`xmake.lua`](./xmake.lua)
3. Change your arch and os in [`.vscode/launch.json`](./.vscode/launch.json)
4. Configure the project with `xmake config --mode=debug --toolchain=clang`
5. Bulid the project with `xmake`
