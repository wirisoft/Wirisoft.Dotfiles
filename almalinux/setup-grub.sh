#!/bin/bash

# AlmaLinux 10 - GRUB Elegant Forest Float Theme Installer
# Descarga e instala el tema GRUB Elegant Forest Float desde Wirisoft.Dotfiles
# Uso: curl -fsSL https://raw.githubusercontent.com/wirisoft/Wirisoft.Dotfiles/main/almalinux/setup-grub.sh | bash

set -e

# Colores para output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

print_status() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

print_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# Verificar sistema
check_system() {
    print_status "Verificando sistema..."
    
    if [[ $EUID -eq 0 ]]; then
        print_error "No ejecutes este script como root"
        exit 1
    fi
    
    if ! command -v dnf &> /dev/null; then
        print_error "Este script es para sistemas con DNF (AlmaLinux/RHEL/Fedora)"
        exit 1
    fi
    
    if [ ! -d /boot/grub2 ]; then
        print_error "GRUB2 no encontrado en /boot/grub2"
        exit 1
    fi
    
    print_success "Sistema compatible detectado"
}

# Verificar permisos sudo
check_sudo() {
    print_status "Verificando permisos de administrador..."
    if ! sudo -n true 2>/dev/null; then
        print_status "Se necesitarán permisos de administrador"
        sudo -v
    fi
    print_success "Permisos verificados"
}

# Descargar tema GRUB desde el repositorio
download_grub_theme() {
    print_status "Descargando tema Elegant Forest Float desde Wirisoft.Dotfiles..."
    
    # Crear directorio temporal
    TEMP_DIR=$(mktemp -d)
    cd "$TEMP_DIR"
    
    # URLs de los archivos del tema desde tu repositorio
    BASE_URL="https://raw.githubusercontent.com/wirisoft/Wirisoft.Dotfiles/main/almalinux/grub-themes"
    
    # Crear estructura del tema
    mkdir -p Elegant-forest-float-left-dark
    cd Elegant-forest-float-left-dark
    
    print_status "Descargando archivos del tema..."
    
    # Descargar archivos principales (ajustar según lo que tengas en tu carpeta)
    wget -q "$BASE_URL/Elegant-forest-float-left-dark/theme.txt" -O theme.txt
    wget -q "$BASE_URL/Elegant-forest-float-left-dark/background.jpg" -O background.jpg
    wget -q "$BASE_URL/Elegant-forest-float-left-dark/logo.png" -O logo.png
    wget -q "$BASE_URL/Elegant-forest-float-left-dark/info.png" -O info.png
    
    # Descargar fuentes
    wget -q "$BASE_URL/Elegant-forest-float-left-dark/terminus-12.pf2" -O terminus-12.pf2
    wget -q "$BASE_URL/Elegant-forest-float-left-dark/terminus-14.pf2" -O terminus-14.pf2
    wget -q "$BASE_URL/Elegant-forest-float-left-dark/terminus-16.pf2" -O terminus-16.pf2
    wget -q "$BASE_URL/Elegant-forest-float-left-dark/terminus-18.pf2" -O terminus-18.pf2
    wget -q "$BASE_URL/Elegant-forest-float-left-dark/unifont-16.pf2" -O unifont-16.pf2
    
    # Descargar selectores
    wget -q "$BASE_URL/Elegant-forest-float-left-dark/select_c.png" -O select_c.png
    wget -q "$BASE_URL/Elegant-forest-float-left-dark/select_e.png" -O select_e.png
    wget -q "$BASE_URL/Elegant-forest-float-left-dark/select_w.png" -O select_w.png
    
    # Crear directorio de iconos y descargarlos
    mkdir -p icons
    # Aquí agregarías los iconos si los tienes
    
    print_success "Archivos del tema descargados"
    
    # Verificar que se descargaron los archivos principales
    if [ ! -f "theme.txt" ] || [ ! -f "background.jpg" ]; then
        print_error "Error descargando archivos del tema"
        print_warning "Continuando con instalación manual..."
        manual_installation
        return
    fi
}

# Instalación manual alternativa
manual_installation() {
    print_status "Descargando tema completo como ZIP..."
    cd ~/Downloads
    
    # Descargar el repositorio completo
    wget -O wirisoft-dotfiles.zip https://github.com/wirisoft/Wirisoft.Dotfiles/archive/refs/heads/main.zip
    unzip -o wirisoft-dotfiles.zip
    
    # Copiar tema desde el archivo descargado
    if [ -d "Wirisoft.Dotfiles-main/almalinux/grub-themes" ]; then
        TEMP_DIR="$PWD/Wirisoft.Dotfiles-main/almalinux/grub-themes"
        print_success "Tema encontrado en descarga ZIP"
    else
        print_error "No se pudo encontrar el tema en el repositorio"
        exit 1
    fi
}

