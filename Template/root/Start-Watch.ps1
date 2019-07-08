Param([Switch]$Wait, $Path)
$AdminMode = (New-Object Security.Principal.WindowsPrincipal([Security.Principal.WindowsIdentity]::GetCurrent())).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)
if ([String]::IsNullOrWhiteSpace($Path) -eq $false) {
    if ($AdminMode -eq $false) {
        $Args = @(('-File "{0}\Start-watch.ps1"' -f $Path), '-wait', ('-path "{0}\"' -f $Path))
        Start-Process -FilePath Powershell.exe -WorkingDirectory $Path -ArgumentList $Args -Verb runas -ErrorAction Stop 
        exit
    }
    Set-Location -Path $Path 
}

#Import-Module DUDDashboard
import-module 'C:\Github\DudDashboard\DudDashboard.psd1' 
$root = $PSScriptRoot
Set-DUDSettingsCache -Path $root

$UDHotParams = @{
    Root          = $root
    UpdateToken   = $Cache:dud.Settings.UDConfig.UpdateToken
    DashboardPath = "$root\src\root.ps1"
    Url           = $Cache:dud.Settings.HotReload.UpdateURL
    AppPool       = $Cache:dud.Settings.HotReload.AppPool
    UpdateDelay   = 750
}

#$Path1 = New-DUDHotReloaderWatchPath -Root (New-DUDHotReloaderWatchPathItem -Path 'C:\Users\itfranck\Documents\GitHub\DUDDashboard' -Filter '*.*' -Recurse -Action Update)

Start-DUDHotReloader @UDHotParams # -AdditionalPaths $Path1

Write-Host $Path

if ($Wait) {
    while ($true) {
        Start-Sleep -Milliseconds 200
    }
}

