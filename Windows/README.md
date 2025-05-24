## 📦 Herramientas incluidas (Windows)

- [Starship Prompt](https://starship.rs)
- [Clink](https://github.com/chrisant996/clink)
- [Zoxide](https://github.com/ajeetdsouza/zoxide)
- [LSD (LSDeluxe)](https://github.com/lsd-rs/lsd)
- [fzf](https://github.com/junegunn/fzf)
- [bat](https://github.com/sharkdp/bat)
- [fd](https://github.com/sharkdp/fd)
- [Neovim](https://neovim.io)
- [Git](https://git-scm.com)

---

## 📜 Instalación en Windows 11

**Verifica que tienes [winget](https://learn.microsoft.com/windows/package-manager/winget) funcionando:**

```powershell
winget list



# ⚙️ Configuración de Entorno Windows 11

Este directorio contiene los archivos de configuración para:

- PowerShell (`Microsoft.PowerShell_profile.ps1`)
- CMD via Clink (`clink_start.cmd`, `clink_settings`, `starship.lua`, `zoxide.lua`)

---

## 1️⃣ Instalar herramientas de línea de comandos

    ```powershell
    winget install starship
    winget install --id=Microsoft.WindowsTerminal -e
    winget install --id=lsd-rs.lsd -e
    winget install --id=ajeetdsouza.zoxide -e
    winget install --id=junegunn.fzf -e
    winget install --id=sharkdp.bat -e
    winget install --id=sharkdp.fd -e
    winget install neovim
    winget install --id Git.Git -e --source winget



2️⃣ Configurar PowerShell con Starship
    Instala Starship:

    powershell
    winget install starship
    Agrega esto a tu perfil en  \Documents\PowerShell\Microsoft.PowerShell_profile.ps1:

    Invoke-Expression (&starship init powershell)

    ⚠ Si PowerShell bloquea la ejecución de scripts, ejecuta en powershell como administrador:

    Set-ExecutionPolicy -Scope CurrentUser -ExecutionPolicy RemoteSigned


3️⃣ Configurar Clink (CMD moderno)
    Instala Windows Terminal (ya instalado si hiciste el paso 1).

    Copia los siguientes archivos a C:\Users\<TuUsuario>\AppData\Local\clink:


    clink_settings
    clink_start.cmd
    starship.lua
    zoxide.lua
    Puedes usar un script o hacerlo manualmente. Verifica que la estructura quede así:

    C:\Users\<TuUsuario>\AppData\Local\clink\
    │
    ├── clink_start.cmd
    ├── clink_settings
    ├── starship.lua
    └── zoxide.lua


4️⃣ Instalar fuentes JetBrainsMono Nerd Font
    Ve a:

    🔗 JetBrainsMono Nerd Font 
        https://github.com/ryanoasis/nerd-fonts/releases/download/v3.4.0/JetBrainsMono.zip

    Extrae todo, selecciona las fuentes, clic derecho → Instalar para todos los usuarios.

    Abre CMD → Configuración → Fuente: JetBrainsMono Nerd Font Mono.

    Repite también en Windows Terminal.