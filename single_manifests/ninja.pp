# # Compiling Ninja to play with `ninja -t browse` because there isn't yet a release that incorporates
# # the fix to allow it to work with Python 3.8, the standard Python in Ubuntu 20.04
# #
# # (current release is v1.10.0 (from 28th Jan 2020) as of 16th July 2020)
# # (fix is https://github.com/ninja-build/ninja/pull/1744 from 20th Feb 2020)
# #
# # TODO: At some point when the Ubuntu version of Ninja is more up to date, remove this.

# # Standard CMake build doesn't enable browse functionality, so use ./configure.py instead...

# rm -rf ${HOME}/source/ninja
# git clone https://github.com/ninja-build/ninja.git ${HOME}/source/ninja
# cd ${HOME}/source/ninja
# ./configure.py --bootstrap
