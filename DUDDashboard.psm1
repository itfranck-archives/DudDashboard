$functionFolders = @('Types','Classes','Public', 'Internal')
if (Test-Path "$PSScriptRoot\build") {Remove-Item -Path "$PSScriptRoot\build" -Force -Recurse}
New-Item "$PSScriptRoot\build" -ItemType Directory
ForEach ($folder in $functionFolders)
{
    $folderPath = Join-Path -Path $PSScriptRoot -ChildPath $folder
    If (Test-Path -Path $folderPath)
    {
        Write-Verbose -Message "Importing from $folder"
        $functions = Get-ChildItem -Path $folderPath -Filter '*.ps1' 
        $Content = ''
        ForEach ($function in $functions)
        {
            Write-Verbose -Message "  Importing $($function.BaseName)"
            switch ($folder) {
                'Types' { 
                    . $function.FullName
                 }
                Default {
                    $Content+= Get-Content -Path $($function.FullName) -Raw
                    $Content+= "`r`n"
                }
            }
        }

        $Content | Out-File "$PSScriptRoot\build\tmp-$folder.ps1"
        $Content = . "$PSScriptRoot\build\tmp-$folder.ps1"
        $Content = ''
    }    
}
$publicFunctions = (Get-ChildItem -Path "$PSScriptRoot\Public" -Filter '*.ps1').BaseName
Export-ModuleMember -Function $publicFunctions

