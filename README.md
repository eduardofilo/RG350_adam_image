![alpha](images/alpha.svg)

# Adam image

Adam image is a software compilation for the internal microSD card slot of a series of Ingenic JZ4770 chip-based portable emulation consoles. Specifically GCW-Zero, PocketGo2 v1/v2, Anbernic RG350, RG280 and RG300X.

If you only want to use one of the images published in [releases](/eduardofilo/RG350_adam_image/releases), see the documentation on the [wiki](/eduardofilo/RG350_adam_image/wiki).

If you want to build the image from its sources, the basic procedure is as follows:

1. Download repository with submodules (IMPORTANT: don't forget the `--recursive` option):

    ```
    git clone --recursive https://github.com/eduardofilo/RG350_adam_image.git
    ```

2. Modify the parameters provided at the beginning of the building script as appropriate:

    ```
    ODBETA_VERSION=2022-02-13   # ODbeta version to install (check http://od.abstraction.se/opendingux/latest/)
    MAKE_PGv1=true              # Build image for GCW-Zero and PocketGo2 v1 (true/false)
    MAKE_RG=true                # Build image for RG350 and derived (true/false)
    COMP=gz                     # Compression format: gz or xz
    P1_SIZE_SECTOR=819168       # Size of partition 1 in sectors (819168 sectors= ~400M)
    SIZE_M=3200                 # Final image size in MiB
    ```

3. Modify the contents of the `data` directory if you want to make any changes to the contents of partition 2 on the INT card.
4. Build the image (the value `1.5` given below as an example corresponds to the version of the generated image):

    ```
    cd RG350_adam_image/auto_build
    ./build.sh 1.5
    ```

5. You will find the image dump ready to flash in the `releases` directory.

## Telegram channel for updates

Join this Telegram channel to get update notifications: https://t.me/adam_image
