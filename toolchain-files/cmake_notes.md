/opt/boost_1_70_0_dbgchk_c++17/lib
/opt/boost_1_70_0_normal_c++17/lib
/opt/boost_1_70_0_ubasan_c++17/lib


~~~sh
rm -rf ninja_clang_debug          ; mkdir -p ninja_clang_debug          ; BOOST_ROOT=/opt/boost_1_70_0_clang_c++14_build cmake -Bninja_clang_debug          -H. -GNinja -DCMAKE_BUILD_TYPE=DEBUG          '-DCMAKE_PREFIX_PATH='`ls -1d /opt/Qt/this-version/gcc_64`';~/source/cpprestsdk-clang;~/source/QtAV-clang;~/source/vlc-qt-clang'         -DBREAKPAD_ROOT=~/breakpad-clang-build -DCMAKE_CXX_FLAGS='-stdlib=libc++                                                                 -DBOOST_ASIO_HAS_STD_STRING_VIEW ${CMAKE_CXX_FLAGS}' -DCMAKE_C_COMPILER=/usr/bin/clang                      -DCMAKE_CXX_COMPILER=/usr/bin/clang++
rm -rf ninja_clang_release        ; mkdir -p ninja_clang_release        ; BOOST_ROOT=/opt/boost_1_70_0_clang_c++14_build cmake -Bninja_clang_release        -H. -GNinja -DCMAKE_BUILD_TYPE=RELEASE        '-DCMAKE_PREFIX_PATH='`ls -1d /opt/Qt/this-version/gcc_64`';~/source/cpprestsdk-clang;~/source/QtAV-clang;~/source/vlc-qt-clang'         -DBREAKPAD_ROOT=~/breakpad-clang-build -DCMAKE_CXX_FLAGS='-stdlib=libc++                                                                 -DBOOST_ASIO_HAS_STD_STRING_VIEW ${CMAKE_CXX_FLAGS}' -DCMAKE_C_COMPILER=/usr/bin/clang                      -DCMAKE_CXX_COMPILER=/usr/bin/clang++
rm -rf ninja_clang_relwithdebinfo ; mkdir -p ninja_clang_relwithdebinfo ; BOOST_ROOT=/opt/boost_1_70_0_clang_c++14_build cmake -Bninja_clang_relwithdebinfo -H. -GNinja -DCMAKE_BUILD_TYPE=RELWITHDEBINFO '-DCMAKE_PREFIX_PATH='`ls -1d /opt/Qt/this-version/gcc_64`';~/source/cpprestsdk-clang;~/source/QtAV-clang;~/source/vlc-qt-clang'         -DBREAKPAD_ROOT=~/breakpad-clang-build -DCMAKE_CXX_FLAGS='-stdlib=libc++                                                                 -DBOOST_ASIO_HAS_STD_STRING_VIEW ${CMAKE_CXX_FLAGS}' -DCMAKE_C_COMPILER=/usr/bin/clang                      -DCMAKE_CXX_COMPILER=/usr/bin/clang++
rm -rf ninja_clang_sanitize       ; mkdir -p ninja_clang_sanitize       ; BOOST_ROOT=/opt/boost_1_70_0_clang_c++14_build cmake -Bninja_clang_sanitize       -H. -GNinja -DCMAKE_BUILD_TYPE=DEBUG          '-DCMAKE_PREFIX_PATH='`ls -1d /opt/Qt/this-version/gcc_64`';~/source/cpprestsdk-clang;~/source/QtAV-clang;~/source/vlc-qt-clang'         -DBREAKPAD_ROOT=~/breakpad-clang-build -DCMAKE_CXX_FLAGS='-stdlib=libc++ -fsanitize=address -fsanitize=undefined -fno-omit-frame-pointer -DBOOST_ASIO_HAS_STD_STRING_VIEW ${CMAKE_CXX_FLAGS}' -DCMAKE_C_COMPILER=$( ls -1d ~/source/llvm/bin/clang ) -DCMAKE_CXX_COMPILER=$( ls -1d ~/source/llvm/bin/clang++ )
rm -rf ninja_gcc_debug            ; mkdir -p ninja_gcc_debug            ; BOOST_ROOT=/opt/boost_1_70_0_gcc_c++14_build   cmake -Bninja_gcc_debug            -H. -GNinja -DCMAKE_BUILD_TYPE=DEBUG          '-DCMAKE_PREFIX_PATH='`ls -1d /opt/Qt/this-version/gcc_64`';~/source/cpprestsdk-gcc-debug-checked;~/source/QtAV-gcc;~/source/vlc-qt-gcc' -DBREAKPAD_ROOT=~/breakpad-gcc-build   -DCMAKE_CXX_FLAGS='-D_GLIBCXX_DEBUG                                                                                                                                 ${CMAKE_CXX_FLAGS}' -DCMAKE_C_COMPILER=$( ls -1d ~/source/gcc/bin/gcc    ) -DCMAKE_CXX_COMPILER=$( ls -1d ~/source/gcc/bin/g++      )
rm -rf ninja_gcc_release          ; mkdir -p ninja_gcc_release          ; BOOST_ROOT=/opt/boost_1_70_0_gcc_c++14_build   cmake -Bninja_gcc_release          -H. -GNinja -DCMAKE_BUILD_TYPE=RELEASE        '-DCMAKE_PREFIX_PATH='`ls -1d /opt/Qt/this-version/gcc_64`';~/source/cpprestsdk-gcc;~/source/QtAV-gcc;~/source/vlc-qt-gcc'               -DBREAKPAD_ROOT=~/breakpad-gcc-build                                                                                                                                                                                           -DCMAKE_C_COMPILER=$( ls -1d ~/source/gcc/bin/gcc    ) -DCMAKE_CXX_COMPILER=$( ls -1d ~/source/gcc/bin/g++      )
rm -rf ninja_gcc_relwithdebinfo   ; mkdir -p ninja_gcc_relwithdebinfo   ; BOOST_ROOT=/opt/boost_1_70_0_gcc_c++14_build   cmake -Bninja_gcc_relwithdebinfo   -H. -GNinja -DCMAKE_BUILD_TYPE=RELWITHDEBINFO '-DCMAKE_PREFIX_PATH='`ls -1d /opt/Qt/this-version/gcc_64`';~/source/cpprestsdk-gcc;~/source/QtAV-gcc;~/source/vlc-qt-gcc'               -DBREAKPAD_ROOT=~/breakpad-gcc-build                                                                                                                                                                                           -DCMAKE_C_COMPILER=$( ls -1d ~/source/gcc/bin/gcc    ) -DCMAKE_CXX_COMPILER=$( ls -1d ~/source/gcc/bin/g++      ) -DBoost_USE_DEBUG_LIBS=OFF
~~~



