#!/bin/bash

# Script de instalación de dwm, slstatus y slock en Fedora 42
# Incluye todas las dependencias necesarias y programas adicionales

# Mostrar mensaje de bienvenida
echo "==================================================================="
echo "     Instalación de dwm, slstatus y slock en Fedora 42 KDE"
echo "==================================================================="
echo "Este script instalará todas las dependencias necesarias y programas"
echo "adicionales para tener un entorno dwm funcional."
echo "Se instalarán: Xorg, componentes de desarrollo, dunst, rofi,"
echo "pamixer, xcompmgr y otras utilidades."
echo "==================================================================="
echo ""

# Verificar si se está ejecutando como root
if [ "$EUID" -ne 0 ]; then
  echo "Por favor, ejecuta este script como root (usa sudo)."
  exit 1
fi

# Actualizar el sistema
echo "### Actualizando el sistema..."
dnf -y update

# Instalar grupo de desarrollo y herramientas básicas
echo "### Instalando herramientas de desarrollo..."
dnf -y install git neovim wget curl make gcc gcc-c++

# Instalar Xorg y componentes necesarios
echo "### Instalando Xorg y componentes necesarios..."
dnf -y install xorg-x11-server-Xorg xorg-x11-xinit xorg-x11-xauth \
    xorg-x11-drv-libinput xrdb xbacklight xorg-x11-fonts-misc \
    xorg-x11-fonts-100dpi xorg-x11-fonts-75dpi xorg-x11-fonts-Type1 \
    xorg-x11-fonts-truetype fontawesome-fonts fontawesome-fonts-web \
    dejavu-sans-fonts dejavu-sans-mono-fonts dejavu-serif-fonts \
    google-noto-sans-fonts google-noto-serif-fonts

# Instalar librerías de desarrollo para dwm, slstatus y slock
echo "### Instalando librerías de desarrollo..."
dnf -y install libX11-devel libXft-devel libXinerama-devel libXrandr-devel \
    libXext-devel freetype-devel fontconfig-devel imlib2-devel \
    pam-devel harfbuzz-devel libXrender-devel \
		gtk2-devel gtk3-devel gtk4-devel glib2-devel pango-devel cairo-devel \
    atk-devel gdk-pixbuf2-devel

# Instalar programas adicionales solicitados
echo "### Instalando programas adicionales (dunst, rofi, pamixer, xcompmgr)..."
dnf -y install dunst rofi pamixer xcompmgr zathura zathura-pdf-poppler zathura-ps

# Instalar utilidades adicionales útiles para un entorno dwm
echo "### Instalando utilidades adicionales útiles..."
dnf -y install feh nitrogen lxappearance pcmanfm alacritty \
    dmenu unclutter xwallpaper maim slop xclip xsel redshift \
    NetworkManager-tui alsa-utils volumeicon \
    notification-daemon arandr scrot lxrandr

# Crear directorios para los códigos fuente
echo "### Creando directorios para los códigos fuente..."
mkdir -p ~/.config/suckless
cp -rf ./config ~/.config/suckless/
cp -rf ./patches ~/.config/suckless/
cp -rf ./dwm ~/.config/suckless/
cp -rf ./slock ~/.config/suckless/
cp -rf ./slstatus ~/.config/suckless/

# Compilar e instalar dwm
echo "### Compilando e instalando dwm..."
cd ~/.config/suckless/dwm
make install clean

# Compilar e instalar slstatus
echo "### Compilando e instalando slstatus..."
cd ~/.config/suckless/slstatus
make install clean

# Compilar e instalar slock
echo "### Compilando e instalando slock..."
cd ~/.config/suckless/slock
make install clean

#Copiar archivos de configuración de alacritty dunst rofi zathura
echo "### Compiando configuraciones alacritty dunst rofi zathura..."
cp -rf ~/.config/suckless/config/alacritty ~/.config/
cp -rf ~/.config/suckless/config/dunst ~/.config/
cp -rf ~/.config/suckless/config/rofi ~/.config/
cp -rf ~/.config/suckless/config/zathura ~/.config/


# Crear entrada de escritorio para el gestor de inicio de sesión
echo "### Creando entrada para el gestor de inicio de sesión..."
cat > /usr/share/xsessions/dwm.desktop << EOF
[Desktop Entry]
Encoding=UTF-8
Name=dwm
Comment=Dynamic Window Manager
Exec=~/.config/suckless/config_files/dwm
Icon=dwm
Type=Application
EOF

echo "==================================================================="
echo "¡Instalación completada!"
echo "==================================================================="
echo "Para iniciar tu entorno dwm:"
echo "1. Cierra sesión"
echo "2. Selecciona 'dwm' en tu gestor de inicio de sesión"
echo ""
echo "O simplemente ejecuta 'startx' si no estás usando un gestor de inicio de sesión."
echo ""
echo "Recuerda que puedes personalizar dwm, slstatus y slock editando sus"
echo "archivos de configuración (config.h) y recompilando."
echo "==================================================================="
