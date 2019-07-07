$UDLoginPageParams = @{ }

# $AuthorizationPolicy = New-UDAuthorizationPolicy -Name "Policy1" -Endpoint {
#     param($User)
#     $User.HasClaim("groups", "")
# }

#$UDLoginPageParams.AuthorizationPolicy = $AuthorizationPolicy
 
#Auth params from Appsettings.json
$AuthParams = @{ }; $Cache:dud.Settings.Authentication.psobject.Properties | % { $AuthParams."$($_.Name)" = $_.Value }
$Auth = New-UDAuthenticationMethod @AuthParams 
$UDLoginPageParams.AuthenticationMethod = $Auth


New-UDLoginPage @UDLoginPageParams


