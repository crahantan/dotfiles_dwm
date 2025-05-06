#!/bin/bash

# Script de instalación de dwm, slstatus y slock en Fedora 42
# Incluye todas las dependencias necesarias y programas adicionales

# Mostrar mensaje de bienvenida
echo "==================================================================="
echo "     Instalación de dwm, slstatus y slock en Fedora 42"
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
dnf -y group install "Development Tools" "C Development Tools and Libraries"
dnf -y install git vim wget curl

# Instalar Xorg y componentes necesarios
echo "### Instalando Xorg y componentes necesarios..."
dnf -y install xorg-x11-server-Xorg xorg-x11-xinit xorg-x11-xauth \
    xorg-x11-drv-libinput xorg-x11-utils xorg-x11-server-utils \
    xorg-x11-xkb-utils xrdb xbacklight xorg-x11-fonts-misc \
    xorg-x11-fonts-100dpi xorg-x11-fonts-75dpi xorg-x11-fonts-Type1 \
    xorg-x11-fonts-truetype fontawesome-fonts fontawesome-fonts-web \
    dejavu-sans-fonts dejavu-sans-mono-fonts dejavu-serif-fonts \
    google-noto-sans-fonts google-noto-serif-fonts

# Instalar librerías de desarrollo para dwm, slstatus y slock
echo "### Instalando librerías de desarrollo..."
dnf -y install libX11-devel libXft-devel libXinerama-devel libXrandr-devel \
    libXext-devel freetype-devel fontconfig-devel imlib2-devel \
    pam-devel harfbuzz-devel libXrender-devel

# Instalar programas adicionales solicitados
echo "### Instalando programas adicionales (dunst, rofi, pamixer, xcompmgr)..."
dnf -y install dunst rofi pamixer xcompmgr

# Instalar utilidades adicionales útiles para un entorno dwm
echo "### Instalando utilidades adicionales útiles..."
dnf -y install feh picom lxappearance pcmanfm alacritty \
    dmenu unclutter xwallpaper maim slop xclip xsel redshift \
    NetworkManager-tui pulseaudio pavucontrol alsa-utils volumeicon \
    notification-daemon arandr scrot

# Crear directorios para los códigos fuente
echo "### Creando directorios para los códigos fuente..."
mkdir -p ~/.config/suckless
cd ~/.config/suckless

# Compilar e instalar dwm
echo "### Compilando e instalando dwm..."
cd ~/suckless/dwm
make clean install

# Compilar e instalar slstatus
echo "### Compilando e instalando slstatus..."
cd ~/suckless/slstatus
make clean install

# Compilar e instalar slock
echo "### Compilando e instalando slock..."
cd ~/suckless/slock
make clean install

# Crear archivo .xinitrc
echo "### Creando archivo .xinitrc..."
cat > ~/.xinitrc << EOF
#!/bin/sh

# Cargar recursos X
[ -f ~/.Xresources ] && xrdb -merge ~/.Xresources

# Iniciar componentes del entorno
xsetroot -cursor_name left_ptr &
setxkbmap es &  # Cambia 'es' por tu distribución de teclado preferida
xcompmgr -c -f -n &
dunst &
nm-applet &
volumeicon &
/usr/libexec/polkit-gnome-authentication-agent-1 &
unclutter --timeout 10 &
feh --bg-fill /usr/share/backgrounds/fedora/default.png &  # Cambia la ruta por la de tu fondo de pantalla

# Iniciar slstatus
slstatus &

# Iniciar dwm
exec dwm
EOF

chmod +x ~/.xinitrc

# Crear entrada de escritorio para el gestor de inicio de sesión
echo "### Creando entrada para el gestor de inicio de sesión..."
cat > /usr/share/xsessions/dwm.desktop << EOF
[Desktop Entry]
Encoding=UTF-8
Name=dwm
Comment=Dynamic Window Manager
Exec=startx
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
