Function New-DUDHotReloaderWatchPath([DUDHotReloadPathItem]$Root,[DUDHotReloadPathItem[]]$Rules) {
    return New-Object -TypeName 'DUDHotReloadPath' -Property @{'Root'=$Root;'Rules'=$Rules}
}
