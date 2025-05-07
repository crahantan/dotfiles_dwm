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
dnf -y update

# Instalar grupo de desarrollo y herramientas básicas
echo "### Instalando herramientas de desarrollo..."
dnf -y install git neovim wget curl make gcc gcc-c++

# Instalar Xorg y componentes necesarios
echo "### Instalando Xorg y componentes necesarios..."
dnf -y install xorg-x11-server-Xorg xorg-x11-xinit xorg-x11-xauth \
    xorg-x11-drv-libinput xrdb xbacklight xorg-x11-fonts-misc \
    xorg-x11-fonts-100dpi xorg-x11-fonts-75dpi xorg-x11-fonts-Type1 \
    fontawesome-fonts fontawesome-fonts-web \
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
dnf -y install dunst rofi pamixer xcompmgr zathura zathura-pdf-poppler \
	zathura-ps xfce4-power-manager xautolock

# Instalar utilidades adicionales útiles para un entorno dwm
echo "### Instalando utilidades adicionales útiles..."
dnf -y install feh nitrogen lxappearance pcmanfm alacritty \
    dmenu unclutter maim slop xclip xsel redshift \
    NetworkManager-tui alsa-utils volumeicon \
    notification-daemon arandr scrot lxrandr

# Crear directorios para los códigos fuente
echo "### Creando directorios para los códigos fuente..."
mkdir -p $USER_HOME/.config/suckless

# Asegurarnos que los permisos son correctos
chown -R $USERNAME:$USERNAME $USER_HOME/.config

# Copiamos directorios config
cp -rf ./config $USER_HOME/.config/suckless/
cp -rf ./patches $USER_HOME/.config/suckless/
cp -rf ./dwm $USER_HOME/.config/suckless/
cp -rf ./slock $USER_HOME/.config/suckless/
cp -rf ./slstatus $USER_HOME/.config/suckless/

# Compilar e instalar dwm
echo "### Compilando e instalando dwm..."
cd $USER_HOME/.config/suckless/dwm
make install clean

# Compilar e instalar slstatus
echo "### Compilando e instalando slstatus..."
cd $USER_HOME/.config/suckless/slstatus
make install clean

# Compilar e instalar slock
echo "### Compilando e instalando slock..."
cd $USER_HOME/.config/suckless/slock
make install clean

#Copiar archivos de configuración de alacritty dunst rofi zathura
echo "### Compiando configuraciones alacritty dunst rofi zathura..."
cp -rf $USER_HOME/.config/suckless/config/alacritty ~/.config/
cp -rf $USER_HOME/.config/suckless/config/dunst ~/.config/
cp -rf $USER_HOME/.config/suckless/config/rofi ~/.config/
cp -rf $USER_HOME/.config/suckless/config/zathura ~/.config/

# Asegurarnos que los permisos son correctos
chown -R $USERNAME:$USERNAME $USER_HOME/.config


# Crear entrada de escritorio para el gestor de inicio de sesión
echo "### Creando entrada para el gestor de inicio de sesión..."
cat > /usr/share/xsessions/dwm.desktop << EOF
[Desktop Entry]
Encoding=UTF-8
Name=dwm
Comment=Dynamic Window Manager
Exec=${USER_HOME}/.config/suckless/config/dwm
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
echo "Archivos importantes:"
echo "- Script de inicio: $USER_HOME/.config/suckless/config/dwm_start"
echo "- Configuración dwm: $USER_HOME/.config/suckless/dwm/config.h"
echo "- Configuración slstatus: $USER_HOME/.config/suckless/slstatus/config.h"
echo ""
echo "Recuerda que puedes personalizar dwm, slstatus y slock editando sus"
echo "archivos de configuración (config.h) y recompilando."
echo "==================================================================="
