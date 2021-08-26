The process would be as follows:

1. Install previous version in a SD with `flash.sh` script.
2. Make changes, either on booted system or directly on the SD with my Linux machine.
3. Consolidate changes making a versioned dump with `build.sh` script.

In the `build.sh` script there are a number of parameters:

* P1_MOUNTING_POINT: The path on my system to partition 1 when mounted.
* P2_MOUNTING_POINT: The path on my system to partition 2 when mounted.
* ZERO_FILL: If fill the free space with zeros (to better compress).
* INSTALL_ODBETA_MODS: If download, unpack, modify and repack ODBeta distribution.
* ODBETA_VERSION: ODBeta nightly build version used.

At the end of build and flash scripts, I reinstall RG280V kernel because it is the device that I use to develop, so I don't have to install it manually. Also I remove the file flag to resize the SD card, so the image always have the same 3600MiB size.
