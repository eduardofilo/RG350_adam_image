![alpha](images/alpha.svg)

# Imagen Adán

La imagen Adán es una compilación de software para la tarjeta microSD interna de una serie de consolas portátiles de emulación basadas en el chip Ingenic JZ4770. Concretamente GCW-Zero, PocketGo2 v1/v2, Anbernic RG350, RG280 y RG300X.

Si sólo te interesa utilizar una de las imágenes publicadas en las [releases](/eduardofilo/RG350_adam_image/releases), consulta la documentación en el [wiki](/eduardofilo/RG350_adam_image/wiki).

Si quieres construir la imagen desde sus fuentes, el procedimiento básico es el siguiente:

1. Descargar el repositorio con sus submódulos (IMPORTANTE: no olvidar la opción `--recursive`):

    ```
    git clone --recursive https://github.com/eduardofilo/RG350_adam_image.git
    ```

2. Modificar los parámetros que hay al principio del script de compilación de la imagen según conveniencia:

    ```
    ODBETA_VERSION=2022-02-13   # Versión de ODbeta a instalar (ver http://od.abstraction.se/opendingux/latest/)
    MAKE_PGv1=true              # Construir imagen para GCW-Zero y PocketGo2 v1 (true/false)
    MAKE_RG=true                # Construir imagen para RG350 y derivadas (true/false)
    COMP=gz                     # Formato de compresión: gz or xz
    P1_SIZE_SECTOR=819168       # Tamaño de la partición 1 en sectores (819168 sectores= ~400M)
    SIZE_M=3200                 # Tamaño final de la imagen en MiB
    ```

3. Modificar el contenido del directorio `data` si se quieren hacer cambios a los contenidos de la partición 2 de la tarjeta INT.
4. Compilar la imagen (el valor `1.5` que se indica a continuación como ejemplo corresponde a la versión de la imagen generada):

    ```
    cd RG350_adam_image/auto_build
    ./build.sh 1.5
    ```

5. La imagen construida, lista para flashear se encontrará en el directorio `releases`.

## Canal Telegram para comunicar actualizaciones

Se ha creado este canal de Telegram para comunicar más fácilmente las actualizaciones de esta imagen: https://t.me/adam_image
