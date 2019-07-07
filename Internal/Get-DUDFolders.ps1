function Get-DUDFolders() {
    # Stylesheets
    
    $Output = @{
        Pages       = @()
        Stylesheets = @()
        Theme       = & "$($Cache:dud.Paths.Root)\src\Theme.ps1"
        Scripts     = @()
    }
    
    $Functions = Get-ChildItem -Path "$($Cache:dud.Paths.CurrentDashboardFolderFullPath)\Functions" -Filter '*.ps1' -Recurse 
    $Functions | % { . $_.FullName }
    $FunctionsNames = $Functions | % { [System.IO.Path]::GetFileNameWithoutExtension($_.FullName) }


    Get-ChildItem "$($Cache:dud.Paths.CurrentDashboardFolderFullPath)\Pages\*.ps1" -Recurse | Sort FullName | % { $Output.Pages += (& $_.FullName) }
  
    $ScriptsPath = "$($Cache:dud.Paths.CurrentDashboardFolderFullPath)\Scripts"
    $ScriptsPath | Copy-Item -Destination "$($Cache:dud.Paths.Root)\client"  -Recurse -Force
    
    $ScriptsPath = Get-ChildItem "$($Cache:dud.Paths.CurrentDashboardFolderFullPath)\Scripts\*.*" | Sort FullName 
    $ScriptsPath.Name | % { $Output.Scripts += "/scripts/$_" }

   
    $StylesPath = "$($Cache:dud.Paths.CurrentDashboardFolderFullPath)\Styles"
    $StylesPath | Copy-Item -Destination "$($Cache:dud.Paths.Root)\client"  -Container -Recurse -Force

    $StylesPath = Get-ChildItem "$($Cache:dud.Paths.CurrentDashboardFolderFullPath)\Styles\*.*" | Sort FullName 
    $StylesPath.Name | % { $Output.Stylesheets += "/Styles/$_" }
    return $Output
}

