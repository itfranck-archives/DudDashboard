New-UDPage -Name 'Debug' -AuthorizationPolicy 'Login' -Content {
    if ($Cache:UDLatestVersion -eq $null) {
        $Cache:UDLatestVersion = ((Find-Module -Name 'UniversalDashboard', 'DuDDashboard' -Repository psgallery) | Sort Name -Descending ).Version
        $Cache:UDCurrentVersion = @(
            ((get-module UniversalDashboard).Version.ToString())    
            ((get-module DUDDashboard).Version.ToString())
        )
    }
    
    New-UDCard -Title 'Debug informations' -Content {
        New-UDLayout -Columns 3 -Content {
            New-UDCard -Title 'PSVersion' -Text ($PSVersionTable.PSVersion.ToString()) 
            #https://www.powershellgallery.com/packages/UniversalDashboard
            $VersionAvailable = { Param($ModuleName, $Current, $Latest)
                if ($Current -eq $Latest) { return '' }
                return New-UDLink -Text " - New version available" -Url "https://www.powershellgallery.com/packages/$ModuleName" -OpenInNewWindow
            }
            
            
            New-UDCard -Title 'Universal Dashboard' -Content { 
                $Cache:UDCurrentVersion[0]
                $VersionAvailable.Invoke('UniversalDashboard', $Cache:UDCurrentVersion[0], $Cache:UDLatestVersion[0])
            }
            New-UDCard -Title 'Dud Dashboard' -Content { 
                $Cache:UDCurrentVersion[1]
                $VersionAvailable.Invoke('DudDashboard', $Cache:UDCurrentVersion[1], $Cache:UDLatestVersion[1])
            }
                
        }
    }


    New-UDCard -Title 'Welcome'  -content { 
        "Welcome to DUDDashboard ! "
        New-UDIcon -Icon book
        New-UDLink -Text 'Documentation' -Url 'https://app.gitbook.com/@itfranck/s/duddashboard/' -Icon $bokk -OpenInNewWindow 
        ' '
        New-UDIcon -Icon code
        New-UDLink -Text 'Github' -Url 'https://github.com/itfranck/DudDashboard' -OpenInNewWindow
        ' '
        New-UDIcon -Icon circle_notch
        New-UDLink -Text 'Questions ?' -Url 'https://forums.universaldashboard.io/t/dud-dashboard-wip-scaffolding-module/910' -OpenInNewWindow
    }

    New-UDCard -Title "Helpers" -Content {
        $ApppoolName = $Cache:dud.Settings.HotReload.Apppool
        New-UDButton -Text "Restart $ApppoolName app pool" -OnClick {
            Import-Module WebAdministration
            $ApppoolName = $Cache:dud.Settings.HotReload.Apppool
            Restart-WebAppPool -Name $ApppoolName
        } 
        
        New-UDButton -Text 'Toggle design mode *' -OnClick {
            $AppSettingsPath = "$($Cache:dud.Paths.Root)\appsettings.json" 
            $AppSettingsObject = (Get-Content -Path $AppSettingsPath -Raw | ConvertFrom-Json)
            $DesignToggle = $AppSettingsObject.UDConfig.design
            $AppSettingsObject.UDConfig.design = -not $DesignToggle
            Set-Content -Path $AppSettingsPath -Value ($AppSettingsObject | ConvertTo-Json ) -Force
        }
        #
        New-UDButton -Text 'Start watcher *' -Id 'ttt'  -OnClick {
            try {
                Set-UDElement -Id -'ttt' -Content { 'ssssssss' }
                $Start_WatchPath = "$($Cache:dud.Paths.Root)\_Start-watch.bat"
                Invoke-WmiMethod -Class Win32_Process -Name Create -ArgumentList $Start_WatchPath
                
            }
            catch {
                Update-UDDashboard $Cache:dud.Settings.UDConfig.updatetoken
            }
        }
        New-UDButton -Text 'Update Dashboard' -OnClick {
            
            $params = @{
                Url         = $Cache:dud.Settings.HotReload.UpdateURL
                FilePath    = "$($Cache:dud.Paths.root)\src\root.ps1"
                UpdateToken = $Cache:dud.Settings.UDConfig.updatetoken
            }
            Update-UDDashboard @params
        }

        New-UDCollapsible -Items {
            New-UDCollapsibleItem -Title '* Readme' -Content {
                New-UDCard -Title 'Toggle Design mode' -Text 'Toggle the Design setting in appsettings.json - You must restart the app pool and refresh the page for this to take effect.'
                New-UDCard -Title 'Start Watcher' -Text @'
                 Start an instance of the _Start-Batch.bat file in your root folder. 
                 The watcher will monitor file changes and refresh the dashboard or restart the apppool depending on the file changed. 
                 Appsettings / Login / Navigation / Footers / Endpoints will restart the apppool.
                 Pages and Data will update the dashboard instead. 

                 This button currently act as a _Start-batch.bat launcher. The process launched through that button will remain in memory until killed manually. 
'@              
            }
            
        }

    }


    

}

