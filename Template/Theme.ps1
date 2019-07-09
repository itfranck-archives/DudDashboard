New-UDTheme -Name 'Azure2' -Parent 'Azure' -Definition @{
    'UDCheckbox'                             = @{'BackgroundColor' = 'white'; 'FontColor' = 'white' }
    '.collapsible-header, .collapsible-body' = @{'background-color' = '#333333' }
    '.sidenav'                               = @{'background-color' = '#333333' }
    '.sidenav li a'                          = @{'color' = 'white' }
}
 