BOOST_ROOT=/opt/boost_1_70_0_clang_c++14_build
cmake -Bninja_clang_debug
-H.
-GNinja
-DCMAKE_BUILD_TYPE=DEBUG
'-DCMAKE_PREFIX_PATH='`ls -1d /opt/Qt/this-version/gcc_64`';~/source/cpprestsdk-clang;~/source/QtAV-clang;~/source/vlc-qt-clang'
-DBREAKPAD_ROOT=~/breakpad-clang-build
-DCMAKE_CXX_FLAGS='-stdlib=libc++                                                                 -DBOOST_ASIO_HAS_STD_STRING_VIEW ${CMAKE_CXX_FLAGS}'
-DCMAKE_C_COMPILER=$( ls -1d ~/source/llvm/bin/clang )
-DCMAKE_CXX_COMPILER=$( ls -1d ~/source/llvm/bin/clang++ )


BOOST_ROOT=/opt/boost_1_70_0_clang_c++14_build
cmake -Bninja_clang_sanitize
-H.
-GNinja
-DCMAKE_BUILD_TYPE=DEBUG
'-DCMAKE_PREFIX_PATH='`ls -1d /opt/Qt/this-version/gcc_64`';~/source/cpprestsdk-clang;~/source/QtAV-clang;~/source/vlc-qt-clang'
-DBREAKPAD_ROOT=~/breakpad-clang-build
-DCMAKE_CXX_FLAGS='-stdlib=libc++ -fsanitize=address -fsanitize=undefined -fno-omit-frame-pointer -DBOOST_ASIO_HAS_STD_STRING_VIEW ${CMAKE_CXX_FLAGS}'
-DCMAKE_C_COMPILER=$( ls -1d ~/source/llvm/bin/clang )
-DCMAKE_CXX_COMPILER=$( ls -1d ~/source/llvm/bin/clang++ )

