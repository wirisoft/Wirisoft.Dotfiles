#!/bin/bash

# AlmaLinux 10 - Setup GNOME Dracula Theme & Extensions
# Instalación completa automatizada
# Uso: curl -fsSL https://raw.githubusercontent.com/tu-usuario/tu-repo/main/almalinux/setup.sh | bash

set -e  # Salir si hay algún error

# Colores para output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Función para imprimir mensajes con colores
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

# Verificar que se ejecuta en AlmaLinux/RHEL/Fedora
check_system() {
    print_status "Verificando sistema operativo..."
    if ! command -v dnf &> /dev/null; then
        print_error "Este script está diseñado para sistemas con DNF (AlmaLinux/RHEL/Fedora)"
        exit 1
    fi
    print_success "Sistema compatible detectado"
}

# Actualizar sistema
update_system() {
    print_status "Actualizando sistema..."
    sudo dnf update -y
    print_success "Sistema actualizado"
}

# Instalar herramientas básicas
install_basic_tools() {
    print_status "Instalando herramientas básicas..."
    sudo dnf install -y git wget unzip tar
    print_success "Herramientas básicas instaladas"
}

# Instalar GNOME Extensions App y extensiones
install_gnome_extensions() {
    print_status "Instalando GNOME Extensions App..."
    sudo dnf install -y gnome-extensions-app
    
    print_status "Instalando extensiones de GNOME Shell..."
    # Extensiones que tienes instaladas desde repositorios
    sudo dnf install -y \
        gnome-shell-extension-user-theme \
        gnome-shell-extension-dash-to-dock \
        gnome-shell-extension-places-menu \
        gnome-shell-extension-background-logo
    
    print_success "Extensiones de GNOME instaladas"
}

# Instalar tema Dracula
install_dracula_theme() {
    print_status "Descargando e instalando tema Dracula..."
    
    # Crear directorio de temas
    mkdir -p ~/.themes
    mkdir -p ~/.icons
    
    # Ir al directorio de descargas
    cd ~/Downloads
    
    # Descargar tema Dracula GTK
    if [ ! -f "master.zip" ]; then
        print_status "Descargando tema Dracula GTK..."
        wget https://github.com/dracula/gtk/archive/master.zip
    fi
    
    # Extraer y instalar tema
    print_status "Extrayendo tema Dracula..."
    unzip -o master.zip
    
    # Remover instalación anterior si existe
    if [ -d ~/.themes/Dracula ]; then
        rm -rf ~/.themes/Dracula
    fi
    
    mv gtk-master ~/.themes/Dracula
    print_success "Tema Dracula instalado en ~/.themes/Dracula"
}

# Habilitar extensiones
enable_extensions() {
    print_status "Habilitando extensiones de GNOME..."
    
    # Esperar un poco para que GNOME Shell cargue las extensiones
    sleep 3
    
    # Habilitar extensiones específicas
    gnome-extensions enable user-theme@gnome-shell-extensions.gcampax.github.com
    gnome-extensions enable dash-to-dock@micxgx.gmail.com
    gnome-extensions enable background-logo@fedorahosted.org
    # places-menu se mantiene deshabilitado como en tu configuración
    
    print_success "Extensiones habilitadas"
}

# Aplicar configuración de temas
apply_theme_settings() {
    print_status "Aplicando configuración de temas Dracula..."
    
    # Aplicar tema GTK Dracula
    gsettings set org.gnome.desktop.interface gtk-theme 'Dracula'
    
    # Aplicar tema del shell Dracula
    gsettings set org.gnome.shell.extensions.user-theme name 'Dracula'
    
    # Aplicar modo oscuro
    gsettings set org.gnome.desktop.interface color-scheme 'prefer-dark'
    
    # Configurar botones de ventana
    gsettings set org.gnome.desktop.wm.preferences button-layout 'appmenu:minimize,maximize,close'
    
    print_success "Configuración de temas aplicada"
}

# Configuración adicional
apply_additional_settings() {
    print_status "Aplicando configuraciones adicionales..."
    
    # Configurar fuentes (opcional)
    gsettings set org.gnome.desktop.interface font-name 'Cantarell 11'
    gsettings set org.gnome.desktop.interface monospace-font-name 'Source Code Pro 10'
    
    # Configurar iconos
    gsettings set org.gnome.desktop.interface icon-theme 'Adwaita'
    
    print_success "Configuraciones adicionales aplicadas"
}

# Verificar instalación
verify_installation() {
    print_status "Verificando instalación..."
    
    echo "=== Configuración actual ==="
    echo "Tema GTK: $(gsettings get org.gnome.desktop.interface gtk-theme)"
    echo "Tema Shell: $(gsettings get org.gnome.shell.extensions.user-theme name)"
    echo "Modo color: $(gsettings get org.gnome.desktop.interface color-scheme)"
    echo "Botones: $(gsettings get org.gnome.desktop.wm.preferences button-layout)"
    
    echo ""
    echo "=== Extensiones habilitadas ==="
    gnome-extensions list --enabled
    
    echo ""
    echo "=== Tema Dracula instalado ==="
    if [ -d ~/.themes/Dracula ]; then
        echo "✅ Tema Dracula encontrado en ~/.themes/Dracula"
        ls -la ~/.themes/Dracula/ | head -5
    else
        echo "❌ Tema Dracula no encontrado"
    fi
}

# Reiniciar GNOME Shell
restart_gnome_shell() {
    print_warning "Para ver todos los cambios, necesitas reiniciar GNOME Shell"
    print_status "Presiona Alt+F2, escribe 'r' y presiona Enter"
    print_status "O cierra sesión y vuelve a entrar"
}

# Función principal
main() {
    echo "=========================================="
    echo "  INSTALADOR DE CONFIGURACIÓN DRACULA"
    echo "  Para GNOME en AlmaLinux/RHEL/Fedora"
    echo "=========================================="
    echo ""
    
    # Verificar permisos
    if [[ $EUID -eq 0 ]]; then
        print_error "No ejecutes este script como root"
        exit 1
    fi
    
    # Verificar que tiene sudo
    if ! sudo -n true 2>/dev/null; then
        print_status "Se necesitarán permisos de administrador (sudo)"
        sudo -v
    fi
    
    # Ejecutar pasos
    check_system
    update_system
    install_basic_tools
    install_gnome_extensions
    install_dracula_theme
    enable_extensions
    apply_theme_settings
    apply_additional_settings
    verify_installation
    restart_gnome_shell
    
    echo ""
    print_success "¡Instalación completada!"
    print_status "Tu sistema ahora tiene:"
    echo "  ✅ Tema Dracula instalado"
    echo "  ✅ Extensiones configuradas (User Themes, Dash to Dock)"
    echo "  ✅ Botones de ventana configurados"
    echo "  ✅ Modo oscuro activado"
    echo ""
    print_warning "Reinicia GNOME Shell para ver todos los cambios"
}

# Ejecutar función principal
main "$@"
