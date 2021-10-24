# https://llvm.org/docs/GettingStarted.html

# # To clean up previous version:
# mkdir ~/source/llvm.stopped.$( datestamp )
# mv ~/source/llvm{,-build,-master} ~/source/llvm.stopped.$( datestamp )

# sudo apt-get install build-essential subversion swig python2.7-dev libedit-dev libncurses5-dev

# mkdir -p  ~/source/llvm{,-build,-master}
# git clone --depth 100  https://github.com/llvm/llvm-project.git ~/source/llvm-master
# cmake -B$( ls -1d ~/source/llvm-build ) -H$( ls -1d ~/source/llvm-master/llvm ) -GNinja -DCMAKE_INSTALL_PREFIX=$( ls -1d ~/source/llvm ) -DCMAKE_BUILD_TYPE=Release -DLLVM_ENABLE_ASSERTIONS=OFF '-DLLVM_ENABLE_PROJECTS=clang;clang-tools-extra;compiler-rt;libcxx;libcxxabi;lldb'
# ninja -C ~/source/llvm-build -k 0
# ninja -C ~/source/llvm-build -k 0 install

# # You may consider cloning the whole respository (ie remove `--depth 100`) and then checking-out a tag (eg `llvmorg-11.0.0-rc6`)

# # If necessary, comment out line `CHECK_SIZE_AND_OFFSET(ipc_perm, mode);` in `~/source/llvm-master/compiler-rt/lib/sanitizer_common/sanitizer_platform_limits_posix.cpp`

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
#
# # To clean up previous version:
# mkdir ~/source/msan-libcxx-llvm.stopped.$( datestamp )
# mv ~/source/msan-libcxx{,-build,-llvm-master} ~/source/msan-libcxx-llvm.stopped.$( datestamp )
#
# mkdir -p ~/source/msan-libcxx{,-build,-llvm-master}
# git clone --depth 100  https://github.com/llvm/llvm-project.git ~/source/msan-libcxx-llvm-master
#
# unset UBSAN_OPTIONS
#
# cmake -B$( ls -1d ~/source/msan-libcxx-build ) -H$( ls -1d ~/source/msan-libcxx-llvm-master/llvm ) -GNinja -DCMAKE_INSTALL_PREFIX=$( ls -1d ~/source/msan-libcxx ) -DCMAKE_BUILD_TYPE=Release -DLLVM_USE_SANITIZER=Memory -DCMAKE_C_COMPILER=$( ls -1d ~/source/llvm/bin/clang ) -DCMAKE_CXX_COMPILER=$( ls -1d ~/source/llvm/bin/clang++ )  '-DLLVM_ENABLE_PROJECTS=libcxx;libcxxabi'
# ninja -C ~/source/msan-libcxx-build -k 0 -j $( nproc )         cxx         cxxabi
# ninja -C ~/source/msan-libcxx-build -k 0 -j $( nproc ) install-cxx install-cxxabi
#
# Use like:
# ~/source/llvm/bin/clang++ -fsanitize=memory                                 -fPIE -pie -fno-omit-frame-pointer -g -O2 -std=c++17 -stdlib=libc++ -nostdinc++ -I$(ls -1d ~/source/msan-libcxx)/include/c++/v1 -L$(ls -1d ~/source/msan-libcxx)/lib -Wl,-rpath,$(ls -1d ~/source/msan-libcxx)/lib test.cpp -o test.clang_bin
# ~/source/llvm/bin/clang++ -fsanitize=memory -fsanitize-memory-track-origins -fPIE -pie -fno-omit-frame-pointer -g -O2 -std=c++17 -stdlib=libc++ -nostdinc++ -I$(ls -1d ~/source/msan-libcxx)/include/c++/v1 -L$(ls -1d ~/source/msan-libcxx)/lib -Wl,-rpath,$(ls -1d ~/source/msan-libcxx)/lib test.cpp -o test.clang_bin

# # You may consider cloning the whole respository (ie remove `--depth 100`) and then checking-out a tag (eg `llvmorg-11.0.0-rc6`)



# # # Old within-tree approach:
# # svn co    http://llvm.org/svn/llvm-project/llvm/trunk              ~/source/llvm-master
# # svn co    http://llvm.org/svn/llvm-project/cfe/trunk               ~/source/llvm-master/tools/clang
# # svn co    http://llvm.org/svn/llvm-project/clang-tools-extra/trunk ~/source/llvm-master/tools/clang/tools/extra
# # svn co    http://llvm.org/svn/llvm-project/compiler-rt/trunk       ~/source/llvm-master/projects/compiler-rt
# # svn co    http://llvm.org/svn/llvm-project/libcxx/trunk            ~/source/llvm-master/projects/libcxx
