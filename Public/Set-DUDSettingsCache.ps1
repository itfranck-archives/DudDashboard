Function Set-DUDSettingsCache($Path) {
    if ($cache:dud -eq $null) { $cache:dud = @{ }
    } 
    if ($Path -ne $null) {
        $Cache:dud.Settings = Get-Content "$Path\appsettings.json" | ConvertFrom-Json

    }
    else {
        $Cache:dud.Settings = Get-Content "$($Cache:dud.Paths.Root)\appsettings.json" | ConvertFrom-Json    
    }
    
}



