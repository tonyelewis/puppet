# # This requires an LLVM to be built in ~/source/llvm
# # This installs into the directory ~/source/llvm (in particular, ~/source/llvm/bin/include-what-you-use)
# # The branch checked-out below must match the Clang against which the IWYU is built
#
# rm -rf ~/source/include-what-you-use-{build,source}/
# mkdir -p ~/source/include-what-you-use-build/
# git clone https://github.com/include-what-you-use/include-what-you-use.git ~/source/include-what-you-use-source/
# git -C ~/source/include-what-you-use-source/ branch -vv -a
# git -C ~/source/include-what-you-use-source/ checkout clang_11
# cmake -GNinja -B$( ls -1d ~/source/include-what-you-use-build ) -H$( ls -1d ~/source/include-what-you-use-source ) -DCMAKE_PREFIX_PATH=$( ls -1d ~/source/llvm ) -DCMAKE_INSTALL_PREFIX=$( ls -1d ~/source/llvm )
# ninja -C ~/source/include-what-you-use-build -k 0
# ninja -C ~/source/include-what-you-use-build -k 0 install
