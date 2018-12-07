# https://llvm.org/docs/GettingStarted.html



# svn co    http://llvm.org/svn/llvm-project/llvm/trunk              ~/source/llvm-master
# svn co    http://llvm.org/svn/llvm-project/cfe/trunk               ~/source/llvm-master/tools/clang
# svn co    http://llvm.org/svn/llvm-project/clang-tools-extra/trunk ~/source/llvm-master/tools/clang/tools/extra
# svn co    http://llvm.org/svn/llvm-project/compiler-rt/trunk       ~/source/llvm-master/projects/compiler-rt
# svn co    http://llvm.org/svn/llvm-project/libcxx/trunk            ~/source/llvm-master/projects/libcxx


# git clone https://git.llvm.org/git/llvm.git/                       ~/source/llvm-master
# git clone https://git.llvm.org/git/clang.git/                      ~/source/llvm-master/tools/clang
# git clone https://git.llvm.org/git/clang-tools-extra.git/          ~/source/llvm-master/tools/clang/tools/extra
# git clone https://git.llvm.org/git/compiler-rt.git/                ~/source/llvm-master/projects/compiler-rt
# git clone https://git.llvm.org/git/libcxx.git/                     ~/source/llvm-master/projects/libcxx
# git clone https://git.llvm.org/git/libcxxabi.git/                  ~/source/llvm-master/projects/libcxxabi
# mkdir ~/source/llvm{,-build}
# cmake -B`ls -1d ~/source/llvm-build` -H`ls -1d ~/source/llvm-master` -GNinja -DCMAKE_INSTALL_PREFIX=`ls -1d ~/source/llvm` -DCMAKE_BUILD_TYPE=Release -DLLVM_ENABLE_ASSERTIONS=OFF
# ninja -C ~/source/llvm-build -k 0 -j 4
