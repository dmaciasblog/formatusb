#!/bin/sh
#
#   +-----------------------------------------+
#   |    Script para formatear dispositivos   |
#   |         USB de forma mas segura         |
#   |   by D. Macias <diego@dmaciasblog.com>  |
#   |       https://www.dmaciasblog.com       |
#   +-----------------------------------------+

### FUNCION COMPROBAR DISCOS
    #listamos los dispositivos y anulamos los Hotplug 0 antes de
    #cada operacion importante
function comprobar() {
    if [[ $(lsblk -d -o HOTPLUG /dev/$disp | grep -w 1) -ne 1 ]]; then
        echo
        echo -e "\tLA UNIDAD $disp NO ES USB"
        echo
        tecla
        basica
    fi
}

### FUNCION DETECTAR USB
function detectar() {
    lsblk -d -o HOTPLUG,MODEL,NAME,SIZE,LABEL | grep -w 1 > /tmp/partition.txt

    ### COMPROBAMOS SI HAY USB CONECTADOS
    if [[ -s /tmp/partition.txt ]]; then
        echo
        echo -e "\t\t\t NAME"
        echo -e "-------------------------------------------"
        cat /tmp/partition.txt
        echo
    else
        echo "Dispositivo usb no encontrado"
        tecla
        menu_principal
    fi

}
### FUNCION TECLA
function tecla() {
    echo -n "Presione una tecla para volver al menu..."
    read foo;
}


### FUNCION BASICA
function basica() {
    clear
    detectar
    lsblk -o model,name,size,tran | grep -A 5 usb
    echo
    echo -n -e "\tSeleccione dispositivo (sda, sdb, sdc, etc...): "
    read disp
    echo
    comprobar
    echo -n -e "\tSeleccione particion (1, 2, 3, etc...): "
    read part
    echo
    formato
    echo
    echo -n -e "\tNombre de la particion: "
    read label
    label=$(echo $label | tr '[:lower:]' '[:upper:]')

    if [[ $(ls /dev | grep -c $disp$part) = "1" ]]; then
        echo
        echo -e "\tVas a formatear $disp$part en $f con nombre $label "
        echo -n -e "\tDesea realizar los cambios (S/N): "
        read cambios
        case $cambios in
                s|S)
                sudo umount -v /dev/$disp$part
                if [[ $format = 'mkfs.vfat -F32' ]]; then
                    sudo $format -n $label /dev/$disp$part
                    echo
                    echo -e "\tOperacion realizada con exito"
                else
                    sudo $format /dev/$disp$part -L $label
                    echo
                    echo -e "\tOperacion realizada con exito"
                fi
                tecla
                menu_principal
                ;;
                n|N)
                echo -e "\tOperacion cancelada...."
                tecla
                menu_principal
                ;;
                *)
                echo -e "\tOpcion no valida"
                tecla
                basica
                ;;
        esac

    else
        echo "la particion no existe"
        tecla
        basica
    fi

}

###FUNCION MENU FORMATO
function formato() {
    echo
    echo -e "\tSeleccione formato"
    echo
    echo -e "\t\t1.\tFAT32"
    echo -e "\t\t2.\tNTFS"
    echo -e "\t\t3.\tExt3"
    echo -e "\t\t4.\tExt4"
    echo -n -e "\t Formato: "
    read n
    case $n in
            1)
            format='mkfs.vfat -F32'
            f='FAT32'
            ;;
            2)
            format='mkfs.ntfs'
            f='NTFS'
            ;;
            3)
            format='mkfs.ext3'
            f='EXT3'
            ;;
            4)
            format='mkfs.ext4'
            f='EXT4'
            ;;
            *)
            echo -e "\tOpcion no valida...."
            sleep 1
            formato
            ;;

    esac
}

### FUNCION AVANZADA
function avanzada() {
    clear
    detectar
    echo -e -n "Seleciona dispositivo (p.e. sdb, sdc, sdd, etc...): "
    read dispo
    comprobar
    filtro=$(grep -c $dispo /tmp/partition.txt)
    if [[ $filtro = "1" ]]; then
        sudo cfdisk /dev/$dispo
        tecla
        menu_principal
    else
        echo -e "\tDispositivo no encontrado"
        sleep 1
        tecla
        avanzada
    fi
}
#### MENU PRINCIPAL
function menu_principal() {
    clear
    echo
    echo
    echo -e "\t+-----------------------+"
    echo -e "\t|      FORMAT  USB      |"
    echo -e "\t|=======================|"
    echo -e "\t|  www.dmaciasblog.com  |"
    echo -e "\t| diego@dmaciasblog.com |"
    echo -e "\t+-----------------------+"
    echo
    echo
    echo -e "\t\t1.\tModo basico"
    echo -e "\t\t2.\tModo avanzado"
    echo -e "\t\t3.\tSalir"
    echo
    echo -e -n "\tSeleciona una opcion: "
    read opcion

    case $opcion in
            1 )
                basica
            ;;
            2 )
                avanzada
            ;;
            3 )
                echo "Saliendo..............."
                sleep 2
                clear && exit
            ;;
            * )
                echo -e "\tOpcion no valida"
                tecla
                menu_principal
            ;;
    esac
}
menu_principal
