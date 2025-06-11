# DisplayLink Driver Installation for AlmaLinux/RHEL

Instalación automatizada del driver DisplayLink para docks USB en AlmaLinux, CentOS Stream, Rocky Linux y otras distribuciones basadas en RHEL.

## 📋 Requisitos

- AlmaLinux 8/9, CentOS Stream, Rocky Linux, o RHEL 8/9
- Permisos de administrador (sudo)
- Conexión a internet para descargar dependencias
- Dock USB compatible con DisplayLink

## 🚀 Instalación Rápida

```bash
# Clonar el repositorio
git clone https://github.com/wirisoft/Wirisoft.Dotfiles.git
cd Wirisoft.Dotfiles/almalinux/displayDriverLinkUSB

# Ejecutar el script de instalación
chmod +x install-displaylink.sh
sudo ./install-displaylink.sh
```

## 📦 Contenido del Repositorio

```
almalinux/displayDriverLinkUSB/
├── README.md                                              # Este archivo
├── install-displaylink.sh                                 # Script de instalación automatizado
├── uninstall-displaylink.sh                              # Script de desinstalación
└── DisplayLink USB Graphics Software for Ubuntu6.1.1-EXE.zip  # Driver DisplayLink (ZIP)
```

## 🛠️ Instalación Manual

### Paso 1: Instalar Dependencias

```bash
sudo dnf groupinstall "Development Tools"
sudo dnf install kernel-devel kernel-headers dkms libdrm-devel systemd-devel
```

### Paso 2: Instalar Driver

```bash
chmod +x displaylink-driver-6.1.1-17.run
sudo ./displaylink-driver-6.1.1-17.run
```

### Paso 3: Verificar Instalación

```bash
# Verificar servicio
sudo systemctl status displaylink-driver.service

# Verificar módulo del kernel
lsmod | grep evdi

# Reiniciar sistema
sudo reboot
```

## ✅ Verificación Post-Instalación

Después del reinicio:

1. **Conecta tu dock USB**
2. **Verifica el servicio:**
   ```bash
   sudo systemctl status displaylink-driver.service
   ```
3. **Verifica el módulo:**
   ```bash
   lsmod | grep evdi
   ```
4. **Configura pantallas:** Ve a Configuración > Pantallas

## 🔧 Gestión del Servicio

```bash
# Ver estado del servicio
sudo systemctl status displaylink-driver.service

# Detener servicio
sudo systemctl stop displaylink-driver.service

# Iniciar servicio
sudo systemctl start displaylink-driver.service

# Reiniciar servicio
sudo systemctl restart displaylink-driver.service

# Deshabilitar inicio automático
sudo systemctl disable displaylink-driver.service

# Habilitar inicio automático
sudo systemctl enable displaylink-driver.service
```

## 🐛 Solución de Problemas

### El servicio no se encuentra
```bash
# Buscar servicios DisplayLink
sudo systemctl list-units | grep -i display
```

### Problemas de compilación
```bash
# Verificar headers del kernel
rpm -qa | grep kernel-devel
uname -r

# Reinstalar headers si es necesario
sudo dnf install kernel-devel-$(uname -r)
```

### Pantallas no detectadas
```bash
# Verificar dispositivos USB
lsusb | grep -i display

# Verificar logs del sistema
journalctl -u displaylink-driver.service
```

## 🗑️ Desinstalación

```bash
# Usar script de desinstalación
sudo ./uninstall-displaylink.sh

# O manual:
sudo displaylink-installer uninstall
```

## 📱 Dispositivos Compatibles

Este driver es compatible con dispositivos DisplayLink:
- **DL-3xxx series** (USB 3.0)
- **DL-4xxx series** (USB 3.0)
- **DL-5xxx series** (USB 3.0)
- **DL-6xxx series** (USB-C)

## 🔄 Actualizaciones

Para actualizar el driver:
1. Descargar nueva versión del driver
2. Ejecutar el script de instalación con la nueva versión
3. Reiniciar el sistema

## 📄 Notas Importantes

- **Wayland:** Puede tener problemas de compatibilidad. Se recomienda usar X11
- **Secure Boot:** Debe estar deshabilitado o configurar firma de módulos
- **Firewall:** Asegúrate de que no bloquee conexiones USB
- **Energía:** Algunos docks requieren alimentación externa

## 🆘 Soporte

Si tienes problemas:
1. Revisa los logs: `journalctl -u displaylink-driver.service`
2. Verifica la compatibilidad de tu dock en el sitio oficial de DisplayLink
3. Consulta el [foro oficial de DisplayLink](https://support.displaylink.com)
4. Abre un issue en el [repositorio de GitHub](https://github.com/wirisoft/Wirisoft.Dotfiles/issues)

## 📜 Licencia

Este proyecto contiene el driver oficial de DisplayLink. Consulta la licencia oficial en el archivo `LICENSE` incluido con el driver.

---

**Autor:** Wirisoft  
**Repositorio:** [Wirisoft.Dotfiles](https://github.com/wirisoft/Wirisoft.Dotfiles)  
**Versión:** 1.0  
**Última actualización:** $(date +'%Y-%m-%d')
