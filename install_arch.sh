#!/bin/bash

# Script de instalación de dwm, slstatus y slock en Arch Linux
# Incluye todas las dependencias necesarias y programas adicionales

# Mostrar mensaje de bienvenida
echo "==================================================================="
echo "     Instalación de dwm, slstatus y slock en Arch Linux"
echo "==================================================================="
echo "Este script instalará todas las dependencias necesarias y programas"
echo "adicionales para tener un entorno dwm funcional."
echo "Se instalarán: Xorg, componentes de desarrollo, dunst, rofi,"
echo "pamixer, picom y otras utilidades."
echo "==================================================================="
echo ""

# Verificar si se está ejecutando como root
if [ "$EUID" -ne 0 ]; then
  echo "Por favor, ejecuta este script como root (usa sudo)."
  exit 1
fi

# Obtener el nombre del usuario real (que ejecutó sudo)
if [ -n "$SUDO_USER" ]; then
  REAL_USER="$SUDO_USER"
else
  # Solicitar nombre de usuario si no se detecta SUDO_USER
  read -p "Ingresa el nombre de usuario para la instalación: " REAL_USER
fi

# Verificar que el usuario existe
if ! id "$REAL_USER" &>/dev/null; then
    echo "Error: El usuario '$REAL_USER' no existe en el sistema."
    exit 1
fi

# Obtener el directorio home del usuario
USER_HOME=$(eval echo ~$REAL_USER)
if [ ! -d "$USER_HOME" ]; then
    echo "Error: No se puede acceder al directorio home del usuario '$REAL_USER'."
    exit 1
fi

echo "Instalando para el usuario: $REAL_USER (Home: $USER_HOME)"
echo ""

# Actualizar el sistema
echo "### Actualizando el sistema..."
pacman -Syu --noconfirm

# Instalar herramientas de desarrollo
echo "### Instalando herramientas de desarrollo..."
pacman -S --noconfirm base-devel git neovim wget curl

# Instalar Xorg y componentes necesarios
echo "### Instalando Xorg y componentes necesarios..."
pacman -S --noconfirm xorg xorg-xinit xorg-xauth xf86-input-libinput \
    xorg-xrdb xorg-xbacklight xorg-fonts-misc ttf-font-awesome \
    ttf-dejavu ttf-liberation noto-fonts noto-fonts-emoji

# Instalar librerías de desarrollo para dwm, slstatus y slock
echo "### Instalando librerías de desarrollo..."
pacman -S --noconfirm libx11 libxft libxinerama libxrandr libxext \
    freetype2 fontconfig imlib2 pam harfbuzz libxrender \
    gtk2 gtk3 gtk4 glib2 pango cairo atk gdk-pixbuf2

# Instalar programas adicionales solicitados
echo "### Instalando programas adicionales (dunst, rofi, pamixer, picom)..."
pacman -S --noconfirm dunst rofi pamixer picom zathura zathura-pdf-poppler \
    zathura-ps xfce4-power-manager xautolock

# Instalar utilidades adicionales útiles para un entorno dwm
echo "### Instalando utilidades adicionales útiles..."
pacman -S --noconfirm feh nitrogen lxappearance pcmanfm alacritty \
    dmenu unclutter maim slop xclip xsel redshift kitty \
    networkmanager alsa-utils volumeicon \
    notification-daemon arandr scrot lxrandr

# Crear directorios para los códigos fuente
echo "### Creando directorios para los códigos fuente..."
mkdir -p $USER_HOME/.config/suckless

# Asegurarnos que los permisos son correctos
chown -R $REAL_USER:$REAL_USER $USER_HOME/.config

# Copiamos directorios config
cp -rf ./config $USER_HOME/.config/suckless/
cp -rf ./scripts $USER_HOME/.config/suckless/
cp -rf ./patches $USER_HOME/.config/suckless/
cp -rf ./dwm $USER_HOME/.config/suckless/
cp -rf ./slock $USER_HOME/.config/suckless/
cp -rf ./slstatus $USER_HOME/.config/suckless/

# Copiar archivos de configuración a .config
cp -rf $USER_HOME/.config/suckless/config/alacritty $USER_HOME/.config/
cp -rf $USER_HOME/.config/suckless/config/dunst $USER_HOME/.config/
cp -rf $USER_HOME/.config/suckless/config/kitty $USER_HOME/.config/
cp -rf $USER_HOME/.config/suckless/config/ranger $USER_HOME/.config/
cp -rf $USER_HOME/.config/suckless/config/rofi $USER_HOME/.config/
cp -rf $USER_HOME/.config/suckless/config/zathura $USER_HOME/.config/
cp -rf $USER_HOME/.config/suckless/config/picom $USER_HOME/.config/

# Cambiar temporalmente al usuario para compilar
echo "### Compilando e instalando dwm..."
cd $USER_HOME/.config/suckless/dwm
sudo -u $REAL_USER make
make install clean

echo "### Compilando e instalando slstatus..."
cd $USER_HOME/.config/suckless/slstatus
sudo -u $REAL_USER make
make install clean

echo "### Compilando e instalando slock..."
cd $USER_HOME/.config/suckless/slock
sudo -u $REAL_USER make
make install clean

# Copiar archivos de configuración de aplicaciones
echo "### Copiando configuraciones de aplicaciones..."
cp -rf $USER_HOME/.config/suckless/config/alacritty $USER_HOME/.config/
cp -rf $USER_HOME/.config/suckless/config/dunst $USER_HOME/.config/
cp -rf $USER_HOME/.config/suckless/config/rofi $USER_HOME/.config/
cp -rf $USER_HOME/.config/suckless/config/zathura $USER_HOME/.config/

# Asegurarnos que los permisos son correctos
chown -R $REAL_USER:$REAL_USER $USER_HOME/.config

# Crear entrada de escritorio para el gestor de inicio de sesión
echo "### Creando entrada para el gestor de inicio de sesión..."
cat > /usr/share/xsessions/dwm.desktop << EOF
[Desktop Entry]
Encoding=UTF-8
Name=dwm
Comment=Dynamic Window Manager
Exec=${USER_HOME}/.config/suckless/scripts/dwm
Icon=dwm
Type=Application
EOF

# Verificar si yay está instalado para AUR (opcional)
if ! command -v yay &> /dev/null; then
    echo "### Instalando yay (AUR helper) - opcional..."
    cd /tmp
    sudo -u $REAL_USER git clone https://aur.archlinux.org/yay.git
    cd yay
    sudo -u $REAL_USER makepkg -si --noconfirm
    cd ..
    rm -rf yay
fi

echo "==================================================================="
echo "¡Instalación completada!"
echo "==================================================================="
echo "Para iniciar tu entorno dwm:"
echo "1. Cierra sesión"
echo "2. Selecciona 'dwm' en tu gestor de inicio de sesión"
echo ""
echo "O simplemente ejecuta 'startx' si no estás usando un gestor de inicio de sesión."
echo ""
echo "Archivos importantes:"
echo "- Script de inicio: $USER_HOME/.config/suckless/scripts/dwm_start"
echo "- Configuración dwm: $USER_HOME/.config/suckless/dwm/config.h"
echo "- Configuración slstatus: $USER_HOME/.config/suckless/slstatus/config.h"
echo ""
echo "También se ha instalado yay para acceder a paquetes del AUR si necesitas"
echo "software adicional."
echo ""
echo "Recuerda que puedes personalizar dwm, slstatus y slock editando sus"
echo "archivos de configuración (config.h) y recompilando."
echo "==================================================================="
