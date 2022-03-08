# Links

* https://en.wikipedia.org/wiki/Loop_device
* http://apuntes.eduardofilo.es/sistemas/unix.html#montar-un-fichero-img


# Image file creation

```
$ dd if=/dev/zero of=sd_int.img bs=1M count=3200 status=progress
```

# loop dev association

`sudo losetup -f` return first free loop dev.

```
$ DEVICE=$(losetup -f)
$ sudo losetup $DEVICE sd_int.img
```

# mbr load

```
$ sudo dd of=$DEVICE if=mbr bs=512 count=1
```

# Filesystem creation

@@@@ SEGUIR



# Detach de dispositivo loop

$ sudo losetup -d $DEVICE















mkdir ~/sd_int
mount -o loop sd_int.img ~/sd_int



edumoreno@eduardo-HP-Folio-13:/sys/block$ sudo fdisk -l /dev/mmcblk0
Disco /dev/mmcblk0: 7,5 GiB, 8053063680 bytes, 15728640 sectores
Unidades: sectores de 1 * 512 = 512 bytes
Tamaño de sector (lógico/físico): 512 bytes / 512 bytes
Tamaño de E/S (mínimo/óptimo): 512 bytes / 512 bytes
Tipo de etiqueta de disco: dos
Identificador del disco: 0x9d2e3dd2

Dispositivo    Inicio Comienzo   Final Sectores Tamaño Id Tipo
/dev/mmcblk0p1              32  819199   819168   400M  b W95 FAT32
/dev/mmcblk0p2          819200 6553599  5734400   2,7G 83 Linux


# Dump MBR

sudo dd if=/dev/mmcblk0 of=mbr bs=512 count=1
