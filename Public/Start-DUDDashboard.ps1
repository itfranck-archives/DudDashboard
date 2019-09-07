function Start-DUDDashboard {
    [CmdletBinding()]
    param (
        [INT]$Port,
        [Switch]$Wait,
        $Parameters
    )
    
    
    Set-DUDSettingsCache

    


    $LoginFilePath = "$($Cache:dud.Paths.Root)\src\Login.ps1"
    if (Test-Path -Path $LoginFilePath) {
        $Cache:LoginPage = & $LoginFilePath
    }

    $FooterFilePath = "$($Cache:dud.Paths.Root)\src\Footer.ps1"
    if (Test-Path -Path $FooterFilePath) {
        $Cache:Footer = & $FooterFilePath
    }

    $NavigationFilePath = "$($Cache:dud.Paths.Root)\src\Navigation.ps1"
    if (Test-Path -Path $NavigationFilePath) {
        $Cache:Navigation = & $NavigationFilePath
    }

    $Endpoints = Get-DUDEndpoints

    $Params = Get-DUDFolders
    $Cache:dud.Params = $Params


    $DashboardStartParams = @{ }
    if ([String]::IsNullOrWhiteSpace($Cache:dud.Settings.UDConfig.SSLCertificatePath) -eq $false) {
        $DashboardStartParams.Certificate = Get-ChildItem -Path $Cache:dud.Settings.UDConfig.SSLCertificatePath
    }
    $GetSetting = { Param($MySetting, $ParamName) if ($MySetting -ne $null) { $DashboardStartParams."$ParamName" = $MySetting } }
    $GetSetting.Invoke($Cache:dud.Settings.UDConfig.UpdateToken, 'UpdateToken')
    $GetSetting.Invoke($Cache:dud.Paths.CurrentDashboardFullPath, 'FilePath')
    $GetSetting.Invoke($Cache:dud.Settings.UDConfig.Design, 'Design')
    $DashboardStartParams.Endpoint = $Endpoints

    if ($null -eq $Parameters) { 
        $Parameters = @{ }
    }

    if ($cache:dud.Settings.PublishedFolders -ne $null) {
        $PublishedFolders = [system.collections.generic.list[psobject]]::new()
        Foreach ($i in ($cache:dud.Settings.PublishedFolders | Get-Member -MemberType NoteProperty).Name) {
            $PublishedFolders.Add((Publish-UDFolder -Path $cache:dud.Settings.PublishedFolders."$i" -RequestPath $i))
        }
        if ($PublishedFolders.Count -gt 0) {
            $DashboardStartParams.Add('PublishedFolder', $PublishedFolders)
        }
    }

    Start-UDDashboard @Parameters @PSBoundParameters @DashboardStartParams 
    
}

