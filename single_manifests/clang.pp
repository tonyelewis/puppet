# https://llvm.org/docs/GettingStarted.html



# svn co    http://llvm.org/svn/llvm-project/llvm/trunk              ~/source/llvm-master
# svn co    http://llvm.org/svn/llvm-project/cfe/trunk               ~/source/llvm-master/tools/clang
# svn co    http://llvm.org/svn/llvm-project/clang-tools-extra/trunk ~/source/llvm-master/tools/clang/tools/extra
# svn co    http://llvm.org/svn/llvm-project/compiler-rt/trunk       ~/source/llvm-master/projects/compiler-rt
# svn co    http://llvm.org/svn/llvm-project/libcxx/trunk            ~/source/llvm-master/projects/libcxx


# mkdir ~/source/llvm{,-build,-master}
# git clone https://git.llvm.org/git/llvm.git/                       ~/source/llvm-master
# git clone https://git.llvm.org/git/clang.git/                      ~/source/llvm-master/tools/clang
# git clone https://git.llvm.org/git/clang-tools-extra.git/          ~/source/llvm-master/tools/clang/tools/extra
# git clone https://git.llvm.org/git/compiler-rt.git/                ~/source/llvm-master/projects/compiler-rt
# git clone https://git.llvm.org/git/libcxx.git/                     ~/source/llvm-master/projects/libcxx
# git clone https://git.llvm.org/git/libcxxabi.git/                  ~/source/llvm-master/projects/libcxxabi
# cmake -B`ls -1d ~/source/llvm-build` -H`ls -1d ~/source/llvm-master` -GNinja -DCMAKE_INSTALL_PREFIX=`ls -1d ~/source/llvm` -DCMAKE_BUILD_TYPE=Release -DLLVM_ENABLE_ASSERTIONS=OFF
# # Wan to also build lldb by adding '-DLLVM_ENABLE_PROJECTS=clang;clang-tools-extra;libcxx;libcxxabi;lldb' but that insists on sibling directory structure rather than nested
# ninja -C ~/source/llvm-build -k 0 -j 4


# # Buid an msan libc++
#
# mkdir ~/source/msan-libcxx{,-build,-llvm-master}
# git clone https://git.llvm.org/git/llvm.git/                       ~/source/msan-libcxx-llvm-master
# git clone https://git.llvm.org/git/libcxx.git/                     ~/source/msan-libcxx-llvm-master/projects/libcxx
# git clone https://git.llvm.org/git/libcxxabi.git/                  ~/source/msan-libcxx-llvm-master/projects/libcxxabi
#
# unset UBSAN_OPTIONS
#
# cmake -B`ls -1d ~/source/msan-libcxx-build` -H`ls -1d ~/source/msan-libcxx-llvm-master` -GNinja -DCMAKE_INSTALL_PREFIX=`ls -1d ~/source/msan-libcxx` -DCMAKE_BUILD_TYPE=Release -DLLVM_USE_SANITIZER=Memory -DCMAKE_C_COMPILER=`ls -1d ~/source/llvm/bin/clang` -DCMAKE_CXX_COMPILER=`ls -1d ~/source/llvm/bin/clang++`
# ninja -C ~/source/msan-libcxx-build -k 0 -j 4 cxx
# ninja -C ~/source/msan-libcxx-build -k 0 -j 4 cxxabi
# ninja -C ~/source/msan-libcxx-build -k 0 -j 4 install-cxx
# ninja -C ~/source/msan-libcxx-build -k 0 -j 4 install-cxxabi
#
# Use like:
# ~/source/llvm/bin/clang++ -fsanitize=memory                                 -fPIE -pie -fno-omit-frame-pointer -g -O2 -std=c++17 -stdlib=libc++ -nostdinc++ -I$(ls -1d ~/source/msan-libcxx)/include/c++/v1 -L$(ls -1d ~/source/msan-libcxx)/lib -Wl,-rpath,$(ls -1d ~/source/msan-libcxx)/lib test.cpp -o test.clang_bin
# ~/source/llvm/bin/clang++ -fsanitize=memory -fsanitize-memory-track-origins -fPIE -pie -fno-omit-frame-pointer -g -O2 -std=c++17 -stdlib=libc++ -nostdinc++ -I$(ls -1d ~/source/msan-libcxx)/include/c++/v1 -L$(ls -1d ~/source/msan-libcxx)/lib -Wl,-rpath,$(ls -1d ~/source/msan-libcxx)/lib test.cpp -o test.clang_bin
