# Puppet Notes

## Example command

~~~bash
cd <THIS_PROJECT_DIRECTORY>
puppet apply --noop --test site.pp --modulepath 'modules:$basemodulepath'
~~~

Remove the `--noop` to actual perform the changes.

## Issues

Ubuntu 18.04 on floppyrabbit:

* Whinged about 'concat ohmyzsh .zshrc and my suffix' using "${::general_desktop::home_dir}/.oh-my-zsh/templates/zshrc.zsh-template" which didn't yet exist.

## Notes on install

*BOOT THE LIVEUSB IN UEFI MODE IFF YOU WANT TO INSTALL IN UEFI MODE*

On XPS 15:

* To boot from Live USB, choose lower USB option not first (Legacy) one
* To get wireless working on live boot and on first boot: ????

## After a fresh install&hellip;

Ensure you have puppet installed:

~~~sh
apt-get -y install puppet puppet-module-puppetlabs-stdlib puppet-module-puppetlabs-vcsrepo augeas-tools
~~~

...and that puppet has the puppetlabs-vcsrepo and puppetlabs-git modules installed:

~~~sh
puppet module install acme/ohmyzsh
puppet module install puppet-alternatives
puppet module install puppetlabs-git
~~~

(Pre Ubuntu 16.04, the puppet-module-puppetlabs-vcsrepo didn't exist so that has to be installed with `puppet module install puppetlabs-vcsrepo` instead)

## Procedure for wiping

Prepare:

* Ensure the VSCode settings have been uploaded and that the access details are available
* Copy ~/.eclipse/user_dictionary to the puppet repository's modules/eclipse_user/files/eclipse_user_dictionary and commit/push changes
* Update `modules/plasma_user/files/sublime_text_user_preferences` from `~/.config/sublime-text-3/Packages/User/Preferences.sublime-settings`
* Ensure all Git repositories are fully clean (ie up-to-date, stashless and pushed)
* Check for other_stuff_to_git_ignore directories
* Check for any old repositories
* Check for anything in home directory
* Remove the biggest space-wasters in the home directory and mirror elsewhere

Overwrite install

For bigslide:

* `sudo dpkg -i /cdrom/pool/main/d/dkms/dkms_2.2.0.3-2ubuntu6_all.deb`
* `sudo dpkg -i /cdrom/pool/restricted/b/bcmwl/bcmwl-kernel-source_6.30.223.248+bdcom-0ubuntu7_amd64.deb`

Unfortunately this actually requires manually building up a big `dpkg -i` command with all the dependencies, which can be found with commands like `find /cdrom/pool/main/ -iname '*g++*'`. A typical list might include: `b/binutils/binutils*.deb`, `b/binutils/binutils-common*.deb`, `b/binutils/binutils-x86-64-linux-gnu*.deb`, `b/binutils/libbinutils*.deb`, `b/binutils/libctf-nobfd0*.deb`, `b/binutils/libctf0*.deb`, `b/build-essential/build-essential*.deb`, `d/dkms/dkms*.deb`, `d/dpkg/dpkg-dev*.deb`, `g/gcc-*/g++-*.deb`, `g/gcc-*/gcc-*.deb`, `g/gcc-*/libasan5*.deb`, `g/gcc-*/libatomic1_10*.deb`, `g/gcc-*/libgcc-*-dev*.deb`, `g/gcc-*/libitm1_10*.deb`, `g/gcc-*/liblsan0_10*.deb`, `g/gcc-*/libquadmath0_10*.deb`, `g/gcc-*/libstdc++-*-dev*.deb`, `g/gcc-*/libtsan0_10*.deb`, `g/gcc-*/libubsan1_10*.deb`, `g/gcc-defaults/g++_*.deb`, `g/gcc-defaults/gcc_*.deb`, `g/glibc/libc-dev-bin*.deb`, `g/glibc/libc6-dev*.deb`, `l/linux/linux-libc-dev*.deb`, `libx/libxcrypt/libcrypt-dev*.deb`, `m/make-dfsg/make*.deb`.

(and manually install all the dependency tree those things require :) )

