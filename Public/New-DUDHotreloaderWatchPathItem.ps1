Function New-DUDHotReloaderWatchPathItem($Path,$Filter,[Switch]$Recurse,[DashboardAction]$Action,[Scriptblock]$CustomAction,[int]$Delay) {
    return New-Object -TypeName 'DUDHotReloadPathItem' -Property $PSBoundParameters
}