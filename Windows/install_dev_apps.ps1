# Instala-Dev-Env.ps1

# --- Sección 1: Verificación e Inicialización ---

Write-Host "Iniciando la instalación de aplicaciones de desarrollo..." -ForegroundColor Green

# Verificar si Winget está instalado
try {
    winget --version | Out-Null
    Write-Host "Winget detectado. Continuando con la instalación." -ForegroundColor Green
} catch {
    Write-Warning "Winget no está instalado o no se encuentra en el PATH."
    Write-Host "Por favor, instala 'App Installer' desde la Microsoft Store o la última versión desde GitHub." -ForegroundColor Yellow
    Write-Host "Link a la Microsoft Store: ms-windows-store://pdp/?ProductId=9pmgp44c776ds" -ForegroundColor Yellow
    Write-Host "Presiona Enter después de instalar Winget para continuar, o Ctrl+C para salir." -ForegroundColor Yellow
    Read-Host
    # Volver a verificar después de que el usuario presione Enter
    try {
        winget --version | Out-Null
        Write-Host "Winget detectado. Continuando con la instalación." -ForegroundColor Green
    } catch {
        Write-Error "Winget aún no se detecta. Saliendo del script."
        exit 1
    }
}

# Actualizar Winget y sus fuentes (opcional, pero buena práctica)
Write-Host "Actualizando Winget y sus fuentes..." -ForegroundColor Cyan
try {
    winget upgrade --all --silent --accept-source-agreements --accept-package-agreements | Out-Null
    Write-Host "Winget y fuentes actualizadas." -ForegroundColor Green
} catch {
    Write-Warning "No se pudo actualizar Winget o sus fuentes. La instalación puede continuar."
}

# --- Sección 2: Lista de Aplicaciones a Instalar ---

# Lista de IDs de aplicaciones a instalar con Winget
# ¡Importante! Siempre verifica el ID exacto con 'winget search <nombre_app>' si tienes dudas.
$appsToInstall = @(
    # Herramientas de Desarrollo
    "Microsoft.VisualStudioCode",
    "GitHub.GitHubDesktop",
    "JetBrains.PyCharmCommunity",        # ID corregido: sin '.' entre PyCharm y Community
    "Postman.Postman",
    "DBeaver.DBeaverCommunity",          # Usando la versión Community, si necesitas la Enterprise, busca su ID
    "Docker.DockerDesktop",
    "JGraph.Draw.io",                    # ID corregido: con '.' entre Draw y io
    "Galiaz.fnm",                        # Fast Node Manager - ¡El binario! Necesita configuración post-instalación
    "JetBrains.IntelliJIDEA.Community",  # Usando la versión Community
    "Intel.IntelDriverAndSupportAssistant", # Ya disponible en Winget

    # Utilidades Esenciales
    "Rarlab.WinRAR",                     # ID corregido: Rarlab.WinRAR es el más común
    "SimonTatham.PuTTY",                 # ID corregido: SimonTatham.PuTTY
    "JanDeDobbeleer.OhMyPosh",           # Necesita configuración post-instalación
    "XanderFrans.TwinkleTray",           # ID corregido: XanderFrans.TwinkleTray
    "Audacity.Audacity",
    "OBSProject.OBSStudio",
    "Google.Chrome",
    "Discord.Discord",
    "FxSound.FxSound",

    # Gaming (Opcional)
    "Valve.Steam"
)

# --- Sección 3: Proceso de Instalación ---

Write-Host "`nIniciando la instalación de aplicaciones con Winget...`n" -ForegroundColor Green

foreach ($appId in $appsToInstall) {
    Write-Host "Instalando $($appId)..." -ForegroundColor Yellow
    try {
        # El "-e" (exact) asegura que se use el ID exacto, evitando ambigüedades.
        winget install --id $appId -e --silent --accept-package-agreements --accept-source-agreements
        Write-Host "$($appId) instalado correctamente." -ForegroundColor Green
    } catch {
        Write-Warning "¡Advertencia! No se pudo instalar $($appId). Error: $($_.Exception.Message)"
        Write-Host "Puedes intentar instalarlo manualmente o verificar el ID de Winget." -ForegroundColor Red
    }
}

# --- Sección 4: Configuraciones Post-Instalación y Notas ---

Write-Host "`n--- Instalación de aplicaciones básica finalizada ---`n" -ForegroundColor Green

Write-Host "¡Atención! Algunas aplicaciones requieren pasos adicionales o instalación manual:" -ForegroundColor Cyan

Write-Host "1.  **Oh My Posh:** Necesita configuración para tu shell (PowerShell, CMD, etc.)." -ForegroundColor Yellow
Write-Host "    Ejemplo para PowerShell (ejecutar en una nueva sesión o después de reiniciar):" -ForegroundColor DarkYellow
Write-Host "    Set-ExecutionPolicy Bypass -Scope Process -Force; Invoke-Expression ((New-Object System.Net.WebClient).DownloadString('https://ohmyposh.dev/install.ps1'))" -ForegroundColor DarkYellow
Write-Host "    Luego, configura un tema en tu perfil de PowerShell." -ForegroundColor DarkYellow

Write-Host "2.  **FNM (Fast Node Manager):** Aunque el binario está instalado, necesitas configurarlo para gestionar versiones de Node.js." -ForegroundColor Yellow
Write-Host "    Consulta la documentación oficial de FNM para la configuración de PATH y perfil." -ForegroundColor DarkYellow

Write-Host "3.  **Docker Desktop:** Es posible que necesite iniciar y configurar sus recursos (ej. WSL2) después de la instalación." -ForegroundColor Yellow

Write-Host "4.  **DaVinci Resolve:** Deberá descargarse e instalarse manualmente desde el sitio oficial de Blackmagic Design." -ForegroundColor Yellow

Write-Host "5.  **Alienware Command Center Package Manager:** Deberá descargarse e instalarse manualmente desde el sitio de soporte de Dell/Alienware para tu modelo específico." -ForegroundColor Yellow

Write-Host "`n¡Tu entorno de desarrollo está listo para seguir configurándose!" -ForegroundColor Green
