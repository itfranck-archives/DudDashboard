Function Get-DUDEndpoints(){
    $Endpoints = @()
     Get-ChildItem "$($Cache:Paths.CurrentDashboardFolderFullPath)\Endpoints\*.ps1" -Recurse | % {$Endpoints += (& $_.FullName)}
    return $Endpoints
}