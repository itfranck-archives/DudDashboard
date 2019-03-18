Import-Module InvokeBuild
Invoke-Build -File '.\DUDDashboard.build.ps1' 

Move-Item 'C:\Users\Mercier\Documents\GitHub\DUDDashboard\Output' -Destination 'c:\_' 




