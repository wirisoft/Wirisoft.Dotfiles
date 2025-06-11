#!/bin/bash

# DisplayLink Driver Installation Script for AlmaLinux/RHEL
# Author: Your Name
# Version: 1.0
# Date: $(date +'%Y-%m-%d')

set -e # Exit on any error

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Configuration
DRIVER_ZIP="DisplayLink USB Graphics Software for Ubuntu6.1.1-EXE.zip"
DRIVER_FILE="displaylink-driver-6.1.1-17.run"
SERVICE_NAME="displaylink-driver.service"
EVDI_MODULE="evdi"
TEMP_DIR="temp_displaylink"

# Functions
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

check_root() {
  if [[ $EUID -ne 0 ]]; then
    print_error "Este script debe ejecutarse como root (usa sudo)"
    exit 1
  fi
}

check_distro() {
  if [[ -f /etc/redhat-release ]]; then
    DISTRO=$(cat /etc/redhat-release)
    print_status "Distribución detectada: $DISTRO"

    if [[ $DISTRO == *"AlmaLinux"* ]] || [[ $DISTRO == *"Rocky"* ]] || [[ $DISTRO == *"CentOS"* ]] || [[ $DISTRO == *"Red Hat"* ]]; then
      print_success "Distribución compatible detectada"
    else
      print_warning "Distribución no probada, continuando..."
    fi
  else
    print_error "No se pudo detectar la distribución RHEL/CentOS/AlmaLinux"
    exit 1
  fi
}

check_driver_file() {
  if [[ ! -f "$DRIVER_ZIP" ]]; then
    print_error "Archivo ZIP del driver no encontrado: $DRIVER_ZIP"
    print_status "Asegúrate de que el archivo esté en el mismo directorio que este script"
    exit 1
  fi
  print_success "Archivo ZIP del driver encontrado: $DRIVER_ZIP"
}

install_dependencies() {
  print_status "Instalando dependencias necesarias..."

  # Update package database
  dnf update -y

  # Install development tools
  dnf groupinstall "Development Tools" -y

  # Install specific packages
  dnf install -y \
    kernel-devel \
    kernel-headers \
    dkms \
    libdrm-devel \
    systemd-devel \
    gcc \
    make

  print_success "Dependencias instaladas correctamente"
}

check_secure_boot() {
  if [[ -d /sys/firmware/efi ]]; then
    if mokutil --sb-state 2>/dev/null | grep -q "SecureBoot enabled"; then
      print_warning "Secure Boot está habilitado. Esto puede causar problemas con módulos del kernel no firmados."
      print_warning "Considera deshabilitar Secure Boot en el BIOS/UEFI si tienes problemas."
    else
      print_success "Secure Boot está deshabilitado"
    fi
  fi
}

backup_existing_driver() {
  if systemctl is-active --quiet "$SERVICE_NAME" 2>/dev/null; then
    print_status "Deteniendo servicio DisplayLink existente..."
    systemctl stop "$SERVICE_NAME"
  fi

  # Check if EVDI module is loaded
  if lsmod | grep -q "$EVDI_MODULE"; then
    print_status "Descargando módulo EVDI existente..."
    modprobe -r "$EVDI_MODULE" 2>/dev/null || true
  fi
}

extract_driver() {
  print_status "Extrayendo driver del archivo ZIP..."

  # Create temporary directory
  mkdir -p "$TEMP_DIR"

  # Extract ZIP file
  if command -v unzip >/dev/null 2>&1; then
    unzip -q "$DRIVER_ZIP" -d "$TEMP_DIR"
  else
    print_status "Instalando unzip..."
    dnf install -y unzip
    unzip -q "$DRIVER_ZIP" -d "$TEMP_DIR"
  fi

  # Find the .run file in extracted contents
  EXTRACTED_RUN=$(find "$TEMP_DIR" -name "*.run" | head -1)

  if [[ -z "$EXTRACTED_RUN" ]]; then
    print_error "No se encontró archivo .run en el ZIP"
    exit 1
  fi

  # Copy to current directory with expected name
  cp "$EXTRACTED_RUN" "./$DRIVER_FILE"
  chmod +x "$DRIVER_FILE"

  print_success "Driver extraído correctamente: $DRIVER_FILE"
}

