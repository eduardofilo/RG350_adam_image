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
















Disco /dev/loop24: 1000 MiB, 1048576000 bytes, 2048000 sectores
Unidades: sectores de 1 * 512 = 512 bytes
Tamaño de sector (lógico/físico): 512 bytes / 512 bytes
Tamaño de E/S (mínimo/óptimo): 512 bytes / 512 bytes
Tipo de etiqueta de disco: dos
Identificador del disco: 0x9d2e3dd2

Dispositivo   Inicio Comienzo   Final Sectores Tamaño Id Tipo
/dev/loop24p1              32  819199   819168   400M  b W95 FAT32
/dev/loop24p2          819200 6553599  5734400   2,7G 83 Linux




edumoreno@eduardo-HP-Folio-13:~/git/RG350_adam_image/auto_build$ sudo sfdisk -d sd_int.img
label: dos
label-id: 0x9d2e3dd2
device: sd_int.img
unit: sectors
sector-size: 512

sd_int.img1 : start=          32, size=      819168, type=b
sd_int.img2 : start=      819200, size=     5734400, type=83





sudo losetup -P /dev/loop24 sd_int.img

sudo mkfs.fat -F32 -v -l '/dev/loop24p1'
sudo mkfs.fat -F32 -v -l sd_int.img --offset=16384


mkfs.ext4 -F -O ^64bit -L '' '/dev/mmcblk0p2'


sudo mount -o loop,offset=16384,sizelimit=419414016 sd_int.img mnt_p1


sudo mount -o loop,offset=16384,sizelimit=419414016 /dev/loop24 mnt_p1



sudo dd if=/dev/zero of=/dev/mmcblk0 bs=2M status=progress

sudo dd of=/dev/mmcblk0 if=mbr bs=512 count=1


mkfs.fat -F32 -v -l '/dev/loop24p1'
mkfs.ext4 -F -O ^64bit -L '' '/dev/mmcblk0p2'

sudo mkfs.vfat -F 32 -v /dev/loop24p1
sudo mkfs.ext4 -F -O ^64bit -L '' /dev/loop24p2
sudo mkfs.ext4 -F -O ^64bit -O ^metadata_csum -O uninit_bg -L '' /dev/loop24p2



edumoreno@eduardo-HP-Folio-13:~/git/RG350_adam_image/auto_build$ sudo dumpe2fs /dev/mmcblk0p2 | fgrep features
dumpe2fs 1.46.3 (27-Jul-2021)
Filesystem features:      has_journal ext_attr resize_inode dir_index filetype extent flex_bg sparse_super large_file huge_file uninit_bg dir_nlink extra_isize
Journal features:         journal_incompat_revoke


edumoreno@eduardo-HP-Folio-13:~/git/RG350_adam_image/auto_build$ sudo dumpe2fs /dev/loop24p2 | fgrep features
dumpe2fs 1.46.3 (27-Jul-2021)
Filesystem features:      has_journal ext_attr resize_inode dir_index filetype extent 64bit flex_bg sparse_super large_file huge_file dir_nlink extra_isize metadata_csum
Journal features:         journal_64bit journal_checksum_v3


Sobran 64bit y metadata_csum y falta uninit_bg


gunzip adam_v1.5.img.gz -c | sudo dd of=/dev/mmcblk0 bs=2M status=progress conv=fsync
