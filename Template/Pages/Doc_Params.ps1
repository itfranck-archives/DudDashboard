New-UDPage -Name 'Doc_Appsettings'  -Content {

    New-UDCard -Title '$Cache:UDConfig' -Content {

        New-UDCard -Title 'SSLCertificatePath' -Text 'cert:\\CurrentUser\\My\\xxxxxx ' 
        New-UDCard -Title 'UpdateToken' -Text 'GUID for the update token used by Update-UDDashboard. Also used by HotReload'
        New-UDCard -Title 'FilePath' -Text '[Do not change] Intended to change relative path from Dashboard.ps1 to the dashboard file. Currently does not work and should be left to his default.'
        New-UDCard -Title 'AllowHttpForLogin' -Text 'Passed down to New-UDDashboard'
        New-UDCard -Title 'Design' -Text 'Control whether or not Design mode is enabledé'
        New-UDCard -Title 'DefaultTheme' -Text 'If specified, will be used as default theme. src\Theme.ps1 will overrides default theme.'
        New-UDCard -Title 'IdleTimeout' -Text 'Univesal Dashboard login timeout'
        New-UDCard -Title 'DashboardTitle' -Text 'Dashboard Title'
        New-UDCard -Title 'Datasource' -Text @"
Load the content of src/Data/<DataSource> into memory. 
This can be used to separate layout, Data and managing 2 or more datasource. 
To be documented more thoroughly.
"@
             
        

    }

    New-UDCard -Title '$Cache:dud.Settings — Populated from appsettings.json' -Content {
        New-UDCard -Title 'Authentication' -Text '[Hashtable] Values automatically passed to New-UDLoginpage'
        New-UDCard -Title 'HotReload' -Content {
            New-UDCard -Title ' ' -Text @'
            These parameters control the DUDHotReloader that refresh your dashboard automatically while you work. 
            It is currently designed to work with IIS. 

            Executing the Start-Watch.ps1 script before starting modifying file will ensure that: 
            - Apppool restart each time a modification is done in an endpoint file.
            - Update-UDDashboard will be triggered when files from the Pages / styles / scripts src folder are modified
'@
            New-UDCard -Title 'Delay' -Text '[Int] Delay in ms between the time a file is modified and the dashboard is refreshed. Since editor like VSCode auto-save the file on each keystroke, having a delay ensure the page is not continually refreshed while you are typing. '
            New-UDCard -Title 'UpdateURL' -Text '[String]URL of the dashboard (without page or endpoint paths)'
            New-UDCard -Title 'AppPool' -Text 'Application pool to restart when an endpoint is modified'
        }
    }

    New-UDCard -Title '$Cache:dud.Paths — automatically populated' -Content {
        New-UDCard -Title 'CurrentDashboardFullPath' -Text 'Full Path of the root.ps1 file'
        New-UDCard -Title 'CurrentDashboardFolderFullPath' -Text 'Full Path to the SRC folder'
        New-UDCard -Title 'Root' -Text 'Full Path to dashboard.ps1 folder'
    }
 
}

