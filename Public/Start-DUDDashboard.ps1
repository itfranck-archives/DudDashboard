function Start-DUDDashboard {
    [CmdletBinding()]
    param (
        [INT]$Port,
        [Switch]$Wait,
        $Parameters
    )
    
    $Cache:Paths = @{ }
    $Cache:Paths.Root = (Get-location).Path

    Set-DUDSettingsCache

    $Cache:Paths = @{
        Root                           = $Cache:Paths.Root
        CurrentDashboardFolderFullPath = ''
        CurrentDashboardFullPath       = ''
        CurrentDashboardFolder         = '' 
        CurrentDashboard               = ''
    }

    if ([String]::IsNullOrWhiteSpace($Cache:Paths.CurrentDashboardFolder)) {
        $Cache:Paths.CurrentDashboardFolderFullPath = "$($Cache:Paths.Root)\src"
    }
    else {
        $Cache:Paths.CurrentDashboardFolderFullPath = "$($Cache:Paths.Root)\src\$($Cache:Paths.CurrentDashboardFolder)"
    }


    $Cache:Paths.CurrentDashboardFullPath = "$($Cache:Paths.Root)\src\Root.ps1"


    $LoginFilePath = "$($Cache:Paths.Root)\src\Login.ps1"
    if (Test-Path -Path $LoginFilePath) {
        $Cache:LoginPage = & $LoginFilePath
    }

    $FooterFilePath = "$($Cache:Paths.Root)\src\Footer.ps1"
    if (Test-Path -Path $FooterFilePath) {
        $Cache:Footer = & $FooterFilePath
    }

    $NavigationFilePath = "$($Cache:Paths.Root)\src\Navigation.ps1"
    if (Test-Path -Path $NavigationFilePath) {
        $Cache:Navigation = & $NavigationFilePath
    }

    $Endpoints = Get-DUDEndpoints

    $Params = Get-DUDFolders
    $Cache:Params = $Params


    $DashboardStartParams = @{ }
    if ([String]::IsNullOrWhiteSpace($cache:Settings.UDConfig.SSLCertificatePath) -eq $false) {
        $DashboardStartParams.Certificate = Get-ChildItem -Path $cache:Settings.UDConfig.SSLCertificatePath
    }
    $GetSetting = { Param($MySetting, $ParamName) if ($MySetting -ne $null) { $DashboardStartParams."$ParamName" = $MySetting } }
    $GetSetting.Invoke($cache:Settings.UDConfig.UpdateToken, 'UpdateToken')
    $GetSetting.Invoke($Cache:Paths.CurrentDashboardFullPath, 'FilePath')
    $GetSetting.Invoke($Cache:Settings.UDConfig.Design, 'Design')
    $DashboardStartParams.Endpoint = $Endpoints

    #New-DUDDashboard
    Write-UDLog -Level Debug -Message "Test message" -LoggerName 'hello'
    Write-UDLog -Level Debug -Message "Test message" 
    Start-UDDashboard @PSBoundParameters @DashboardStartParams 
    
}
