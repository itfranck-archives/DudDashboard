New-UDSideNav  -Id 'sidenav' -Endpoint {
    $Pages = $Cache:dud.Params.Pages

    Foreach ($P in $Pages) {
        $Name = $P.Name
        $Url = $P.Url
        $Icon = @{}

        if ($P.icon -ne $null) {
            $Icon.Add('icon',$p.icon)
        }

        if ([String]::IsNullOrWhiteSpace($Url)) {$Url = $Name } else {$Url = $Url.trim('/')}
        if ([String]::IsNullOrWhiteSpace($Name)) {$Name = $Url}
        
        New-UDSideNavItem -Text $Url -Url $Url @Icon
    }
   
}

