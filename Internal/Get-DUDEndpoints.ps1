Function Get-DUDEndpoints(){
    $Endpoints = @()
     Get-ChildItem "$($Cache:dud.Paths.CurrentDashboardFolderFullPath)\Endpoints\*.ps1" -Recurse | % {$Endpoints += (& $_.FullName)}
    return $Endpoints
}
