Function Start-DUDDFilewatcher([DUDHotReloadPath]$Path) {
    $fileSystemWatcher = New-Object -TypeName 'System.IO.FileSystemWatcher' -ArgumentList $Path.Root.Path, $Path.Root.Filter -Property @{
        NotifyFilter = [IO.NotifyFilters]::LastWrite
        EnableRaisingEvents = $true
        IncludeSubdirectories = $Path.Root.Recurse
    }
    
    $WatchAction = {
        try {
            $Global:DashboardActionDelay.Stop()

            
            [DUDHotReloadPathItem]$Private:RuleUsed = $event.MessageData.Root

            Foreach ($Rule in $event.MessageData.Rules) {
                if ($event.SourceEventArgs.FullPath -like $Rule.Path ) {
                    $Private:RuleUsed = $Rule
                    break
                }
            }

            if ($Private:RuleUsed.CustomAction -ne $null) {$Global:DashboardActionRulesQueue+= $Private:RuleUsed}

            $Global:DashboardAction = $Global:DashboardAction -bor $Private:RuleUsed.Action


        }
        catch {
            Write-Host $_.Exception -ForegroundColor Red
        } Finally {
            $Global:DashboardActionDelay.Start()
        }

        Register-ObjectEvent $fileSystemWatcher Changed -SourceIdentifier $Path.Name -Action $WatchAction -MessageData @{ 
            AppPool       = $AppPool
            Rules = $Path
        }
     
}

}
