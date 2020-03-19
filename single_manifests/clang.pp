# https://llvm.org/docs/GettingStarted.html



# svn co    http://llvm.org/svn/llvm-project/llvm/trunk              ~/source/llvm-master
# svn co    http://llvm.org/svn/llvm-project/cfe/trunk               ~/source/llvm-master/tools/clang
# svn co    http://llvm.org/svn/llvm-project/clang-tools-extra/trunk ~/source/llvm-master/tools/clang/tools/extra
# svn co    http://llvm.org/svn/llvm-project/compiler-rt/trunk       ~/source/llvm-master/projects/compiler-rt
# svn co    http://llvm.org/svn/llvm-project/libcxx/trunk            ~/source/llvm-master/projects/libcxx

# sudo apt-get install build-essential subversion swig python2.7-dev libedit-dev libncurses5-dev

# mkdir -p  ~/source/llvm{,-build,-master}
# git clone https://git.llvm.org/git/llvm.git/                       ~/source/llvm-master/llvm
# git clone https://git.llvm.org/git/lldb.git/                       ~/source/llvm-master/lldb
# git clone https://git.llvm.org/git/clang.git/                      ~/source/llvm-master/clang
# git clone https://git.llvm.org/git/clang-tools-extra.git/          ~/source/llvm-master/clang-tools-extra
# git clone https://git.llvm.org/git/compiler-rt.git/                ~/source/llvm-master/compiler-rt
# git clone https://git.llvm.org/git/libcxx.git/                     ~/source/llvm-master/libcxx
# git clone https://git.llvm.org/git/libcxxabi.git/                  ~/source/llvm-master/libcxxabi
# cmake -B$( ls -1d ~/source/llvm-build ) -H$( ls -1d ~/source/llvm-master/llvm ) -GNinja -DCMAKE_INSTALL_PREFIX=$( ls -1d ~/source/llvm ) -DCMAKE_BUILD_TYPE=Release -DLLVM_ENABLE_ASSERTIONS=OFF '-DLLVM_ENABLE_PROJECTS=clang;clang-tools-extra;compiler-rt;libcxx;libcxxabi;lldb'
# ninja -C ~/source/llvm-build -k 0
# ninja -C ~/source/llvm-build -k 0 install

# There may be things that are needed in LLVM_ENABLE_PROJECTS or that might be worth trying (lld?)
#
# List of valid LLVM_ENABLE_PROJECTS entries (from https://llvm.org/docs/CMake.html, 19th March 2020):
#  * clang
#  * clang-tools-extra
#  * compiler-rt
#  * debuginfo-tests
#  * libc
#  * libclc
#  * libcxx
#  * libcxxabi
#  * libunwind
#  * lld
#  * lldb
#  * openmp
#  * parallel-libs
#  * polly
#  * pstl


# # Buid an msan libc++
#
# mkdir -p ~/source/msan-libcxx{,-build,-llvm-master}
# git clone https://git.llvm.org/git/llvm.git/                       ~/source/msan-libcxx-llvm-master/llvm
# git clone https://git.llvm.org/git/libcxx.git/                     ~/source/msan-libcxx-llvm-master/libcxx
# git clone https://git.llvm.org/git/libcxxabi.git/                  ~/source/msan-libcxx-llvm-master/libcxxabi
#
# unset UBSAN_OPTIONS
#
# cmake -B$( ls -1d ~/source/msan-libcxx-build ) -H$( ls -1d ~/source/msan-libcxx-llvm-master/llvm ) -GNinja -DCMAKE_INSTALL_PREFIX=$( ls -1d ~/source/msan-libcxx ) -DCMAKE_BUILD_TYPE=Release -DLLVM_USE_SANITIZER=Memory -DCMAKE_C_COMPILER=$( ls -1d ~/source/llvm/bin/clang ) -DCMAKE_CXX_COMPILER=$( ls -1d ~/source/llvm/bin/clang++ )  '-DLLVM_ENABLE_PROJECTS=libcxx;libcxxabi'
# ninja -C ~/source/msan-libcxx-build -k 0 -j 4         cxx         cxxabi
# ninja -C ~/source/msan-libcxx-build -k 0 -j 4 install-cxx install-cxxabi
#
# Use like:
# ~/source/llvm/bin/clang++ -fsanitize=memory                                 -fPIE -pie -fno-omit-frame-pointer -g -O2 -std=c++17 -stdlib=libc++ -nostdinc++ -I$(ls -1d ~/source/msan-libcxx)/include/c++/v1 -L$(ls -1d ~/source/msan-libcxx)/lib -Wl,-rpath,$(ls -1d ~/source/msan-libcxx)/lib test.cpp -o test.clang_bin
# ~/source/llvm/bin/clang++ -fsanitize=memory -fsanitize-memory-track-origins -fPIE -pie -fno-omit-frame-pointer -g -O2 -std=c++17 -stdlib=libc++ -nostdinc++ -I$(ls -1d ~/source/msan-libcxx)/include/c++/v1 -L$(ls -1d ~/source/msan-libcxx)/lib -Wl,-rpath,$(ls -1d ~/source/msan-libcxx)/lib test.cpp -o test.clang_bin
