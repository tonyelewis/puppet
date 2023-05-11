# Conan Notes

## Installing Conan

~~~sh
# sudo pip3 install conan

sudo pip3 install conan==1.59.0
~~~

(v2 seems to cause a lot of problems - sticking with 1.59 for now)

&hellip;and tell Conan to install config from this puppet repo:

~~~sh
conan config install ~/puppet/conan/config
~~~

## Updating config

After any modification to the Conan config in puppet, re-install it with the above command.

## Upgrading

~~~sh
sudo pip3 install conan --upgrade
~~~

Then run a conan command (eg `conan config install -h`) and see if it complains it can't update `settings.yml`.

If so, copy the new base and the current file to this directory:

~~~sh
cp ~/.conan/settings.yml.new ~/puppet/conan/settings.yml.orig-$(cat ~/.conan/version.txt)
cp ~/.conan/settings.yml     ~/puppet/conan/settings.$( datestamp )
~~~

&hellip; and then sort out the merges, copy to `config/`, commit and `conan config install` (and remove `~/.conan/settings.yml.new`).

## Notes on improving Conan/Cmake setup

### Adding coverage

Should be a separate "flavour" and use a separate Conan "flavour" because otherwise we might end up that all the .conan cache for the equivalent flavour `--coverage` was actually built with `--coverage`.

### Separating out per-project/per-build

There are several issues that are forcing the issue of the per-project / per-build settings currently being mashed into the build-types:

* It'd be good to allow some projects to compile under C++20
* It'd be good to have some of projects get their warning settings from the toolchain file but edit-suite's build can't really handle that at present because it includes autogen code that triggers some of the warnings.
* All of the projects are forced to use the same `CMAKE_PREFIX_PATH` which isn't lovely (but doesn't cause any direct problems)
* (It'd be nice to have per-project definitions)

Maybe have cmake-all-of grab the name of the project and pass it via an environment variable to the toolchain file?

### Consider storing each projects Conan `data` in a local directory rather than `~/.conan`?

### Add a toolchain-file and conan file for static GCC building

Should be a new build-type and a new flavour. Probably. Not 100% sure about flavour.

Start with work done for edit-suite.

### Additional

Don't worry much about definitions for now. At some point, could have some process that checks that the definitions used in the build are used in everything and match those used in the build.
