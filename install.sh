#!/bin/bash

# Script de instalación de dwm, slstatus y slock en Arch Linux
# Incluye todas las dependencias necesarias y programas adicionales
#

# Colores ANSI
GREEN="\e[32m"
YELLOW="\e[33m"
RED="\e[31m"
RESET="\e[0m"
BOLD="\e[1m"

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

# Atualizar el sistema
echo "¿Deseas actualizar el sistema? [s/N]"
read -r respuesta

if [[ "$respuesta" =~ ^[sS]$ ]]; then
    echo "### Actualizando el sistema..."
    sudo pacman -Syu --noconfirm
else
    echo "### Saltando actualización..."
fi

# Validación e instalción de paquetes
echo "### Validación e Instalación de paquetes..."

# --------------------------
# Listas de paquetes
# --------------------------

# Paquetes de repos oficiales
official_packages=(
  # Herramientas de desarrollo
  base-devel git neovim wget curl

  # Xorg y componentes
  xorg-xinit xorg-xauth xf86-input-libinput
  xorg-xrdb xorg-xbacklight xorg-fonts-misc 
  ttf-dejavu ttf-liberation noto-fonts noto-fonts-emoji

  # Librerías de desarrollo
  libx11 libxft libxinerama libxrandr libxext
  freetype2 fontconfig imlib2 pam harfbuzz libxrender
  gtk2 gtk3 gtk4 glib2 pango cairo gdk-pixbuf2

  # Programas adicionales
  dunst rofi pamixer picom zathura zathura-cb
  zathura-pdf-mupdf zathura-cb

  # Utilidades
  feh nitrogen lxappearance pcmanfm dmenu unclutter maim slop xclip xsel redshift kitty
  networkmanager alsa-utils volumeicon notification-daemon arandr scrot lxrandr
)

# Paquetes que están en AUR
aur_packages=(
  xautolock
  # Nuevos paquetes de AUR en el futuro
)

# --------------------------
# Funciones
# --------------------------

install_official() {
  local installed=()
  local missing=()
  local not_found=()

  for pkg in "${official_packages[@]}"; do
    if pacman -Si "$pkg" &>/dev/null; then
      if pacman -Qi "$pkg" &>/dev/null; then
        installed+=("$pkg")
      else
        missing+=("$pkg")
      fi
    else
      not_found+=("$pkg")
    fi
  done

	echo -e "${BOLD}${GREEN}=>${RESET} Paquetes ya instalados (${#installed[@]}): ${installed[*]}"
	echo -e "${BOLD}${YELLOW}=>${RESET} Paquetes faltantes (${#missing[@]}): ${missing[*]}"
	echo -e "${BOLD}${RED}=>${RESET} No encontrados (${#not_found[@]}): ${not_found[*]}"

  if [ ${#missing[@]} -gt 0 ]; then
    echo -e "\n→ Instalando paquetes faltantes..."
    sudo pacman -S --noconfirm --needed "${missing[@]}"
  fi
}

install_aur() {
  local installed=()
  local missing=()
  local not_found=()

  for pkg in "${aur_packages[@]}"; do
    if pacman -Qi "$pkg" &>/dev/null || yay -Qi "$pkg" &>/dev/null; then
      installed+=("$pkg")
    else
      if yay -Ss "^$pkg$" &>/dev/null; then
        missing+=("$pkg")
      else
        not_found+=("$pkg")
      fi
    fi
  done

	echo -e "${BOLD}${GREEN}=>${RESET} Paquetes AUR ya instalados (${#installed[@]}): ${installed[*]}"
	echo -e "${BOLD}${YELLOW}=>${RESET} Paquetes AUR faltantes (${#missing[@]}): ${missing[*]}"
	echo -e "${BOLD}${RED}=>${RESET} Paquetes AUR no encontrados (${#not_found[@]}): ${not_found[*]}" 

  if [ ${#missing[@]} -gt 0 ]; then
    echo -e "\n→ Instalando paquetes AUR faltantes..."
    yay -S --noconfirm --needed "${missing[@]}"
  fi
}

# --------------------------
# Ejecución
# --------------------------

echo "### Instalando paquetes de repos oficiales..."
install_official

echo -e "\n### Instalando paquetes de AUR..."
install_aur

echo -e "\n${BOLD}${GREEN}=>${RESET} Todos los paquetes revisados e instalados correctamente."

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
echo "### Directorios copiados a suckless."

# Copiar archivos de configuración a .config
cp -rf $USER_HOME/.config/suckless/config/dunst $USER_HOME/.config/
cp -rf $USER_HOME/.config/suckless/config/kitty $USER_HOME/.config/
cp -rf $USER_HOME/.config/suckless/config/ranger $USER_HOME/.config/
cp -rf $USER_HOME/.config/suckless/config/rofi $USER_HOME/.config/
cp -rf $USER_HOME/.config/suckless/config/zathura $USER_HOME/.config/
cp -rf $USER_HOME/.config/suckless/config/picom $USER_HOME/.config/
echo "### Configuraciones copiadas a .config."

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
