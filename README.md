# Puppet Notes

## Example command

~~~bash
cd <THIS_PROJECT_DIRECTORY>
puppet apply --noop --test site.pp --modulepath 'modules:$basemodulepath'
~~~

Remove the `--noop` to actual perform the changes.

## Notes on install

On XPS 15:

* To boot from Live USB, choose lower USB option not first (Legacy) one
* To get wireless working on live boot and on first boot: ????

## After a fresh install...

Ensure you have puppet installed:

    apt-get -y install puppet puppet-module-puppetlabs-stdlib puppet-module-puppetlabs-vcsrepo augeas-tools

...and that puppet has the puppetlabs-vcsrepo and puppetlabs-git modules installed:

    puppet module install acme/ohmyzsh
    puppet module install puppet-alternatives
    puppet module install puppetlabs-git

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

Mirror old home directory into a new subdirectory

## Manual Pre-Puppet Steps

* Connect to GitHub and Diskstation as lewis

## Manual Post-Puppet Steps

* For HiDPI XPS 15: "systemsettings &rarr; "Hardware" &rarr; "Display and Monitor" &rarr; "Scale Display" &rarr; 1.5
* "systemsettings" &rarr; "Search" &rarr; "File Search" &rarr; Deselect "Enable File Search" &rarr; "Apply"
* "systemsettings" &rarr; "Power Management" &rarr; make some decisions
* "systemsettings" &rarr; "Startup and Shutdown" &rarr; "Login Screen (SDDM)" &rarr; "Background" &rarr; "
* "Configure Desktop" &rarr; "Wallpaper" &rarr; "Wallpaper Type" : Hunyango
* "Configure Desktop" &rarr; "Location" &rarr; "Specify a folder" : `/opt/empty_directory`
* Download VSCode settings (via "Settings Sync" extension)
* Install "The Great Suspender" on Chrome
* Download latest [`FindBoost.cmake`](https://raw.githubusercontent.com/Kitware/CMake/master/Modules/FindBoost.cmake) on top of relevant file (eg `/usr/share/cmake-3.10/Modules/FindBoost.cmake`)
* Icons:

| | | | |
 -|-|-|-
 firefox | dolphin         | ltfg         | kate
 chrome  | calculator      | sublime-text | VSCode/cath-tools
 konsole | system settings | synaptic     | update manager

## Notes on installing CUDA

After a wasted day and lots of frustration, I still sddm to work with the drive installed by the CUDA 8 .deb file (and it flashed really annoyingly until I turned sddm off).
I then gave up when I found that the new nvcc wasn't compiling an example PTX file any faster than the old one, based on this benchmark:

Before, `/usr/bin/time nvcc --fmad=false --cubin -arch sm_30 --output-directory /tmp ~/compile_kernel.ptxtocubin.139960666117888.ptx` took about 1.14s user time
