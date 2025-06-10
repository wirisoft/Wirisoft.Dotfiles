# Estructura súper simple para tu repositorio

```
your-repo/
├── almalinux/
│   ├── README.md
│   └── setup.sh
```

## Solo 2 archivos:

### 1. `/almalinux/README.md` (básico)
```markdown
# AlmaLinux 10 - Setup GNOME Dracula

Instalación automática de tema Dracula y extensiones GNOME para AlmaLinux 10.

## Instalación

```bash
curl -fsSL https://raw.githubusercontent.com/tu-usuario/tu-repo/main/almalinux/setup.sh | bash
```

O manualmente:
```bash
wget https://raw.githubusercontent.com/tu-usuario/tu-repo/main/almalinux/setup.sh
chmod +x setup.sh
./setup.sh
```

## Qué instala:
- ✅ Tema Dracula para GNOME
- ✅ Extensiones: User Themes, Dash to Dock
- ✅ Tema GRUB Elegant Forest Float
- ✅ Botones de ventana configurados
- ✅ Modo oscuro

Reinicia GNOME Shell (Alt+F2 → 'r') después de la instalación.
```

### 2. `/almalinux/setup.sh` (el script que ya tienes)

## Uso:

```bash
# Desde cualquier lugar:
curl -fsSL https://raw.githubusercontent.com/tu-usuario/tu-repo/main/almalinux/setup.sh | bash

# O descarga y ejecuta:
wget https://raw.githubusercontent.com/tu-usuario/tu-repo/main/almalinux/setup.sh && chmod +x setup.sh && ./setup.sh
```

¡Súper simple! Solo un script y listo.
