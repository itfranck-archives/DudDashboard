function Publish-DudDashboard {
    [CmdletBinding()]
    param (
        [Switch]$Force,
        [Parameter(Mandatory = $true)]
        [ValidateScript( { Test-Path $_ -PathType Container })]
        [String]
        $Path,
        [ValidateScript( { Test-Path $_ })]
        [String]$License
       
    )
    
    begin {
      
       
    }
      
    
    process {
        $ClientPath = Join-Path -Path $Path -ChildPath 'client'
        $SrcPath = Join-Path -Path $Path -ChildPath 'src'
        if (-not (Test-Path $SrcPath)) { New-Item $SrcPath -ItemType Directory }
 
        $UDModuleLocation = (Get-Module UniversalDashboard -ListAvailable)[0] | Select Path | Split-Path -Parent
        $DUDModuleLocation = (Get-Module DUDDashboard -ListAvailable)[0] | Select Path | Split-Path -Parent
        $RootPath = Split-Path -Path $SrcPath -Parent
        Get-ChildItem $UDModuleLocation | % { Copy-Item -Path $_.FullName -Destination $Path -Container -Recurse -Force:$Force }
        Get-ChildItem "$DUDModuleLocation\Template" -Exclude 'root' | % { Copy-Item -Path $_.FullName -Destination $SrcPath -Container -Recurse -Force:$Force }
        Get-ChildItem "$DUDModuleLocation\Template\root" | % { Copy-Item -Path $_.FullName -Destination $RootPath -Container -Recurse -Force:$Force }
        
        
        $AppSettings = Get-content -Path "$RootPath\AppSettings.json" -Raw | ConvertFrom-Json
        $AppSettings.UDConfig.UpdateToken = New-Guid
        $AppSettings | ConvertTo-Json | Set-Content "$RootPath\AppSettings.json"

       
        #[Void](New-Item -Path "$SrcPath\scripts" -ItemType Directory)
        #[Void](New-Item -Path "$SrcPath\styles" -ItemType Directory)

        # [Void](New-Item -Path "$ClientPath\scripts" -ItemType SymbolicLink -Value "$SrcPath\scripts" -Force:$Force)
        # [Void](New-Item -Path "$ClientPath\styles" -ItemType SymbolicLink -Value "$SrcPath\styles" -Force:$Force)
        
        

        if ($PSBoundParameters.ContainsKey('License')) {
            Copy-Item -Path $License -Destination (Join-Path -Path $Path -ChildPath "net472\")
            Copy-Item -Path $License -Destination (Join-Path -Path $Path -ChildPath "netstandard2.0\")
        }
    


    }



    end {
    }
}

