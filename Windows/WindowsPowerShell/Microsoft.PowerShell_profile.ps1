(@(& 'C:/Users/misju/AppData/Local/Programs/oh-my-posh/bin/oh-my-posh.exe' init pwsh --config='C:\Users\misju\AppData\Local\Programs\oh-my-posh\themes\pure.omp.json' --print) -join "`n") | Invoke-Expression
fnm env --use-on-cd --shell powershell | Out-String | Invoke-Expression
Import-Module Terminal-Icons
Set-PSReadLineOption -PredictionViewStyle ListView
