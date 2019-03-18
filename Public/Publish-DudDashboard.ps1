function Publish-DudDashboard {
    [CmdletBinding()]
    param (
        [Switch]$Force,
       [Parameter(Mandatory=$true)]
       [ValidateScript({Test-Path $_ -PathType Container})]
       [String]
       $Path,
       [ValidateScript({Test-Path $_})]
       [String]$License
       
    )
    
    begin {
        write-host $PSBoundParameters 
        $Paths = @(
            'src'
            'src\Endpoints'
            'src\Pages'
            'src\Scripts'
            'src\Styles'
        )
    }
      
    
    process {
        $ClientPath = Join-Path -Path $Path -ChildPath 'client'
        $SrcPath = Join-Path -Path $Path -ChildPath 'src'
        if (-not (Test-Path $SrcPath)) {New-Item $SrcPath -ItemType Directory}
        Foreach ($p in $Paths) {
            $CurrentPath = Join-Path -Path $Path -ChildPath $p
            if (-not (Test-Path -Path $CurrentPath)) {
                New-Item $CurrentPath -ItemType Container
            }
        }
        $UDModuleLocation =(Get-Module UniversalDashboard -ListAvailable)[0] | Select Path | Split-Path -Parent

        Foreach ($item in Get-ChildItem $UDModuleLocation) {
            Copy-Item -Path $item.FullName -Destination $Path -Container -Recurse -Force:$Force
        }
       
        

        [Void](New-Item -Path "$ClientPath\scripts" -ItemType SymbolicLink -Value "$SrcPath\scripts" -Force:$Force)
        [Void](New-Item -Path "$ClientPath\styles" -ItemType SymbolicLink -Value "$SrcPath\styles" -Force:$Force)
        [Void](New-Item -Path "$SrcPath\dashboard.ps1" -ItemType File -Value '.' -Force:$force)
        [Void](New-Item -Path  (Join-Path -Path $Path -ChildPath 'dashboard.ps1')  -ItemType HardLink -Value "$SrcPath\dashboard.ps1" -Force:$Force)

        if ($PSBoundParameters.ContainsKey('License')) {
            Copy-Item -Path $License -Destination (Join-Path -Path $Path -ChildPath "net472\")
        }
    


    }



    end {
    }
}

