#Import-Module 'C:\Github\DudDashboard\Output\DudDashboard\DUDDashboard.psm1' -Force
Write-Host 'test'
#Import-Module 'C:\Github\DudDashboard\DUDDashboard.psd1' -Force

. "C:\Github\DudDashboard\Public\Publish-DudDashboard.ps1"
Publish-DudDashboard -Path 'C:\Users\Mercier\Documents\GitHub\PoshUD-IIS\Rest3' -License 'C:\Users\Mercier\Documents\GitHub\PoshUD-IIS\rest - Copy\net472\license.lic'  -ErrorAction Stop
#Copy-Item -Path 'C:\Users\Mercier\Documents\GitHub\PoshUD-IIS\rest - public'  -Destination 'C:\Users\Mercier\Documents\GitHub\PoshUD-IIS\rest - Copy\net472\license.lic' -Container -Recurse -Force:$Force



$PSModuleAutoloadingPreference = "none"
explorer ((Split-Path (get-module -ListAvailable universaldashboard)[0].Path))
#Import-Module UniversalDashboard
#[Dashboardcolor]

$PSVersionTable


