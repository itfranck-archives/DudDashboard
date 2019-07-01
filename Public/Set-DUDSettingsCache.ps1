Function Set-DUDSettingsCache($Path) {
    if ($Path -ne $null) {
        $Cache:Settings =  Get-Content "$Path\appsettings.json" | ConvertFrom-Json

    } else {
        $Cache:Settings =  Get-Content "$($Cache:Paths.Root)\appsettings.json" | ConvertFrom-Json    
    }
    
}