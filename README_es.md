![vineyard leaf](images/alpha.svg)

# Imagen Adán

## Tabla de contenidos

- [Introducción](#introducción)
- [Procedimiento de instalación](#procedimiento-de-instalación)
    - [Windows](#windows)
    - [Linux](#linux)
    - [Cualquier sistema](#cualquier-sistema)
- [Instalación de contenidos](#instalación-de-contenidos)
    - [Formato y label de tarjeta externa](#formato-y-label-de-tarjeta-externa)
    - [ROMs](#roms)
    - [Previews](#previews)
    - [BIOS](#bios)
    - [Trucos](#trucos)
    - [Acceso al sistema](#acceso-al-sistema)
- [Controles](#controles)
- [Solución de problemas](#solución-de-problemas)
    - [Unsupported video mode](#unsupported-video-mode)
    - [Forzar cierre de RetroArch](#forzar-cierre-de-retroarch)
    - [Ajuste de emulador preferido](#ajuste-de-emulador-preferido)
- [FAQ](#faq)
- [Canal Telegram para comunicar actualizaciones](#canal-telegram-para-comunicar-actualizaciones)

## Introducción

Configuración de tarjeta interna (ranura INT) para consolas RG350, RG280, RG300X, PlayGo y PocketGo2. Resultado de un proyecto de colaboración del Team RParadise formado por:

* [Brumagix Gamer](https://www.youtube.com/channel/UCrdNisYjDd7qI1Zv2ZLwBrQ)
* [eduardófilo](https://apuntes.eduardofilo.es/)
* Juanmote (Juanma)
* [La Retro Cueva](https://www.youtube.com/channel/UCQm1VwD4sFoOUx6rq-at7jA)

La configuración está realizada en base a las siguientes piezas:

* [OpenDingux](http://od.abstraction.se/opendingux/latest/). Gracias principalmente a [pcercuei](https://github.com/pcercuei).
* [SimpleMenu](https://github.com/fgl82/simplemenu). Gracias a [FGL82](https://github.com/fgl82).
* [RetroArch](https://www.retroarch.com/?page=platforms). La combinación de Wrappers OPK se ha generado con el script [RG3550_auto_ra_installer](https://github.com/eduardofilo/RG350_auto_ra_installer) en base a [este fichero](https://github.com/eduardofilo/RG350_auto_ra_installer/blob/master/adam.csv).
    * [Oficial](https://buildbot.libretro.com/nightly/dingux/mips32/). Gracias principalmente a [jdgleaver](https://github.com/jdgleaver).
    * [Poligraf](https://github.com/Poligraf/opendingux_ra_cores_unofficial). Gracias a [Poligraf](https://github.com/Poligraf).
* Aplicaciones standalone:
    * [ColecoD](https://boards.dingoonity.org/gcw-releases/colecod-v1-0/). Gracias a [alekmaul](https://github.com/alekmaul).
    * [Daphne](https://github.com/DavidKnight247/Daphne). Gracias a [DavidKnight247](https://github.com/DavidKnight247).
    * [FBA](https://github.com/plrguez/fba-sdl/releases/latest). Gracias a [plrguez](https://github.com/plrguez).
    * [JzIntv](https://github.com/eduardofilo/jzIntv/releases). Gracias a [DavidKnight247](https://github.com/DavidKnight247).
    * [PCSX4All](https://github.com/jdgleaver/RG350_pcsx4all/releases/latest). Gracias a [jdgleaver](https://github.com/jdgleaver).
    * [PocketSNES](https://github.com/m45t3r/PocketSNES/releases/latest). Gracias a [m45t3r](https://github.com/m45t3r).
    * [ReGBA](https://github.com/jdgleaver/ReGBA/releases/latest). Gracias a [jdgleaver](https://github.com/jdgleaver).
    * [Tac08](https://0xcafed00d.itch.io/tac08-rg350). Gracias a [0xCAFED00D](https://itch.io/profile/0xcafed00d).
    * [VbEmu](https://gitlab.com/gameblabla/gameblabla-releases/-/blob/master/opk/gcw0/vbemu_gcw0.opk). Gracias a [gameblabla](https://gitlab.com/gameblabla).
    * [xMAME](http://www.slaanesh.net/). Gracias a [Slaanesh](https://www.blogger.com/profile/15791750842821351775). Instalado [este](https://github.com/eduardofilo/RG350_xmame_sm_bridge) interfaz de ajustes.
    * [Commander](https://github.com/od-contrib/commander/releases/latest). Gracias a [glebm](https://github.com/glebm).
    * [PyBackup](https://github.com/eduardofilo/RG350_py_backup/releases/latest)

## Procedimiento de instalación

1. Descargar la imagen del apartado [releases de este repositorio](https://github.com/eduardofilo/RG350_adam_image/releases/latest).
2. Sin necesidad de descomprimir, flashear el archivo (`img.gz`) con [Balena Etcher](https://www.balena.io/etcher/) sobre una tarjeta microSD de al menos 4GB.
3. Montar la microSD en un ordenador. Si la acabamos de flashear, dependiendo del sistema operativo, puede ser necesario extraerla del lector y volverla a insertar. En Windows se montará una de las dos particiones que contiene la tarjeta y la otra dará error. El error es normal dado que la segunda partición es de tipo Linux.
4. Colocar el kernel adecuado al modelo de nuestra consola. Esto puede hacerse de varias maneras en función del sistema operativo del PC.

#### Windows

1. Abrir el script `select_kernel.bat` que hay en la partición que se monta correctamente, haciendo doble clic sobre él.

    ![Win selector script](images/win_selector_script.png)

2. Aparecerá una consola donde tendremos que teclear el número correspondiente a nuestro modelo de consola del listado que veremos.

    ![Win selector script 2](images/win_selector_script2.png)

3. Pulsar Retorno y, cuando se nos indique, expulsar la tarjeta con seguridad.

    ![Win selector script 3](images/win_selector_script3.png)

#### Linux

1. Abrir un terminal y cambiar el directorio actual a la ruta correspondiente a la partición 1 de la tarjeta (podemos averiguar el punto de montaje en nuestro sistema con el comando `df`). Desde ese directorio ejecutar el comando `bash select_kernel.sh`.

    ![Linux selector script](images/linux_selector_script.png)

2. Aparecerá un diálogo que nos invitará a seleccionar nuestro modelo de consola con las teclas de cursor.

    ![Linux selector script 2](images/linux_selector_script2.png)

3. Pulsar Retorno y, cuando se nos indique, expulsar la tarjeta con seguridad.

    ![Linux selector script 3](images/linux_selector_script3.png)

#### Cualquier sistema

Hay un tercer método válido para cualquier sistema operativo (Windows, Linux, Mac). Se trata de visualizar con un explorador de archivos la partición 1 de la tarjeta y copiar manualmente los dos ficheros que hay dentro del directorio correspondiente a nuestro modelo de consola a la raíz de esa partición. Al ser una partición FAT32, no debería haber problema para acceder a los ficheros desde cualquier sistema. Hacer clic en la siguiente miniatura para ver un pequeño vídeo.

[![Ver vídeo](https://img.youtube.com/vi/CQSBWOTO2zc/hqdefault.jpg)](https://www.youtube.com/watch?v=CQSBWOTO2zc "Ver vídeo")

Al llegar a este punto, la tarjeta estará lista para funcionar sobre el modelo de consola que hayamos seleccionado en el procedimiento anterior. Si no lo hemos hecho ya, la expulsaremos con seguridad del PC e insertaremos en la ranura de la consola marcada como INT.

El procedimiento anterior se puede repetir para cambiar a otro modelo de consola en cualquier momento. Es decir, la imagen es compatible con los cuatro modelos de consola soportados por lo que una misma tarjeta nos servirá para varias máquinas.

La partición 2 contenida en el fichero de imagen, tiene unos 3,5GB (por eso se puede flashear sin problemas en tarjetas a partir de 4GB de capacidad). Durante el primer arranque, esta partición se expandirá hasta ocupar todo el espacio disponible en la tarjeta.

En la primera parte de este vídeo del compañero [Brumagix Gamer](https://www.youtube.com/channel/UCrdNisYjDd7qI1Zv2ZLwBrQ) podemos ver el proceso de instalación:

[![Ver vídeo](https://img.youtube.com/vi/NCfoqQ5-Ll8/hqdefault.jpg)](https://www.youtube.com/watch?v=NCfoqQ5-Ll8 "Ver vídeo")

## Instalación de contenidos

La tarjeta que acabamos de preparar está vacía de contenidos. Sólo contiene el sistema OpenDingux, el frontend SimpleMenu, los cores RetroArch y unos pocos emuladores independientes. Toda la configuración se ha hecho con la idea de que los contenidos sean aportados desde la tarjeta que colocaremos en la ranura marcada como EXT.

Antes de continuar, hacer un breve comentario sobre las consideraciones legales de la instalación de dichos contenidos. El asunto es complejo. Si se tiene interés en profundizar, un buen artículo es [este post de Retro Game Corps](https://retrogamecorps.com/2020/08/18/legal-guide-is-downloading-retro-game-files-roms-illegal/) (en inglés). Aunque existen pocos precedentes legales sobre el tema, el problema afecta fundamentalmente a las BIOS y las ROMs. De forma simplificada se suele considerar que podemos manejar las ROMs de los juegos y las BIOS de las máquinas que tengamos en propiedad. En realidad se trata más de una regla basada en el sentido común, ya que como decimos, existen pocas sentencias sobre el tema y desde luego la opinión de los distintos participantes en la industria no es consistente.

#### Formato y label de tarjeta externa

Para que todas las rutas preconfiguradas en la imagen funcionen, es necesario que la tarjeta microSD externa tenga formato FAT32 y **NO** tenga definida una etiqueta o label. En caso de tener label habrá que borrarlo.

En Windows podemos hacerlo desde el cuadro de Propiedades de la unidad en que se monta la tarjeta externa. Hacer clic en la siguiente miniatura para ver un pequeño vídeo.

[![Ver vídeo](https://img.youtube.com/vi/3uAMibsOvvk/hqdefault.jpg)](https://www.youtube.com/watch?v=3uAMibsOvvk "Ver vídeo")

En Linux se puede hacer ejecutando el siguiente comando desde un terminal (en el ejemplo se ha usado el dispositivo `/dev/mmcblk0p1`, pero habrá que sustituirlo por el que corresponda en nuestro caso):

```bash
sudo fatlabel /dev/mmcblk0p1 -r
```

Si tienes un Mac, echa un vistazo a los comentarios a la [issue #8](https://github.com/eduardofilo/RG350_adam_image/issues/8) de este repositorio. Allí se dan un par de soluciones, siendo la más sencilla utilizar la utilidad [SD Card Formatter tool](https://www.sdcard.org/downloads/formatter/sd-memory-card-formatter-for-mac-download/).

#### ROMs

El frontend SimpleMenu ha sido configurado con una serie de rutas predefinidas donde tratará de localizar las ROMs y previsualizaciones de las mismas. Dichas rutas serán creadas en la tarjeta EXT cada vez que arranque el sistema (si no existen). Este proceso sólo funcionará si como decíamos en el apartado anterior, el formato de la tarjeta es FAT32 y **NO** tiene label. Si no queremos modificar la configuración de SimpleMenu, habrá que atenerse a estas rutas. En la tabla que hay más abajo, se indica en la segunda columna el nombre del directorio que tendrá que existir en la tarjeta externa cuando la montamos en el PC. Por ejemplo en el pantallazo siguiente está señalado el directorio de ROMs del sistema Game Boy, que como vemos se encuentra junto a todos los demás dentro de la carpeta `roms` en la raíz de la tarjeta.

![SDcard paths](images/sdcard_paths.png)

La ruta anterior en el PC se corresponderá con `/media/sdcard/roms` en el sistema de la consola, una vez que la tarjeta se encuentre en la consola y el sistema se haya iniciado. En caso de modificar la configuración de SimpleMenu, o de abrir manualmente los emuladores desde GMenu2X, ésta será el tipo de ruta que usaremos (por ejemplo `/media/sdcard/roms/GB` para Game Boy).

A continuación se muestra la tabla de los sistemas configurados en SimpleMenu con las rutas donde deberemos situar las ROMs y las extensiones que éstas deben tener:

|Sistema|Rutas|Extensiones soportadas|
|:------|:-----------------|:---------------------|
|MAME|roms/ARCADE|zip, 7z|
|Capcom Play System|roms/CPS|zip, 7z|
|Final Burn Alpha|roms/FBA|zip|
|Daphne|roms/DAPHNE|zip|
|Nintendo NES|roms/FC|zip, nes, 7z|
|Nintendo SNES|roms/SFC|smc, sfc, zip, 7z|
|Nintendo Virtual Boy|roms/VB|vb, vboy, bin, zip, 7z|
|SEGA SG-1000|roms/SG1000|zip, sg, 7z|
|SEGA Master System|roms/SMS|zip, sms, 7z|
|SEGA Megadrive|roms/MD|zip, bin, smd, md, 7z|
|SEGA CD|roms/SEGACD|bin, chd, 7z, zip|
|SEGA 32X|roms/32X|zip, 32x, 7z|
|Atari 2600|roms/A2600|bin, a26, 7z, zip|
|Atari 5200|roms/A5200|bin, a52, 7z, zip|
|Atari 7800|roms/A7800|bin, a78, 7z, zip|
|Inteillivision|roms/INTELLI|int|
|ColecoVision|roms/COLECO|rom, col|
|SNK Neo Geo|roms/NEOGEO|zip, 7z|
|NEC PC Engine|roms/PCE|pce, tg16, cue, 7z, zip|
|NEC PC Engine CD|roms/PCECD|pce, tg16, cue, chd, 7z, zip|
|Sony PlayStation|roms/PS|mdf, zip, pbp, cue, bin, img, ccd, sub, chd|
|Nintendo Game Boy|roms/GB|gb, gz, zip, 7z|
|Nintendo Game Boy Color|roms/GBC|gbc, zip, 7z|
|Nintendo Game Boy Advance|roms/GBA|gba, zip, 7z|
|Nintendo Game&Watch|roms/GW|mgw, zip, 7z|
|SEGA Game Gear|roms/GG|zip, gg, 7z|
|Atari Lynx|roms/LYNX|zip, lnx, 7z|
|SNK Neo Geo Pocket|roms/NGP|ngp, ngc, 7z, zip|
|WonderSwan|roms/WSC|ws, wsc, zip, 7z|
|Pokemon Mini|roms/POKEMINI|min, zip, 7z|
|Watara Supervision|roms/SUPERVISION|sv, bin, 7z, zip|
|Sinclair ZX Spectrum|roms/ZX|tzx, tap, z80, rzx, scl, trd, dsk, zip, 7z|
|Amstrad CPC|roms/AMSTRAD|dsk, sna, tap, cdt, voc, cpr, m3u, zip, 7z|
|Commodore 64|roms/C64|crt, d64, t64, bin, 7z, zip|
|MSX|roms/MSX|rom, ri, mx1, mx2, col, dsk, cas, sg, sc, m3u, zip, 7z|
|Commodore Amiga|roms/AMIGA|adf, adz, dms, fdi, ipf, hdf, hdz, lha, slave, info, cue, ccd, nrg, mds, iso, chd, uae, m3u, zip, 7z|
|Doom|roms/DOOM/DOOM, roms/DOOM/DOOM2|wad, zip, 7z|
|Quake|roms/QUAKE|pak, zip, 7z|
|MS-DOS|roms/DOSBOX|zip, dosz, exe, com, bat, iso, cue, ins, img, ima, vhd, m3u, m3u8, 7z|
|ScummVM|roms/SCUMMVM|*|
|Pico8|roms/PICO8|png|
|TIC80|roms/TIC80|tic, 7z, zip|

#### Previews

Las previews deberán colocarse en un directorio de nombre `.previews` dentro de cada uno de los directorios de ROMs del listado anterior. Por ejemplo las previews de las ROMs de GB deberán situarse en `roms/GB/.previews` siendo esta la ruta desde la raíz de la tarjeta externa cuando la montamos en el PC. Los ficheros de preview tienen que ser PNGs con el mismo nombre del juego (excepto la extensión).

![Previews path 1](images/previews_path1.png)

![Previews path 2](images/previews_path2.png)

Si hemos respetado las rutas indicadas anteriormente, más tarde en SimpleMenu el juego se representará de la siguiente forma:

![Previews path 3](images/previews_path3.png)

#### BIOS

Todos los emuladores instalados en la imagen (RetroArch incluido) tienen redirigidas las rutas donde deben estar las BIOS al directorio `bios` en la tarjeta externa. De forma similar al caso de las ROMs, el directorio `bios` en la raíz de la tarjeta externa, se corresponderá con la ruta `/media/sdcard/bios` en el sistema de la consola.

No todos los emuladores necesitan BIOS. Es el caso de las máquinas que no la tenían o cuya función se ha podido emular. A continuación se indica el fichero de BIOS que habrá que localizar así como el lugar donde lo deberemos colocar. Para ayudar a identificar los ficheros correctos, se indica en caso de conocerlo su tamaño en bytes y un hash MD5. Se marcan también los casos en que la BIOS es imprescindible para que funcione el emulador. En caso de indicarse que `NO`, el emulador funcionará, pero se recomienda instalarla de cara a conseguir la mayor compatibilidad de los juegos. Para comprobar los hashes MD5 se recomienda la utilidad multiplataforma [Quickhash](https://www.quickhash-gui.org/).

Los tamaños y hashes indicados son de BIOS que se han comprobado funcionales, pero no necesariamente las únicas posibles. Es decir, en algunas máquinas existen varias versiones de BIOS posibles, normalmente por haber existido varios modelos de las máquinas (siendo el caso de la PlayStation uno de los más típicos), o por haber desarrollado alguien BIOS con capacidades mejoradas (aquí el caso típico es el de Neo Geo y su UNIBIOS).

|Sistema|Ruta|Tamaño|Hash MD5|¿Necesaria?|
|:------|:---|-----:|:-------|:----------|
|Atari 5200|bios/5200.rom|2048|`281f20ea4320404ec820fb7ec0693b38`|Sí|
|Atari 7800|bios/7800 BIOS (U).rom| |`0763f1ffb006ddbe32e52d497ee848ae`|No|
|SEGACD|bios/bios_CD_E.bin|131072|`e66fa1dc5820d254611fdcdba0662372`|Sí|
|SEGACD|bios/bios_CD_J.bin|131072|`278a9397d192149e84e820ac621a8edd`|Sí|
|SEGACD|bios/bios_CD_U.bin|131072|`854b9150240a198070150e4566ae1290`|Sí|
|Intellivision|bios/exec.bin|8192|`62e761035cb657903761800f4437b8af`|Sí|
|Intellivision|bios/grom.bin|2048|`0cd5946c6473e42e8e4c2137785e427f`|Sí|
|PC Engine CD|bios/syscard3.pce|262144|`390815d3d1a184a9e73adc91ba55f2bb`|Sí|
|Commodore Amiga|bios/kick34005.A500|262144|`82a21c1890cae844b3df741f2762d48d`|Sí para Amiga 500|
|Commodore Amiga|bios/kick37175.A500|524288|`dc10d7bdd1b6f450773dfb558477c230`|Sí para Amiga 500+|
|Commodore Amiga|bios/kick40063.A600|524288|`e40a5dfb3d017ba8779faba30cbd1c8e`|Sí para Amiga 600|
|Commodore Amiga|bios/kick40068.A1200|524288|`646773759326fbac3b2311fd8c8793ee`|Sí para Amiga 1200|
|Commodore Amiga|bios/kick40060.CD32|524288|`5f8924d013dd57a89cf349f4cdedc6b1`|No|
|Commodore Amiga|bios/kick40060.CD32.ext|524288|`bb72565701b1b6faece07d68ea5da639`|No|
|Atari Lynx|bios/lynxboot.img|512|`fcd403db69f54290b51035d82f835e7b`|Sí|
|Phillips Videopac|bios/o2rom.bin|1024|`562d5ebf9e030a40d6fabfc2f33139fd`|Sí|
|SNK Neo Geo|bios/neogeo.zip|1950023|`36241192dae2823eaf3bf464dde6dbc6`|Sí en FBA, No en RetroArch|
|Nintendo GBA|bios/gba_bios.bin|16384|`a860e8c0b6d573d191e4ec7db1b1e4f6`|No, aunque recomendable|
|PlayStation|bios/SCPH1001.BIN|524288|`924e392ed05558ffdb115408c263dccf`|No, aunque muy recomendable|
|Nintendo GB|bios/gb_bios.bin|256|`32fbbd84168d3482956eb3c5051637f5`|No|
|Nintendo GBC|bios/gbc_bios.bin|2304|`dbfce9db9deaa2567f6a84fde55f9680`|No|
|Pokemon Mini|bios/bios.min|4096|`1e4fb124a3a886865acb574f388c803d`|Sí|
|MSX (BlueMSX)|bios/Machines/| | |Sí|
|MSX (fMSX)|bios/MSX.ROM|32768|`364a1a579fe5cb8dba54519bcfcdac0d`|Sí para MSX|
|MSX (fMSX)|bios/MSX2.ROM| |`ec3a01c91f24fbddcbcab0ad301bc9ef`|Sí para MSX2|
|MSX (fMSX)|bios/MSX2EXT.ROM| |`2183c2aff17cf4297bdb496de78c2e8a`|Sí para MSX2|
|MSX (fMSX)|bios/MSX2P.ROM|32768|`847cc025ffae665487940ff2639540e5`|Sí para MSX2+|
|MSX (fMSX)|bios/MSX2PEXT.ROM|16384|`7c8243c71d8f143b2531f01afa6a05dc`|Sí para MSX2+|

#### Trucos

RetroArch lleva integrado un sistema de trucos en base a una serie de ficheros que se pueden obtener de [este repositorio](https://github.com/libretro/libretro-database/tree/master/cht). En la imagen, el directorio donde tenemos que colocar los ficheros, se ha redirigido a la tarjeta externa, al igual que con las ROMs y BIOS. En concreto al directorio `cheats` de la raíz de la tarjeta externa.

Vamos a detallar el proceso utilizando como ejemplo el juego `Adventure Island` de Game Boy:

1. Buscaremos el fichero correspondiente en el [repositorio](https://github.com/libretro/libretro-database/tree/master/cht). En concreto para este juego el fichero es [éste](https://github.com/libretro/libretro-database/blob/master/cht/Nintendo%20-%20Game%20Boy/Adventure%20Island%20(USA%2C%20Europe).cht).
2. Lo copiaremos al directorio `cheats` en la raíz de la tarjeta EXT. En realidad lo más lógico es copiar colecciones completas de sistemas manteniendo la estructura de directorios que vemos en el repositorio.
3. Una vez arrancada la consola con la tarjeta EXT en su lugar, abriremos el juego con RetroArch.
4. Accedemos al menú de RetroArch (`Select + X` o `Power`).
5. Seguimos la ruta: `Quick Menu > Cheats > Load Cheat File (Replace)`.
6. Aparecerá un explorador de archivos que mostrará el contenido de la carpeta `cheats` de la tarjeta EXT. Localizamos el fichero correspondiente al juego y lo seleccionamos.

    ![Cheats 1](images/cheats1.png)

7. Volveremos a la pantalla de Cheats donde veremos que la parte inferior se ha cargado con los trucos. Allí podremos ajustar los que deseemos (el ajuste rápido se hace con las teclas izquierda/derecha de la cruceta).
8. Finalmente aplicamos con `Apply Changes`.

    ![Cheats 2](images/cheats2.png)

9. Si queremos que los ajustes de trucos que hemos hecho se apliquen entre distintas sesiones de juego, tendremos que hacer un override para el juego.

Instrucciones obtenidas de [esta guía](https://retrogamecorps.com/2020/12/24/guide-retroarch-on-rg350-and-rg280-devices/#Cheats) de Retro Game Corps.

PCSX4All también soporta un sistema de trucos. Al igual que en RetroArch, el directorio donde tenemos que colocar los ficheros, se ha redirigido a la tarjeta externa. En concreto al directorio `cheats/PlayStation` de la raíz de la tarjeta externa. Hay que tener en cuenta que los trucos para PCSX4All no tienen el mismo formato que los que hay para `Sony - PlayStation` en el repositorio que hemos indicado antes para obtener trucos para RetroArch.

#### Acceso al sistema

Una vez que la tarjeta con el sistema (INT) y con los contenidos (EXT) han sido insertadas en sus correspondientes ranuras, y la consola encendida, podemos acceder al sistema por SSH para hacer algunas personalizaciones que requieren este tipo de acceso (como editar los ficheros de configuración de SimpleMenu o Py Backup). Para lograr el acceso por SSH conectaremos la consola con un cable USB tipo C al ordenador utilizando el mismo conector que se utiliza para cargar (es decir el marcado con DC). En el caso de Windows puede ser necesario instalar [drivers](https://github.com/SeongGino/RetroGame350-AppRepo/blob/master/RG350-signed_driver.zip). En el ordenador podemos utilizar cualquier cliente de FTP configurado con el protocolo SFTP o SCP (por ejemplo WinSCP o Filezilla). El acceso a través del protocolo SSH normal puede lograrse desde una simple consola o terminal ya sea en Windows o Linux, tecleando el siguiente comando:

```
ssh od@10.1.1.2
```

Por defecto el acceso SSH está configurado sin password.

![Network access 1](images/network_access1.png)

Por defecto la imagen está configurada para hacer uso de este acceso SSH en modo RNDIS por medio del cable USB, aunque a través de la aplicación `USB Mode` que hay en la sección `settings` de GMenu2X (habrá por tanto que desactivar SimpleMenu como lanzador predeterminado momentáneamente), podemos cambiar al modo `Mass Storage` o MTP.

![Network access 2](images/network_access2.png)
![Network access 3](images/network_access3.png)

## Controles

A continuación se listan algunas combinaciones de teclas o atajos interesantes que pueden utilizarse con el sistema OpenDingux, SimpleMenu, RetroArch y los emuladores standalone.

|Situación|Atajo de teclado|Efecto|
|:--------|:---------------|:-----|
|OpenDingux|POWER + START + SELECT|Reinicio del sistema|
|OpenDingux|POWER + UP|Subir volumen sonido|
|OpenDingux|POWER + DOWN|Bajar volumen sonido|
|OpenDingux|POWER + RIGHT|Subir brillo pantalla|
|OpenDingux|POWER + LEFT|Bajar brillo pantalla|
|OpenDingux|POWER + B|Activa/desactiva el modo ratónmouse mode (anteriormente POWER + L1)|
|OpenDingux|POWER + A|Modo de relación de aspecto en el escalado por hardware|
|OpenDingux|POWER + SELECT|Forzar cierre de aplicación actual|
|OpenDingux|POWER + Y|Suspender sistema (pulsar POWER para despertar)|
|OpenDingux|POWER + X|Captura de pantalla (en `~/screenshots`)|
|OpenDingux|A (durante el arranque)|Muestra la salida de los scripts de arranque en lugar del logo de boot|
|SimpleMenu|Start|Abre la pantalla de ajustes|
|SimpleMenu|Select|Opciones de ROM. Permite seleccionar autoarranque, emulador (si se han definido varios en el sistema) y overclocking|
|SimpleMenu|Up|Seleccionar juego/sección/grupo anterior|
|SimpleMenu|Down|Seleccionar juego/sección/grupo siguiente|
|SimpleMenu|Left|Salta a la página siguiente de la sección actual|
|SimpleMenu|Right|Salta a la página anterior de la sección actual|
|SimpleMenu|R1|Alterna entre la lista de juegos o el modo pantalla completa|
|SimpleMenu|R2|Refresca la lista de juegos del sisema actual (en caso de haber añadido juegos nuevos con el frontend en ejecución)|
|SimpleMenu|A|Abre el juego o aplicación seleccionado|
|SimpleMenu|X|En los listados de juegos, marca el seleccionado como favorito; en la vista de Favoritos borra el juego de la lista|
|SimpleMenu|Y|Abre la selección de Favoritos|
|SimpleMenu|B|En pulsación corta vuelve atrás; en pulsación larga permite las siguientes combinaciones de teclas|
|SimpleMenu|B + Left|Desplaza el listado de juegos a la letra anterior|
|SimpleMenu|B + Right|Desplaza el listado de juegos a la letra siguiente|
|SimpleMenu|B + Up|Cambia al sistema anterior sin mostrar el logo|
|SimpleMenu|B + Down|Cambia al sistema siguiente sin mostrar el logo|
|SimpleMenu|B + Select|Abre un juego aleatorio del sistema actual|
|SimpleMenu|B + X|Borra el juego actual **SIN PEDIR CONFIRMACIÓN**; no funciona en las secciines Favoritos, Apps o Games|
|SimpleMenu|B + A|Lanza el emulador sin pasar un juego como parámetro, si el emulador soporta ser abierto de manera independiente (por ejemplo con FBA permite abrir la interfaz UX)|
|RetroArch|Select + A|Pausa|
|RetroArch|Select + B|Reset|
|RetroArch|Select + X o Power|Menú RetroArch|
|RetroArch|Select + Y|Avance rápido|
|RetroArch|Select + R1|Guardar savestate|
|RetroArch|Select + L1|Cargar savestate|
|RetroArch|Select + R2|Cambiar disco|
|RetroArch|Select + L2|Abrir bandeja CD|
|RetroArch|Select + Start|Cerrar juego|
|RetroArch|Select + Left/Right|Cambiar slot savestate|
|RetroArch|Select + Up/Down|Cambiar volumen|
|RetroArch/Neo Geo FBA|A + B + Y|Entrar en ajustes UniBIOS|
|FBA (MAME, FBA y CPS)|L1 + R1 + Start o Power|Abre el menú del emulador que nos permite salir|
|FBA (MAME, FBA y CPS)|L1 + R1 + Y|Mostrar/ocultar el contador FPS|
|xMAME|Select + L1 + R1|Salir del juego|
|xMAME|Start + R1|Mostrar/ocultar el contador FPS|
|Daphne|L1|Insertar moneda|
|Daphne|Start|Comenzar juego|
|Daphne|Select|Salir del juego|
|PocketSNES (SNES)|Power|Abre el menú del emulador que nos permite salir|
|ReGBA (GBA)|Power o Select + Start|Abre el menú del emulador que nos permite salir|
|PCSX4All (PlayStation)|Power o Select + Start|Abre el menú del emulador que nos permite salir|
|JzIntv|Select|Abre el menú del emulador que nos permite salir|
|JzIntv|Power|Cierra el emulador|
|JzIntv|R1|Controlador virtual|
|JzIntv|L1|Teclado virtual|
|ColecoD (ColecoVision)|Select + Start|Abre el menú del emulador que nos permite salir|
|Tac08 (PICO8)|Start|Abre el menú del emulador que nos permite salir|
|Fuse (ZX Spectrum)|Select|Teclado virtual|
|Cap32 (AMSTRAD CPC)|Y + Start|Teclado virtual. Una vez desplegado abrir/cerrar el menú de RA (Select + X) para que empiece a funcionar el stick izquierdo como ratón|
|Vice 64 (Commodore 64)|Select|Teclado virtual|
|PUAE (Commodores Amiga)|L1|Teclado virtual|

## Solución de problemas

#### Unsupported video mode

Algunos cores de RetroArch muestran la siguiente pantalla de error al trabajar en resoluciones no soportadas por el sistema:

![Unsupported video mode 1](images/unsupported_video1.png)

En este caso proceder como sigue:

1. Abrir menú RetroArch (`Select + X`).
2. Ir a `Main Menu > Settings > Video > Scaling` y marcar las opciones `Integer Scale` y `Keep Aspect Ratio`.

    ![Unsupported video mode 2](images/unsupported_video2.png)

3. Ir a `Main Menu > Settings > Video > Video Filter` y seleccionar el filtro `Upscale_256x-320x240.filt` (el último de la lista):

    ![Unsupported video mode 3](images/unsupported_video3.png)

Por último, si no se quiere hacer este cambio cada vez que se abra el juego, ir a `Main Menu > Quick Menu > Overrides` y seleccionar `Save Game Overrides`.

Otro filtro que suele dar buen resultado en estas situaciones es `LQ2x`.

#### Forzar cierre de RetroArch

En ocasiones, al tratar de salir de RetroArch, éste se queda colgado y no retorna al frontend. En esos casos forzar el cierre de la aplicación en primer plano (RetroArch en ese momento) pulsando la combinación de teclas `Power + Select`. Es importante pulsar las teclas en ese orden, es decir, pulsar un poco antes `Power` y sin soltarlo pulsar entonces `Select`. Esta combinación de teclas tampoco funciona siempre. En ese caso mantener la tecla `Power` unos segundos para provocar un apagado controlado de la consola.

En resumen, los métodos para cerrar un juego en RetroArch son:

1. `Start + Select` o `Quit RetroArch` desde el menú de RA.
2. Si lo anterior no funciona, `Power + Select`.
3. Si lo anterior no funciona, mantener `Power` unos segundos hasta que el sistema se apague.

Hay que evitar pulsar `Reset` ya que se ha encontrado con bastante frecuencia que provoca la corrupción de la SD.

#### Ajuste de emulador preferido

En la configuración hecha de SimpleMenu, muchos de los sistemas ofrecen varias opciones de emulación, es decir se puede elegir entre varios emuladores o cores RetroArch. Además el ajuste del emulador o core RA preferido se puede guardar para cada juego.

En los sistemas sencillos de emular, como las máquinas de 8 bit, sólo se ha ofrecido RetroArch, por considerarlo la mejor opción. Pero en sistemas más complejos, como los sistemas arcade, la oferta de emuladores es amplia. Por ejemplo en MAME se dispone de las siguientes opciones:

* Core RetroArch MAME2003
* Core RetroArch MAME2003+
* FBA
* xMAME romset 84
* xMAME romset 69
* xMAME romset 52

Las opciones de emulación aparecen en este orden en el listado, tratándose la primera como opción predeterminada en caso de no indicar manualmente un emulador para un juego concreto. Por tanto, si no se cambia, la opción predeterminada para ejecutar los juegos del sistema MAME será el core MAME2003 de RetroArch.

Si un juego en concreto no funciona con el emulador predeterminado, pulsaremos `Select` en el listado de juegos de SimpleMenu. Aparecerá un selector con tres opciones, siendo la del emulador a utilizar la tercera. Nos desplazaremos hasta esta tercera opción y cambiaremos el emulador pulsando izquierda/derecha en la cruceta. Para guardar el cambio pulsaremos `Select` de nuevo. Al abrir el juego pulsando `A` se lanzará el core que hayamos elegido. Si el nuevo emulador tampoco funciona correctamente, probar con otra opción hasta obtener un rendimiento adecuado.

![Core selection](images/core_selection.gif)

Otra situación en las que nos conviene cambiar es cuando el juego se ejecuta lento. Además del sonido entrecortado, la mejor forma de medir si el juego se mueve con soltura es activar el contador de frames por segundo o FPS. En RetroArch podemos activar la opción para un juego en particular en el menú `Main Menu > Settings > On-Screen Display > On-Screen Notifications > Notification Visibility > Display Framerate`, pero si queremos activarlo en general, antes hay que cerrar el contenido que estemos ejecutando. Este sería el procedimiento descrito en detalle.

1. Lanzamos un juego que se ejecute con RetroArch (por ejemplo todos los sistemas tipo Handheld están configurados con RetroArch por defecto).
2. Abrimos el menú de RetroArch pulsando `Select + X`.
3. Seleccionar el menú `Close Content`.
4. Seguir el siguiente camino en los menús: `Main Menu > Settings > On-Screen Display > On-Screen Notifications > Notification Visibility`.
5. Activar la opción `Display Framerate`.
6. Volver hasta el menú raíz pulsando `B` repetidas veces.
7. Entrar en el menú `Configuration File`.
8. Ejecutar el comando de menú `Save Current Configuration`.
9. Volver hasta el menú raíz pulsando `B` una vez.
10. Ejecutar el comando de menú `Quit RetroArch`.

Para desactivarlo procederemos de la misma forma pero desactivando la opción del paso 5.

En xMAME la opción FPS se activa/desactiva en cualquier momento pulsando `Start + R1`. En FBA la combinación es `L1 + R1 + Y`.

## FAQ

**Q: ¿Tengo que volver a flashear con cada nueva imagen? ¿No existe un OPK para una actualización más ágil?**

A: Lo siento. Por ahora el flasheo es el único medio disponible. En el pasado, con otra imagen, publiqué un OPK para hacer las actualizaciones, pero hubo muchos problemas con las personalizaciones que los usuarios hacían que afectaba al sistema de aplicación de los parches. Puedes usar [Py Backup](https://github.com/eduardofilo/RG350_py_backup#usage) para transferir savestates y configuraciones entre la instalación vieja y la nueva.

**Q: ¿Hay algún indicador del nivel de batería?**

A: Desde la versión v1.1, SimpleMenu muestra el nivel de batería en algunos themes (0A and SimUI). También se muestra un indicador de batería cuando se está ejecutando RetroArch y se entra en el menú (`Power` or `Select + X`). Por último, se puede salir a GMenu2X desde SimpleMenu cambiando la opción `Default launcher` a `no` y seleccionando después `Session: quit`.

## Canal Telegram para comunicar actualizaciones

Se ha creado este canal de Telegram para comunicar más fácilmente las actualizaciones de esta imagen: https://t.me/adam_image
