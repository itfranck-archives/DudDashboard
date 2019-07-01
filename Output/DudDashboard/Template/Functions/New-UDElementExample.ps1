function New-UDElementExample {
    param(
        [ScriptBlock]$Example
    )

    $Example.Invoke()

    New-UDRow -Columns {
        New-UDColumn -MediumSize 6 -SmallSize 12 -Content {
            New-UDElement -Tag "pre" -Content {
                $Example.ToString()
            } -Attributes @{
                style = @{
                    backgroundColor = $ScriptColors.BackgroundColor
                    color           = $ScriptColors.FontColor
                    fontFamily      = '"SFMono-Regular",Consolas,"Liberation Mono",Menlo,Courier,monospace'
                }
                width = "80vw"
            }
        }
    }
}