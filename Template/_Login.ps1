﻿$UDLoginPageParams = @{'Authenticationmethod' = [System.Collections.Generic.List[PSObject]]::new() }

# $AuthorizationPolicy = New-UDAuthorizationPolicy -Name "Policy1" -Endpoint {
#     param($User)
#     $User.HasClaim("groups", "")
# }

#$UDLoginPageParams.AuthorizationPolicy = $AuthorizationPolicy
 
#Auth params from Appsettings.json
$AuthParams = @{ }; $Cache:dud.Settings.Authentication.psobject.Properties | % { $AuthParams."$($_.Name)" = $_.Value }
$Auth = New-UDAuthenticationMethod @AuthParams 
$UDLoginPageParams.AuthenticationMethod.Add($Auth)


if ($Cache:dud.Settings.udConfig.APISigninKey -ne $null) {
    $ApiAuthMethod = New-UDAuthenticationMethod -SigningKey $Cache:dud.Settings.udConfig.APISigninKey 
    $AuthenticationMethods.AuthenticationMethod.Add($ApiAuthMethod)
    
}

New-UDLoginPage @UDLoginPageParams



