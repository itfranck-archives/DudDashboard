function Start-DUDHotReloader {
    param(
        [Parameter(Mandatory = $true)]
        $Root,
        [Parameter(Mandatory)]
        $UpdateToken,
        [Parameter(Mandatory)]
        $Url,
        $AppPool,
        [int]$UpdateDelay = 750,
        [String]$DashboardPath,
        [System.Collections.Generic.List[DUDHotReloadPath]]$AdditionalPaths
    )

    Process {
        $fileInfo = [System.IO.FileInfo]::new($Root)

        $fileSystemWatcher = [System.IO.FileSystemWatcher]::new($fileInfo.DirectoryName, "*.*") 
        $fileSystemWatcher.NotifyFilter = [IO.NotifyFilters]::LastWrite
        $fileSystemWatcher.EnableRaisingEvents = $true
        $fileSystemWatcher.IncludeSubdirectories = $true


        $Global:DashboardAction = [DashboardAction]::Undefined
        $Global:DashboardActionRulesQueue = @()
        $Global:DashboardActionDelay = New-Object -TypeName 'System.Timers.Timer' -Property @{
            AutoReset = $true
            Interval  = $UpdateDelay
        }
     
     
        Register-ObjectEvent $Global:DashboardActionDelay elapsed -SourceIdentifier 'ActionDelay' -Action {
            try {
                $Operation = ""
                $Token = $event.MessageData.UpdateToken
                $Url = $event.MessageData.Url
             
                switch ($Global:DashboardAction) {
                    { $_ -band [DashboardAction]::Restart } {
                        $Operation = 'Apppool recycled'
                        Import-Module WebAdministration
                        Restart-WebAppPool -Name $event.MessageData.AppPool    
                        break
                    }
                    { $_ -band [DashboardAction]::Update } {
                        $Operation = 'Dashboard updated'
                        Update-UDDashboard -Url $Url -UpdateToken $Token -FilePath $event.MessageData.DashboardPath
                    }
                }
                if ($Global:DashboardAction -ne [DashboardAction]::Undefined) {
                    Write-Host "$(get-date) $Operation - $Url " -ForegroundColor Cyan
                }
                 
            }
            catch {
                Write-Host $_.Exception -ForegroundColor Red
            }
            Finally {
                $Global:DashboardAction = [DashboardAction]::Undefined
                $Global:DashboardActionDelay.Stop()
            }            

        } -MessageData @{ 
            Url           = $Url 
            UpdateToken   = $UpdateToken
            DashboardPath = $DashboardPath
            AppPool       = $AppPool
        }


        $WatchAction = {
            try {
                $Global:DashboardActionDelay.Stop()
                $Global:DashboardActionDelay.Start()
                $CanRestart = -not [String]::IsNullOrWhiteSpace($event.MessageData.AppPool)
                $RestartAction = [DashboardAction]::Restart
                if (-not $CanRestart) { $RestartAction = [DashboardAction]::Update }

                $Private:Root = $event.MessageData.Root
            
             
                $Private:Paths = New-Object -TypeName 'System.Collections.Generic.Dictionary[String,DashboardAction]'
                $Private:Paths.Add("$($Private:Root)\Dashboard.ps1", $RestartAction)
                $Private:Paths.Add("$($Private:Root)\AppSettings.json", $RestartAction)
                $Private:Paths.Add("$($Private:Root)\*\Endpoints\*.ps1", $RestartAction)
                $Private:Paths.Add("$($Private:Root)\*\Footer.ps1", $RestartAction)
                $Private:Paths.Add("$($Private:Root)\src\Navigation.ps1", $RestartAction)
                $Private:Paths.Add("$($Private:Root)\*.ps1", [DashboardAction]::Update)
                $Private:Paths.Add("$($Private:Root)\src\*.css", [DashboardAction]::Update)
                $Private:Paths.Add("$($Private:Root)\src\*.js", [DashboardAction]::Update)

                Foreach ($key in $Private:Paths.Keys) {
                    if ($event.SourceEventArgs.FullPath -like $key) {
                        Write-Host $key -ForegroundColor Red
                        $Global:DashboardAction = $Global:DashboardAction -bor $Private:Paths[$key] 
                        break
                    }
                }
             
            }
            catch {
                Write-Host $_.Exception -ForegroundColor Red
            }
      
        }

        Register-ObjectEvent $fileSystemWatcher Changed -SourceIdentifier FileChanged -Action $WatchAction -MessageData @{ 
            Root          = $Root
            EndpointsPath = $EndpointsPath
            AppPool       = $AppPool
        }

    }
}
