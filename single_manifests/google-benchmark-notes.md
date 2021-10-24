# Google Benchmark

~~~sh
git clone https://github.com/google/benchmark.git  ~/google-benchmark
git clone https://github.com/google/googletest.git ~/google-benchmark/googletest
cmake -GNinja -DCMAKE_BUILD_TYPE=RELEASE -H/home/lewis/google-benchmark -B/home/lewis/google-benchmark-clang-build -DCMAKE_INSTALL_PREFIX=/home/lewis/google-clang -DCMAKE_C_COMPILER=/usr/bin/clang -DCMAKE_CXX_COMPILER=/usr/bin/clang++ -DCMAKE_CXX_FLAGS="-stdlib=libc++"
cmake -GNinja -DCMAKE_BUILD_TYPE=RELEASE -H/home/lewis/google-benchmark -B/home/lewis/google-benchmark-gcc-build   -DCMAKE_INSTALL_PREFIX=/home/lewis/google-gcc
ninja -C ~/google-benchmark-clang-build -k 0 -j $( nproc )
ninja -C ~/google-benchmark-gcc-build   -k 0 -j $( nproc )
ninja -C ~/google-benchmark-clang-build -k 0 -j $( nproc ) install
ninja -C ~/google-benchmark-gcc-build   -k 0 -j $( nproc ) install
~~~
