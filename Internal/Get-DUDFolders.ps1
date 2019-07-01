function Get-DUDFolders() {
    # Stylesheets
    
    $Output = @{
        Pages       = @()
        Stylesheets = @()
        Theme       = & "$($Cache:Paths.Root)\src\Theme.ps1"
        Scripts     = @()
    }
    
    $Functions = Get-ChildItem -Path "$($cache:Paths.CurrentDashboardFolderFullPath)\Functions" -Filter '*.ps1' -Recurse 
    $Functions | % { . $_.FullName }
    $FunctionsNames = $Functions | % { [System.IO.Path]::GetFileNameWithoutExtension($_.FullName) }


    Get-ChildItem "$($cache:Paths.CurrentDashboardFolderFullPath)\Pages\*.ps1" -Recurse | Sort FullName | % { $Output.Pages += (& $_.FullName) }
  
    $ScriptsPath = "$($cache:Paths.CurrentDashboardFolderFullPath)\Scripts"
    $ScriptsPath | Copy-Item -Destination "$($cache:Paths.Root)\client"  -Recurse -Force
    
    $ScriptsPath = Get-ChildItem "$($cache:Paths.CurrentDashboardFolderFullPath)\Scripts\*.*" | Sort FullName 
    $ScriptsPath.Name | % { $Output.Scripts += "/scripts/$_" }

   
    $StylesPath = "$($cache:Paths.CurrentDashboardFolderFullPath)\Styles"
    $StylesPath | Copy-Item -Destination "$($cache:Paths.Root)\client"  -Container -Recurse -Force

    $StylesPath = Get-ChildItem "$($cache:Paths.CurrentDashboardFolderFullPath)\Styles\*.*" | Sort FullName 
    $StylesPath.Name | % { $Output.Stylesheets += "/Styles/$_" }
    return $Output
}

