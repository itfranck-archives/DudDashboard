
function  New-DUDDashboard {
    [CmdletBinding()]
    Param([Hashtable]$EndpointInit, [Hashtable]$ExtraParameters)

    try {
        $GetSetting = { Param($MySetting, $ParamName) if ($MySetting -ne $null) { $DashboardParams."$ParamName" = $MySetting } }

        $Cache:DUDData = @{ }
        $DashboardParams = @{ }

        $GetSetting.Invoke($Cache:Settings.UDConfig.DashboardTitle, 'Title')
        $GetSetting.Invoke($Cache:LoginPage, 'LoginPage')
        $GetSetting.Invoke($Cache:Footer, 'Footer')
        $GetSetting.Invoke($Cache:Navigation, 'Navigation')
        $GetSetting.Invoke($Cache:Settings.UDConfig.IdleTimeout, 'IdleTimeout')
    
        $Functions = Get-ChildItem -Path "$($cache:Paths.CurrentDashboardFolderFullPath)\Functions" -Filter '*.ps1' -Recurse 
        $Functions | % { . $_.FullName }
        $FunctionsNames = $Functions | % { [System.IO.Path]::GetFileNameWithoutExtension($_.FullName) }

        $DataSourcePath = "$($cache:Paths.CurrentDashboardFolderFullPath)\Data\$($Cache:Settings.UDConfig.DataSource)"
        if (Test-Path -Path $DataSourcePath ) {
            Get-ChildItem -Path $DataSourcePath -Filter '*.ps1' | % { . $_.FullName }
        }

        $EIParams = @{ }
        if ($PSBoundParameters.ContainsKey('EndpointInit')) {
            $EIParams = $PSBoundParameters.Item('EndpointInit')
     
            if ($null -eq $EIParams.Module) { $EIParams.remove('Module') }
            if ($null -eq $EIParams.Function) { $EIParams.remove('Function') }
            if ($null -eq $EIParams.Variable) { $EIParams.remove('Variable') }
        }
    
        if ($null -ne $FunctionsNames) {
            if ($null -ne $EIParams.Function) {
                $EIParams.function = $EIParams.Function + $FunctionsNames
            }
            else {
                $EIParams.Function = $FunctionsNames
            }
        
        }

        $EI = New-UDEndpointInitialization  -Function $FunctionsNames 
        $Params = Get-DUDFolders
        $Cache:Params = $Params

        $DataSourcePath = "$($cache:Paths.CurrentDashboardFolderFullPath)\Data\$($Cache:Settings.UDConfig.DataSource)"
        if (Test-Path -Path $DataSourcePath ) {
            Get-ChildItem -Path $DataSourcePath -Filter '*.ps1' | % { . $_.FullName }
        }
        
        if ($null -eq $Params) { $Params = @{ } 
        }
        if ($null -eq $ExtraParameters) { $ExtraParameters = @{ }
        }
        
        return  New-UDDashboard @DashboardParams @Params @ExtraParameters -EndpointInitialization $EI 
    
    }
    catch {
        $MyError = $_
        New-UDDashboard -Title 'Error' -Content {
            New-UDCard -Title '' -Text ($MyError | format-list -force | Out-String)
            New-UDCard -Title 'DashboardParams' -Text ($DashboardParams | Out-String)
            New-UDCard -Title 'Params' -Text ($Params | Out-String)
            New-UDCard -Title 'ExtraParameters' -Text ($ExtraParameters | Out-String)
            
        }    
    }
    
  
} #111111


# New-UDFooter

