$Cache:dud.data.Debug = @{
    Note             = @{
        Title = 'Note about these actions buttons'
        Text  = @'
Please note that these buttons have some quirks associated with them in the current release. 
In between other things, there's a lack of feedback when clicking them.
Each button and what it does is described below. 
'@
    }
    RestartAppPool   = @{
        Title = 'Restart {0} App Pool'
        Text  = @'
Restart the application pool defined in the setting file. 
This is intended for use with IIS. 
Once you click the button, you should manually refresh the page (F5).
Page will take a few second to come back as the application pool was restarted.
'@
    }
    ToggleDesignMode = @{
        Title = 'Toggle Design mode'
        Text  = 'Toggle the Design setting in appsettings.json - You must restart the app pool and refresh the page for this to take effect. Please note that there is a bug currently in UD that make the Design mode disappear after the first update-dashboard. Toggling it only change the value in the app settings and won''t solve that issue.'
    }
    StartWatcher     = @{ 
        Title = 'Start Watcher'
        Text  = @'
Start an instance of the _Start-Batch.bat file in your root folder. 
The watcher will monitor file changes and refresh the dashboard or restart the apppool depending on the file changed. 
Appsettings / Login / Navigation / Footers / Endpoints will restart the apppool.
Pages and Data will update the dashboard instead. 
This button currently act as a _Start-batch.bat launcher. The process launched through that button will remain in memory until killed manually. 
'@
    }
    UpdateDashboard  = @{
        Title = 'Update Dashboard'
        Text  = @'
Triggers the Update-UDDashboard using the value from appsettings to do so.         
'@        
    }
}