install_driver() {
  print_status "Instalando driver DisplayLink..."

  # Run installer
  if ./"$DRIVER_FILE"; then
    print_success "Driver instalado correctamente"
  else
    print_error "Error durante la instalación del driver"
    exit 1
  fi
}

verify_installation() {
  print_status "Verificando instalación..."

  # Check if service exists and is enabled
  if systemctl list-unit-files | grep -q "$SERVICE_NAME"; then
    print_success "Servicio $SERVICE_NAME encontrado"

    # Enable service
    systemctl enable "$SERVICE_NAME"
    print_success "Servicio habilitado para inicio automático"

    # Start service
    if systemctl start "$SERVICE_NAME"; then
      print_success "Servicio iniciado correctamente"
    else
      print_warning "No se pudo iniciar el servicio, pero puede funcionar después del reinicio"
    fi
  else
    print_warning "Servicio $SERVICE_NAME no encontrado, buscando servicios DisplayLink..."
    FOUND_SERVICE=$(systemctl list-unit-files | grep -i display | grep -i link | head -1 | awk '{print $1}')
    if [[ -n "$FOUND_SERVICE" ]]; then
      print_success "Servicio encontrado: $FOUND_SERVICE"
      systemctl enable "$FOUND_SERVICE"
      systemctl start "$FOUND_SERVICE" || true
    fi
  fi

  # Check EVDI module
  if modprobe "$EVDI_MODULE" 2>/dev/null; then
    print_success "Módulo EVDI cargado correctamente"
  else
    print_warning "No se pudo cargar el módulo EVDI, se cargará automáticamente cuando sea necesario"
  fi
}

show_final_status() {
  echo
  echo "=============================================="
  echo "        INSTALACIÓN COMPLETADA"
  echo "=============================================="
  echo

  # Show service status
  print_status "Estado del servicio:"
  systemctl status "$SERVICE_NAME" --no-pager --lines=0 2>/dev/null || {
    FOUND_SERVICE=$(systemctl list-units | grep -i display | grep -i link | head -1 | awk '{print $1}')
    if [[ -n "$FOUND_SERVICE" ]]; then
      systemctl status "$FOUND_SERVICE" --no-pager --lines=0
    fi
  }

  echo
  print_status "Comandos útiles:"
  echo "  Ver estado del servicio:"
  echo "    sudo systemctl status $SERVICE_NAME"
  echo
  echo "  Verificar módulo EVDI:"
  echo "    lsmod | grep evdi"
  echo
  echo "  Ver logs del servicio:"
  echo "    journalctl -u $SERVICE_NAME"
  echo

  print_warning "IMPORTANTE: Reinicia el sistema para completar la instalación"
  echo "           sudo reboot"
  echo
  print_success "Después del reinicio, conecta tu dock USB y configura las pantallas en Configuración > Pantallas"
}

cleanup() {
  print_status "Limpiando archivos temporales..."

  # Remove temporary directory
  if [[ -d "$TEMP_DIR" ]]; then
    rm -rf "$TEMP_DIR"
  fi

  # Remove extracted .run file
  if [[ -f "$DRIVER_FILE" ]]; then
    rm -f "$DRIVER_FILE"
  fi

  print_success "Limpieza completada"
}

# Main installation process
main() {
  echo "=============================================="
  echo "    INSTALADOR DE DRIVER DISPLAYLINK"
  echo "    Para AlmaLinux/RHEL/CentOS/Rocky Linux"
  echo "=============================================="
  echo

  check_root
  check_distro
  check_driver_file
  check_secure_boot

  print_status "Iniciando instalación..."

  backup_existing_driver
  install_dependencies
  extract_driver
  install_driver
  verify_installation
  cleanup
  show_final_status

  echo
  print_success "¡Instalación completada! Reinicia el sistema para usar tu dock USB."
}

# Trap to handle errors
trap 'print_error "Error durante la instalación. Revisa los mensajes anteriores."; exit 1' ERR

# Run main function
main "$@"
