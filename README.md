# formatusb

## Descripcion
Programa para formatear dispositivos usb desde la terminal Linux
de forma mas segura

## Dependencias
Son necesarios los siguientes paquetes para que el script funcione (al menos en el caso de ArchLinux)
**dosfstool**
**ntfs-3g**

## Instalacion

```
sudo cp formatusb.sh /usr/local/bin/
```
```
sudo chmod +x /usr/local/bin/formatusb.sh
```

## Caracteristicas
Con **formatusb** podrás formatear dispositivos usb sin miedo
a equivocarte y formatear una unidad interna.
En el modo básico solo he puesto los formatos mas usados:
    FAT32
    NTFS
    ext3
    ext4
El modo avanzado nos lleva a cfdisk para trabajar con el dispositivo.

## Estado
En desarrollo.

## Creditos
Script creado por Diego Macias de [dmaciasblog.com](https://www.dmaciasblog.com)
