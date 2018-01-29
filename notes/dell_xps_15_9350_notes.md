Dell XPS 15 9350 Setup Notes
============================

Try to move as much of this as possible into Puppet.

Useful links
------------

 * [Linux on a Dell XPS 15 9350 (Touch)]( http://giray.devlet.cc/linux/Laptop/DellXPS15Touch/)

Wireless
--------

The wifi device is something like this:

    06:00.0 Network controller [0280]: Broadcom Corporation BCM4352 802.11ac Wireless Network Adapter [14e4:43b1] (rev 03)

It needs a closed-source, proprietary driver, which must be manually installed. This can be done whilst running from an installation (with a Live CD in or with wired internet access) or from a Live CD in one of two ways:
 * **automatically** If installing the packages from the Live CD, ensure it's in and then use the "Software & Updates" dialogue's "Ubuntu Software" tab to add the CDROM. Then use the "Software & Updates" dialogue's "Additional Drivers" tab to select and apply the Broadcom driver. This may take quite some time (because I think it rebuilds the boot image). Or does it just fail?
 * **manually** Use dpkg to install the `dkms` package, a dependency and then the `bcmwl-kernel-source` package. Both can be found on the live CD (or USB) (**where?**).

Touchpad
--------

According to [Linux on a Dell XPS 15 9350 (Touch)]( http://giray.devlet.cc/linux/Laptop/DellXPS15Touch/) (see [Useful Links](#UsefulLinks)), it helps to install: [synaptics-quadhd-touchscreen-quirk_1_all.deb](http://linux.dell.com/files/ubuntu/contributions/synaptics-quadhd-touchscreen-quirk_1_all.deb)

GPU
---

 * [Ubuntu page on Bumblebee](https://wiki.ubuntu.com/Bumblebee#Installation)
 * [NVidia page on Optimus/CUDA](http://docs.nvidia.com/cuda/optimus-developer-guide/index.html#axzz3iCl6BDoq)
 * [Support thread on Optimus/CUDA](https://devtalk.nvidia.com/default/topic/734737/ubuntu-14-04-optimus-cuda/)
