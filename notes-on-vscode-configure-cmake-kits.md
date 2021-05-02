# Notes on VSCode configure cmake kits

Add a `clang_rwdi` kit to the bottom of `~/.local/share/CMakeTools/cmake-tools-kits.json` like:

~~~json
  {
    "name": "clang_rwdi",
    "toolchainFile": "<HOME_DIR>/puppet/toolchain-files/clang_rwdi.cmake"
  }
~~~

&hellip;(with `<HOME_DIR>` substituted). Then install Conan deps in the project directory:

~~~sh
cd <PROJECT_DIR>
mkdir build
conan install --update --build outdated --build cascade --install-folder .vscode-cmake-build . --profile clang_rwdi --profile project/<PROJECT_NAME>
~~~
