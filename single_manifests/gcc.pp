# From https://solarianprogrammer.com/2016/10/07/building-gcc-ubuntu-linux/

# sudo apt-get install build-essential libgmp-dev libmpfr-dev libmpc-dev
#
# export BUILD_GCC_VERSION=10.2.0
# export BUILD_GCC_VERSION_SHORT=10.2
# export BUILD_GCC_ROOT_DIR=$( echo ~/source )
# export BUILD_GCC_SOURCE_DIR=${BUILD_GCC_ROOT_DIR}/gcc-${BUILD_GCC_VERSION}-source
# export BUILD_GCC_BUILD_DIR=${BUILD_GCC_ROOT_DIR}/gcc-${BUILD_GCC_VERSION}-build
# export BUILD_GCC_INSTALL_BASENAME=gcc-${BUILD_GCC_VERSION}
# export BUILD_GCC_INSTALL_DIR=${BUILD_GCC_ROOT_DIR}/${BUILD_GCC_INSTALL_BASENAME}
#
# echo "BUILD_GCC_VERSION          : ${BUILD_GCC_VERSION}"
# echo "BUILD_GCC_VERSION_SHORT    : ${BUILD_GCC_VERSION_SHORT}"
# echo "BUILD_GCC_ROOT_DIR         : ${BUILD_GCC_ROOT_DIR}"
# echo "BUILD_GCC_SOURCE_DIR       : ${BUILD_GCC_SOURCE_DIR}"
# echo "BUILD_GCC_BUILD_DIR        : ${BUILD_GCC_BUILD_DIR}"
# echo "BUILD_GCC_INSTALL_BASENAME : ${BUILD_GCC_INSTALL_BASENAME}"
# echo "BUILD_GCC_INSTALL_DIR      : ${BUILD_GCC_INSTALL_DIR}"
#
# mkdir -p ${BUILD_GCC_ROOT_DIR} ${BUILD_GCC_SOURCE_DIR} ${BUILD_GCC_BUILD_DIR} ${BUILD_GCC_INSTALL_DIR}
# wget "https://ftpmirror.gnu.org/gcc/gcc-${BUILD_GCC_VERSION}/gcc-${BUILD_GCC_VERSION}.tar.gz" -O ${BUILD_GCC_ROOT_DIR}/gcc-${BUILD_GCC_VERSION}.tar.gz
# tar --directory=${BUILD_GCC_SOURCE_DIR} --strip-components=1 -zxvf ${BUILD_GCC_ROOT_DIR}/gcc-${BUILD_GCC_VERSION}.tar.gz
#
# cd ${BUILD_GCC_BUILD_DIR}
# ${BUILD_GCC_SOURCE_DIR}/configure -v --build=x86_64-linux-gnu --host=x86_64-linux-gnu --target=x86_64-linux-gnu --prefix=${BUILD_GCC_INSTALL_DIR} --enable-checking=release --enable-languages=c,c++,fortran --disable-multilib --program-suffix=-${BUILD_GCC_VERSION_SHORT}
# make -j 4
# make -j 4 install-strip
#
# rm -f                                ${BUILD_GCC_ROOT_DIR}/gcc
# ln -s ${BUILD_GCC_INSTALL_BASENAME}  ${BUILD_GCC_ROOT_DIR}/gcc
# ln -s g++-${BUILD_GCC_VERSION_SHORT} ${BUILD_GCC_INSTALL_DIR}/bin/g++
# ln -s gcc-${BUILD_GCC_VERSION_SHORT} ${BUILD_GCC_INSTALL_DIR}/bin/gcc








# # Or for trunk...
#
# export BUILD_GCC_VERSION=trunk-`datestamp`
# export BUILD_GCC_VERSION_SHORT=trunk-`datestamp`
# export BUILD_GCC_ROOT_DIR=$( echo ~/source )
# export BUILD_GCC_SOURCE_DIR=${BUILD_GCC_ROOT_DIR}/gcc-${BUILD_GCC_VERSION}-source
# export BUILD_GCC_BUILD_DIR=${BUILD_GCC_ROOT_DIR}/gcc-${BUILD_GCC_VERSION}-build
# export BUILD_GCC_INSTALL_BASENAME=gcc-${BUILD_GCC_VERSION}
# export BUILD_GCC_INSTALL_DIR=${BUILD_GCC_ROOT_DIR}/${BUILD_GCC_INSTALL_BASENAME}
#
# echo "BUILD_GCC_VERSION          : ${BUILD_GCC_VERSION}"
# echo "BUILD_GCC_VERSION_SHORT    : ${BUILD_GCC_VERSION_SHORT}"
# echo "BUILD_GCC_ROOT_DIR         : ${BUILD_GCC_ROOT_DIR}"
# echo "BUILD_GCC_SOURCE_DIR       : ${BUILD_GCC_SOURCE_DIR}"
# echo "BUILD_GCC_BUILD_DIR        : ${BUILD_GCC_BUILD_DIR}"
# echo "BUILD_GCC_INSTALL_BASENAME : ${BUILD_GCC_INSTALL_BASENAME}"
# echo "BUILD_GCC_INSTALL_DIR      : ${BUILD_GCC_INSTALL_DIR}"
#
# mkdir -p ${BUILD_GCC_ROOT_DIR} ${BUILD_GCC_BUILD_DIR} ${BUILD_GCC_INSTALL_DIR}
# svn checkout svn://gcc.gnu.org/svn/gcc/trunk "${BUILD_GCC_SOURCE_DIR}"
#
# cd ${BUILD_GCC_BUILD_DIR}
# ${BUILD_GCC_SOURCE_DIR}/configure -v --build=x86_64-linux-gnu --host=x86_64-linux-gnu --target=x86_64-linux-gnu --prefix=${BUILD_GCC_INSTALL_DIR} --enable-checking=release --enable-languages=c,c++,fortran --disable-multilib --program-suffix=-${BUILD_GCC_VERSION_SHORT}
# make -j 4
# make -j 4 install-strip