# Instalar tema GRUB
install_grub_theme() {
    print_status "Instalando tema GRUB..."
    
    # Crear directorio de temas si no existe
    sudo mkdir -p /boot/grub2/themes/
    
    # Remover instalación anterior si existe
    if [ -d "/boot/grub2/themes/Elegant-forest-float-left-dark" ]; then
        print_status "Removiendo instalación anterior..."
        sudo rm -rf /boot/grub2/themes/Elegant-forest-float-left-dark
    fi
    
    # Copiar tema a ubicación final
    sudo cp -r "$TEMP_DIR/Elegant-forest-float-left-dark" /boot/grub2/themes/
    
    # Establecer permisos correctos
    sudo chmod -R 755 /boot/grub2/themes/Elegant-forest-float-left-dark/
    
    print_success "Tema GRUB instalado en /boot/grub2/themes/Elegant-forest-float-left-dark"
}

# Configurar GRUB
configure_grub() {
    print_status "Configurando GRUB..."
    
    # Crear backup de configuración
    sudo cp /etc/default/grub /etc/default/grub.backup.$(date +%Y%m%d_%H%M%S)
    
    # Configurar tema
    if grep -q "GRUB_THEME=" /etc/default/grub; then
        sudo sed -i 's|GRUB_THEME=.*|GRUB_THEME="/boot/grub2/themes/Elegant-forest-float-left-dark/theme.txt"|' /etc/default/grub
    else
        echo 'GRUB_THEME="/boot/grub2/themes/Elegant-forest-float-left-dark/theme.txt"' | sudo tee -a /etc/default/grub
    fi
    
    # Configurar resolución
    if ! grep -q "GRUB_GFXMODE=" /etc/default/grub; then
        echo 'GRUB_GFXMODE=1920x1080' | sudo tee -a /etc/default/grub
        echo 'GRUB_GFXPAYLOAD_LINUX=keep' | sudo tee -a /etc/default/grub
    fi
    
    # Comentar salida de terminal de consola
    sudo sed -i 's/^GRUB_TERMINAL_OUTPUT=/#GRUB_TERMINAL_OUTPUT=/' /etc/default/grub
    
    print_success "Configuración de GRUB actualizada"
}

# Regenerar configuración GRUB
regenerate_grub() {
    print_status "Regenerando configuración de GRUB..."
    sudo grub2-mkconfig -o /boot/grub2/grub.cfg
    
    if [ $? -eq 0 ]; then
        print_success "Configuración de GRUB regenerada correctamente"
    else
        print_error "Error regenerando configuración de GRUB"
        exit 1
    fi
}

# Verificar instalación
verify_installation() {
    print_status "Verificando instalación..."
    
    echo "=== Tema GRUB instalado ==="
    if sudo ls -la /boot/grub2/themes/Elegant-forest-float-left-dark/ &>/dev/null; then
        sudo ls -la /boot/grub2/themes/Elegant-forest-float-left-dark/ | head -10
        print_success "✅ Tema encontrado en /boot/grub2/themes/"
    else
        print_error "❌ Tema no encontrado"
        return 1
    fi
    
    echo ""
    echo "=== Configuración GRUB ==="
    grep -E "GRUB_THEME|GRUB_GFXMODE" /etc/default/grub
    
    echo ""
    echo "=== Verificación en grub.cfg ==="
    if sudo grep -q "Elegant-forest-float-left-dark" /boot/grub2/grub.cfg; then
        print_success "✅ Tema detectado en configuración GRUB"
    else
        print_warning "⚠️  Tema no detectado en grub.cfg"
    fi
}

# Limpiar archivos temporales
cleanup() {
    if [ -n "$TEMP_DIR" ] && [ -d "$TEMP_DIR" ]; then
        rm -rf "$TEMP_DIR"
        print_status "Archivos temporales eliminados"
    fi
}

# Función principal
main() {
    echo "=========================================="
    echo "  INSTALADOR TEMA GRUB ELEGANT FOREST"
    echo "  Desde: Wirisoft.Dotfiles"
    echo "=========================================="
    echo ""
    
    # Trap para limpiar en caso de error
    trap cleanup EXIT
    
    check_system
    check_sudo
    download_grub_theme
    install_grub_theme
    configure_grub
    regenerate_grub
    verify_installation
    
    echo ""
    print_success "¡Tema GRUB Elegant Forest instalado correctamente!"
    print_warning "Reinicia tu sistema para ver el nuevo tema GRUB"
    echo ""
    print_status "El tema incluye:"
    echo "  ✅ Fondo de bosque elegante"
    echo "  ✅ Fuentes Terminus personalizadas"
    echo "  ✅ Iconos y selectores modernos"
    echo "  ✅ Resolución 1920x1080"
}

# Ejecutar función principal
main "$@"
