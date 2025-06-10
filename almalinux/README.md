# AlmaLinux 10 - GNOME Dracula Setup

Configuración automatizada para AlmaLinux 10 con tema Dracula, extensiones GNOME y tema GRUB personalizado.

## 🚀 Instalación Rápida

### Una sola línea:
```bash
curl -fsSL https://raw.githubusercontent.com/wirisoft/Wirisoft.Dotfiles/main/almalinux/setup.sh | bash
```

### Instalación manual:
```bash
wget https://raw.githubusercontent.com/wirisoft/Wirisoft.Dotfiles/main/almalinux/setup.sh
chmod +x setup.sh
./setup.sh
```

## ✨ Qué incluye

- 🎨 **Tema Dracula** completo para GNOME
- 🚀 **GRUB Elegant Forest Float** - Bootloader personalizado  
- 🔧 **Extensiones GNOME**:
  - User Themes
  - Dash to Dock
  - Places Menu
  - Background Logo
- 🌙 **Modo oscuro** activado
- 🔘 **Botones de ventana** configurados (minimizar, maximizar, cerrar)

## 📋 Requisitos

- AlmaLinux 10 con GNOME Desktop
- Conexión a internet
- Permisos sudo

## 🔄 Después de la instalación

Reinicia GNOME Shell para ver todos los cambios:
- Presiona **Alt + F2**
- Escribe **r** 
- Presiona **Enter**

O cierra sesión y vuelve a entrar.

## 🆘 Solución de problemas

Si el tema no se aplica correctamente:
```bash
gsettings set org.gnome.desktop.interface gtk-theme 'Dracula'
gsettings set org.gnome.shell.extensions.user-theme name 'Dracula'
killall -3 gnome-shell
```

---

**Repositorio**: [Wirisoft.Dotfiles](https://github.com/wirisoft/Wirisoft.Dotfiles)  
**Autor**: Wirisoft
