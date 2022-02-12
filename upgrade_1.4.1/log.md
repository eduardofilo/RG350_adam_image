# Create .tgz

```
DIRECTORY=$(pwd)
cd ${DIRECTORY}
tar --directory=${DIRECTORY}/root/ -czvf Sideload.tgz media
```

# Check permissions

```
tar -tvf Sideload.tgz
```

# Apply upgrade

The upgrade_1.4.1.tgz file allows to update version 1.4 to 1.4.1 without having to flash again. To do this, proceed as follows:

1. Copy the upgrade_1.4.1.tgz file to the root of the external card.
2. Insert the external card in the console and boot.
3. Connect console to PC with USB cable.
4. Open a terminal in Windows or Linux and initiate a SSH session with command `ssh od@10.1.1.2` (the password is in [README>System access](https://github.com/eduardofilo/RG350_adam_image/#system-access)).
5. Untar the file copied in step 1 with this command: `sudo tar -xzf /media/sdcard/upgrade_1.4.1.tgz -C /` (same password than in step 4).
6. Reboot console.