BOOST_ROOT=/opt/boost_1_70_0_gcc_c++14_build
cmake -Bninja_gcc_release
-H.
-GNinja
-DCMAKE_BUILD_TYPE=RELEASE
'-DCMAKE_PREFIX_PATH='`ls -1d /opt/Qt/this-version/gcc_64`';~/source/cpprestsdk-gcc;~/source/QtAV-gcc;~/source/vlc-qt-gcc'
-DBREAKPAD_ROOT=~/breakpad-gcc-build
-DCMAKE_C_COMPILER=$( ls -1d ~/source/gcc/bin/gcc )
-DCMAKE_CXX_COMPILER=$( ls -1d ~/source/gcc/bin/g++ )
















BOOST_ROOT=/opt/boost_1_70_0_clang_c++14_build
cmake -Bninja_clang_relwithdebinfo
-H.
-GNinja
-DCMAKE_BUILD_TYPE=RELWITHDEBINFO
'-DCMAKE_PREFIX_PATH='`ls -1d /opt/Qt/this-version/gcc_64`';~/source/cpprestsdk-clang;~/source/QtAV-clang;~/source/vlc-qt-clang'
-DBREAKPAD_ROOT=~/breakpad-clang-build
-DCMAKE_CXX_FLAGS='-stdlib=libc++                                                                 -DBOOST_ASIO_HAS_STD_STRING_VIEW ${CMAKE_CXX_FLAGS}'
-DCMAKE_C_COMPILER=/usr/bin/clang
-DCMAKE_CXX_COMPILER=/usr/bin/clang++

BOOST_ROOT=/opt/boost_1_70_0_gcc_c++14_build
cmake -Bninja_gcc_debug
-H.
-GNinja
-DCMAKE_BUILD_TYPE=DEBUG
'-DCMAKE_PREFIX_PATH='`ls -1d /opt/Qt/this-version/gcc_64`';~/source/cpprestsdk-gcc-debug-checked;~/source/QtAV-gcc;~/source/vlc-qt-gcc'
-DBREAKPAD_ROOT=~/breakpad-gcc-build
-DCMAKE_CXX_FLAGS='-D_GLIBCXX_DEBUG                                                                                                                                 ${CMAKE_CXX_FLAGS}'
-DCMAKE_C_COMPILER=$( ls -1d ~/source/gcc/bin/gcc )
-DCMAKE_CXX_COMPILER=$( ls -1d ~/source/gcc/bin/g++ )

BOOST_ROOT=/opt/boost_1_70_0_gcc_c++14_build
cmake -Bninja_gcc_relwithdebinfo
-H.
-GNinja
-DCMAKE_BUILD_TYPE=RELWITHDEBINFO
'-DCMAKE_PREFIX_PATH='`ls -1d /opt/Qt/this-version/gcc_64`';~/source/cpprestsdk-gcc;~/source/QtAV-gcc;~/source/vlc-qt-gcc'
-DBREAKPAD_ROOT=~/breakpad-gcc-build
-DCMAKE_C_COMPILER=$( ls -1d ~/source/gcc/bin/gcc )
-DCMAKE_CXX_COMPILER=$( ls -1d ~/source/gcc/bin/g++ )
-DBoost_USE_DEBUG_LIBS=OFF

BOOST_ROOT=/opt/boost_1_70_0_clang_c++14_build
cmake -Bninja_clang_release
-H.
-GNinja
-DCMAKE_BUILD_TYPE=RELEASE
'-DCMAKE_PREFIX_PATH='`ls -1d /opt/Qt/this-version/gcc_64`';~/source/cpprestsdk-clang;~/source/QtAV-clang;~/source/vlc-qt-clang'
-DBREAKPAD_ROOT=~/breakpad-clang-build
-DCMAKE_CXX_FLAGS='-stdlib=libc++                                                                 -DBOOST_ASIO_HAS_STD_STRING_VIEW ${CMAKE_CXX_FLAGS}'
-DCMAKE_C_COMPILER=/usr/bin/clang
-DCMAKE_CXX_COMPILER=/usr/bin/clang++