For strongmango, eventually managed to just get one of the wifi dongles working on live USB and then after a couple of boots of the installed OS, it recognised the internal wifi (which probably happened after I'd done the UEFI secure boot MOK enrollment I was instructed to perform.)

When installing Ubuntu 18.04 on bigslide, the installer repeatedly crashed just at the point of getting going with the install. The solution turned out to be to turn the display setting to 100% (see [this](https://bugs.launchpad.net/ubuntu/+source/ubiquity/+bug/1751252)).

Mirror old home directory into a new subdirectory

## Manual Pre-Puppet Steps

* Create ssh key: `ssh-keygen -t ed25519`
* Sort out keys for GitHub and Diskstation and ensure can clone from both

## Manual Post-Puppet Steps

* (**IMPORTANT** stop's meta+l hibernating machine) In `~/.config/kglobalshortcutsrc`, change `Hibernate=Hibernate,Hibernate,Hibernate` to `Hibernate=none,Hibernate,Hibernate`
* (**IMPORTANT** stop's meta+l hibernating machine) In `~/.config/kglobalshortcutsrc`, change `Sleep=Sleep,Sleep,Suspend`               to `Sleep=none,Sleep,Suspend`
* For HiDPI XPS 15: "systemsettings &rarr; "Hardware" &rarr; "Display and Monitor" &rarr; "Scale Display" &rarr; 1.5
* "systemsettings" &rarr; "Search" &rarr; "File Search" &rarr; Deselect "Enable File Search" &rarr; "Apply"
* "systemsettings" &rarr; "Power Management" &rarr; make some decisions
* "systemsettings" &rarr; "Startup and Shutdown" &rarr; "Login Screen (SDDM)" &rarr; "Background" &rarr; "
* "systemsettings" &rarr; "Personalisation" &rarr; "Account Details" &rarr; "KDE Wallet" &rarr; "Wallet Preferences" &rarr; untick "Enable the KDE wallet subsystem"
* "Configure Desktop" &rarr; "Wallpaper" &rarr; "Wallpaper Type" : Hunyango
* "Configure Desktop" &rarr; "Location" &rarr; "Specify a folder" : `/opt/empty_directory`
* Copy binary from https://github.com/cantino/mcfly/releases/latest (mcfly-vX.X.X-x86_64-unknown-linux-musl.tar.gz?) into ~/bin ?
* Chrome settings: "Advanced" -> "Allow Chrome sign-in" -> false
* Chrome settings: "Advanced" -> "Downloads" -> "/tmp" -> Ask
* Chrome settings: "On start-up" -> "Continue where you left off"; "Download location" -> "/tmp"; "Ask where to save each file before downloading" -> true
* Chrome settings: "Privacy and security" -> "Site settings" -> "Location" -> "Blocked; "Motions sensors" -> "Blocked"
* Chrome bookmarks from `~/puppet/browser_bookmarks.html`
* Chrome settings -> Manage search engines -> Add -> google.co.uk / google.co.uk / https://www.google.co.uk/search?&q=%s
* Firefox preferences: "When Firefox starts" -> "Show my windows and tabs from last time"
* Firefox preferences: save files to /tmp -> "Always ask you where to save files"
* Download VSCode settings (now using official [https://code.visualstudio.com/docs/editor/settings-sync]("Settings Sync") with my personal GitHub account; previously used "Settings Sync" extension)
* Install "1Password" on Chrome
* Download latest [`FindBoost.cmake`](https://raw.githubusercontent.com/Kitware/CMake/master/Modules/FindBoost.cmake) on top of relevant file (eg `/usr/share/cmake-3.10/Modules/FindBoost.cmake`)
* Change clock to show date
* Icons:

| | | | |
 -|-|-|-
 firefox | dolphin         | ltfg         | kate
 chrome  | calculator      | sublime-text | VSCode/cath-tools
 konsole | system settings | synaptic     | update manager

For Ubuntu 20.04 on XSP 17, had problem with screen tearing/flickering. It's starting to look like the problem is [this](https://wiki.archlinux.org/title/intel_graphics#Screen_flickering) and that the solution is to change `/etc/default/grub`:

~~~diff
10c10
< GRUB_CMDLINE_LINUX_DEFAULT="quiet splash"
---
> GRUB_CMDLINE_LINUX_DEFAULT="quiet splash i915.enable_psr=0"
~~~

...and then `sudo update-grub`.

Don't fiddle XPS 15's fans - you only make stuff worse.

Audio stuttering :

* https://askubuntu.com/questions/1044552/audio-stuttering-in-ubuntu-18-04 ? Don't think so.
* Switch profile to "Analogue Stereo Output" rather than "Analogue Stereo Duplex" ? Don't think so.
* `pulseaudio -k && sudo alsa force-reload` ? Don't think so.
* https://askubuntu.com/a/1230834 ? Don't think so.
* https://askubuntu.com/a/1133818 ? Don't thing so.
* https://askubuntu.com/a/859830  ? Maybe - even if not, still consult https://wiki.archlinux.org/index.php/PulseAudio/Troubleshooting#Glitches.2C_skips_or_crackling

## Stuff to Add

* Copy binary from https://github.com/cantino/mcfly/releases/latest (mcfly-vX.X.X-x86_64-unknown-linux-musl.tar.gz?) into ~/bin ?
* Possibly `azcopy` into `~/bin`?
* `move-tab-to-left` and `move-tab-to-right` in `~/.local/share/kxmlgui5/konsole/konsoleui.rc`
* Conan settings.yml (need to run a conan command to create it and then need to add flavours)
* Conan bincrafters (`conan remote add bincrafters https://api.bintray.com/conan/bincrafters/public-conan`)
* Had to install download of CMake 3.12 on Ubuntu 18.04 LTS on bigslide and put link in `~/bin` - but maybe future Ubuntu releases will have &ge; 3.12?
* Consider adding the following to git config (or does this now just work with `git mergetool`?):
      [merge]
              tool = mymeld
              conflictstyle = diff3
      [mergetool "mymeld"]
              cmd = meld $LOCAL $BASE $REMOTE -o $MERGED --diff $BASE $LOCAL --diff $BASE $REMOTE --auto-merge
* Consider removing the ugly backdrop:
  * Login: some change to `/etc/sddm.conf`
  * Screensaver: `~/.config/kscreenlockerrc` &rarr; `[Greeter]` &rarr; `WallpaperPlugin=org.kde.color`
* Possibly add gimp and if so, possibly add gimp-help-en to avoid annoying language support messages
* Consider installing cppreference-doc-en-html package rather than downloading from cppreference?
* Add Jekyll? As root: `gem install jekyll bundler; gem install jekyll bundler; gem install minima; gem install jekyll-feed ;`
* Java ( http://download.oracle.com/otn-pub/java/jdk/8u91-b14/jdk-8u91-linux-x64.tar.gz )?
* Download https://dl.google.com/dl/android/studio/ide-zips/2.1.1.0/android-studio-ide-143.2821654-linux.zip to /opt/ and extract there
* Possibly install zlib1g:i386 for android studio too
* ~/.config/baloofilerc should contain: "[Basic Settings]\nIndexing-Enabled=false" (fails to parse under any lens once the required addition is in there)
* Possibly just overwrite ~/.config/powermanagementprofilesrc ?
* Show the date on the clock (`~/.config/plasma-org.kde.plasma.desktop-appletsrc` - might be difficult because it appears to use indices to refer to the correct applet)
* Possibly add package `delta`, which is tool for minimizing failing code
* Possibly add package `creduce` (C/C++ only), which worked *really* well reducing 60K CImg.h header to few lines ( https://bugs.llvm.org/show_bug.cgi?id=32665 )
* Add download/install/configuration of proprietary Java JDK / JVM (see notes in email about this)
* Figure out how Konsole saves its profiles, then save "Mouse"-> "Characters [...]" to include '$'
* ~/.kde/share/config/okularpartrc Should contain: "[Zoom]\nZoomMode=2"
* Qt : download `http://download.qt.io/official_releases/online_installers/qt-unified-linux-x64-online.run` to ~/source and make executable
* Consider `chmod -R o-w ~/source/Qt` and `chmod -R g-w ~/source/Qt` once Qt's installed
* Install more recent CUDA Toolkit (http://developer.download.nvidia.com/compute/cuda/7.5/Prod/local_installers/cuda-repo-ubuntu1504-7-5-local_7.5-18_amd64.deb) ? (ln -s /usr/bin/g++-4.9 /usr/local/cuda-7.5/bin/g++ ; ln -s /usr/bin/gcc-4.9 /usr/local/cuda-7.5/bin/gcc ; )
* Boot-time initialisation of CUDA (checked: both parts are required):
  * append the following to the bottom of /etc/modules:
      nvidia
      nvidia-uvm
  * Write the following to the new file /etc/udev/rules.d/70-tony-nvidia-uvm.rules :
     KERNEL=="nvidia_uvm", RUN+="/bin/bash -c '/bin/mknod -m 666 /dev/nvidia-uvm c 247 0; /bin/chgrp video /dev/nvidia-uvm'"

## CUDA

### Notes on installing CUDA

After a wasted day and lots of frustration, I still sddm to work with the drive installed by the CUDA 8 .deb file (and it flashed really annoyingly until I turned sddm off).
I then gave up when I found that the new nvcc wasn't compiling an example PTX file any faster than the old one, based on this benchmark:

Before, `/usr/bin/time nvcc --fmad=false --cubin -arch sm_30 --output-directory /tmp ~/compile_kernel.ptxtocubin.139960666117888.ptx` took about 1.14s user time

### Installing CUDA on bigslide

* Use the additional drivers that pops up to install nvidia-XXX (Recommended driver)
* Download the &hellip;`.run` file for a CUDA Toolkit (check the Toolkit/driver compatibility chart [here](https://docs.nvidia.com/cuda/cuda-toolkit-release-notes/index.html) to match the driver that Ubuntu has installed)
* Suggest put samples in `/home/lewis/source`
* May have to pass the `--override` flag to the &hellip;`.run` file if the OS compiler isn't the one it wants
* Will probably get the following errors:
  * `Missing recommended library: libGL.so`
  * `Missing recommended library: libGLU.so`
  * `Missing recommended library: libXi.so`
  * `Missing recommended library: libXmu.so`
* Which can be fixed with the following:
  * `sudo apt-get install libglu1-mesa-dev libglvnd-dev libxi-dev libxmu-dev`
  * (for libGLU.so, libGL.so, libXi.so, libXmu.so respectively)
  * `ln -s /usr/lib/x86_64-linux-gnu/libGL.so  /usr/lib/libGL.so`
  * `ln -s /usr/lib/x86_64-linux-gnu/libGLU.so /usr/lib/libGLU.so`
  * `ln -s /usr/lib/x86_64-linux-gnu/libXi.so  /usr/lib/libXi.so`
  * `ln -s /usr/lib/x86_64-linux-gnu/libXmu.so /usr/lib/libXmu.so`

Notes from end of installation:

~~~no-highlight
Please make sure that
 -   PATH includes /usr/local/cuda-9.1/bin
 -   LD_LIBRARY_PATH includes /usr/local/cuda-9.1/lib64, or, add /usr/local/cuda-9.1/lib64 to /etc/ld.so.conf and run ldconfig as root

To uninstall the CUDA Toolkit, run the uninstall script in /usr/local/cuda-9.1/bin
~~~

### CUDA and GCC

To make CUDA play more nicely, install the version of GCC that it wants beside the main compiler and then link those binaries in its bin directory, eg:

~~~no-highlight
sudo apt-get gcc-6 g++6
sudo ln -s /usr/bin/g++-6        /usr/local/cuda/bin/g++
sudo ln -s /usr/bin/gcc-6        /usr/local/cuda/bin/gcc
sudo ln -s /usr/bin/gcc-ar-6     /usr/local/cuda/bin/gcc-ar
sudo ln -s /usr/bin/gcc-nm-6     /usr/local/cuda/bin/gcc-nm
sudo ln -s /usr/bin/gcc-ranlib-6 /usr/local/cuda/bin/gcc-ranlib
sudo ln -s /usr/bin/gcov-6       /usr/local/cuda/bin/gcov
sudo ln -s /usr/bin/gcov-dump-6  /usr/local/cuda/bin/gcov-dump
sudo ln -s /usr/bin/gcov-tool-6  /usr/local/cuda/bin/gcov-tool
~~~

