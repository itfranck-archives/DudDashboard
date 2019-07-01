import-module DUDDashboard


$Params = @{ }

# $EndpointInit = @{
#     [String[]]$Module = $null
#     [String[]]$Function = $null
#     [String[]]$Variable = $null
# }









$NavBarLinks = @((New-UDLink -Text "Github - DudDashboard"   -Url "https://github.com/itfranck/DudDashboard"),
    (New-UDLink -Text "Documentation" -Url "https://adamdriscoll.gitbooks.io/powershell-universal-dashboard/content/"))

$ExtraParameters = @{
    
    #NavBarColor        = [DashboardColor]$null
    #NavBarLogo         = ''
    #FontColor          = [DashboardColor]$null
    #LoadingScreen      = ''
    #NavBarFontColor    = [DashboardColor]$null
    #NavbarLinks = $NavBarLinks
    #CyclePages         = $true
    #BackgroundColor    = [DashboardColor]$null
    #CyclePagesInterval = [int]$null

}

if ($EndpointInit -ne $null) { $Params.Add('EndpointInit', $EndpointInit) }

New-DUDDashboard -ErrorAction Stop @Params -ExtraParameters $ExtraParameters


