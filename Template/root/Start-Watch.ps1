
Import-Module DUDDashboard
$root = $PSScriptRoot
Set-DUDSettingsCache -Path $root

$UDHotParams = @{
    Root          = $root
    UpdateToken   = $cache:Settings.UDConfig.UpdateToken
    DashboardPath = (Resolve-Path -Path $Appsettings.UDConfig.FilePath)
    Url           = $cache:Settings.HotReload.UpdateURL
    AppPool       = $cache:Settings.HotReload.AppPool
    UpdateDelay   = 750
}

#$Path1 = New-DUDHotReloaderWatchPath -Root (New-DUDHotReloaderWatchPathItem -Path 'C:\Users\xx\Documents\GitHub\SomeOtherThing' -Filter '*.*' -Recurse -Action Update)

Start-DUDHotReloader @UDHotParams # -AdditionalPaths $Path1



