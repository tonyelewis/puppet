Puppet Notes
============

Notes on install
----------------

On XPS 15:
 * To boot from Live USB, choose lower USB option not first (Legacy) one
 * To get wireless working on live boot and on first boot: ????

After a fresh install...
------------------------

Ensure you have puppet installed

    apt-get -y install puppet puppet-module-puppetlabs-stdlib augeas-tools

...and that puppet has the puppetlabs-vcsrepo and puppetlabs-git modules installed:

    puppet module install puppetlabs-vcsrepo
    puppet module install puppetlabs-git

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
