# DudDashboard

DuDDashboard is a scaffolding module for Universal Dashboards. 

### Alpha stage
Please note that at current time, it is only tested on : 

- Windows
- IIS 
- Windows Powershell 5.1 

This is not to say that it won't work using Windows Service, Azure or .net core, just that in the current state, it is still untested on these mediums. 

Documentation below is only a tiny introduction and I plan to create a much more detailed documentation in the next few weeks.

Meanwhile, if you have any questions, you can ask them on my thread on the Universal Dashboard forum - Link here 

## Objectives. 
The objective of this module is to provide a scaffolding framework to develop quickly your dashboards. 

## Structure
DUDDashboard skeleton looks like this
- Root folder (where sit Dashboard.ps1, UD files and src folder. )
- Root/src folder - Except the configuration file, everything else reside in the src subfolder.

### Root files
- Dashboard.ps1
    - Contains Start-DUDDashboard, a wrapper for Start-UDDashboard that initialize DudDashboard

- Appsettings.json - Contains some settings you would normally pass to Start-UDDashboard, authentication settings used by the login (if defined) and some parameters tied to the DUD-HotReload component. 
- Start-Watch.ps1 (Requires appsettings.json Hotreload section configuration) - When developping, if you execute Start-Watch.ps1, it will start monitoring Files and either update the dashboard (Through Update-UDDashboard) or restart the IIS application pool. For this reason, this file need to be executed as an administrator. When the dashboard update itself, page will refresh automatically. When app pool is recycled, you will need to refresh manually the page yourself. Based on the changed element, Universal Dashboard requires to restart the IIS. Items and behaviors : 

    - Endpoints - Restart
    - Page, Scripts and Styles - Update
    - Dashboard.ps1 - Restart
    - Root.ps1 - update
    - Data - update
    - Navigation & Footer - Restart



### Src subfolder content

#### Files
When using the Publish-DUDDashboard command, you will notice that some of these files starts by an underscore. They won't be used until you remove the underscore (Ex: _Login.ps1 will be ignored. To use it, rename to Login.ps1)

All these files are command (some optionals) part of a normal UDDashboard. 

- Footer - return a New-UDFooter
- Login - Must return New-UDLogin 
- Navigation - Must return New-SideNav
- root - Return New-DuDDashboard (Wrapper for New-UDDashboard)
- Theme - Must return New-UDTheme

#### Folders
- Data
    -   Tied to Datasource appsettings.json . Files from the selected datasource subfolder are loaded into memory. Intended usage is to separate data from main datasource and a demo / dev source. You could therefore use the demo datasource for documenting or share the dashboard with peace of mind by having the demo datasource in place just by removing the production datasource, which might contains proprietary code. $Cache:DudData.MyPage can be referenced in your pages. (Better documentation to come)
- Endpoints 
    - All files within this folder must return New-UDEndpoint and will be imported automatically.
- Functions
    - All files within this folder are functions to be imported and made available within Universal Dashboard. 
- Pages
    - All files within this folder must return New-UDPage and will be imported automaticaly
- Scripts
    - All Javascript from this folder will be copied into the Root/Client/Scripts folder when app start and be added automatically in UD.
- Styles
    - All CSS scripts from this folder will be copied into the Root/Client/Styles folder when app start and applied to your dashboard.

    ### How to install

    Install-Module DUDDashboard

    - Create a folder on your hard drive
    - Create a new IIS website
    - Configure the apppool with a user that can run Universal Dashboard
    - Run Publish-DUDDashboard -Path 'Path_To_Your_New_Folder' -License 'Path of your License.lic file if you have one'

    