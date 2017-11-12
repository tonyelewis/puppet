Puppet Notes
============

Notes on install
----------------

On XPS 15:
 * To boot from Live USB, choose lower USB option not first (Legacy) one
 * To get wireless working on live boot and on first boot: ????

After a fresh install...
------------------------

Ensure you have puppet installed:

    apt-get -y install puppet puppet-module-puppetlabs-stdlib puppet-module-puppetlabs-vcsrepo augeas-tools

...and that puppet has the puppetlabs-vcsrepo and puppetlabs-git modules installed:

    puppet module install puppetlabs-git

(Pre Ubuntu 16.04, the puppet-module-puppetlabs-vcsrepo didn't exist so that has to be installed with `puppet module install puppetlabs-vcsrepo` instead)

Example command
---------------

    cd <THIS_PROJECT_DIRECTORY>
    puppet apply --noop --test site.pp --modulepath 'modules:$basemodulepath'

Remove the `--noop` to actual perform the changes.

Procedure for wiping
--------------------

Prepare:
 * Copy ~/.eclipse/user_dictionary to the puppet repository's modules/eclipse_user/files/eclipse_user_dictionary and commit/push changes
 * Ensure all Git repositories are fully clean (ie up-to-date, stashless and pushed)
 * Check for other_stuff_to_git_ignore directories
 * Check for any old repositories
 * Check for anything in home directory
 * Remove the biggest space-wasters in the home directory and mirror elsewhere

Overwrite install

Mirror old home directory into a new subdirectory

Manual Steps
------------
 * "systemsettings" -> "Search" -> "File Search" -> Deselect "Enable File Search" -> "Apply"
 * "systemsettings" -> "Power Management" -> make some decisions



Notes on installing CUDA
----------------------------------------------
After a wasted day and lots of frustration, I still sddm to work with the drive installed by the CUDA 8 .deb file (and it flashed really annoyingly until I turned sddm off).
I then gave up when I found that the new nvcc wasn't compiling an example PTX file any faster than the old one, based on this benchmark:

Before, `/usr/bin/time nvcc --fmad=false --cubin -arch sm_30 --output-directory /tmp ~/compile_kernel.ptxtocubin.139960666117888.ptx` took about 1.14s user time
