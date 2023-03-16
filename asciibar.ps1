# gives you a progress ascii bar.

[CmdletBinding()]
Param(
    [Parameter(Mandatory=$false, ValueFromPipeline=$true)]
    $percentage,
    [int]$width = 20
)

function GenerateAsciiBar($percentage, $width) {
    $filledCount = [math]::Round($percentage * $width / 100)
    $emptyCount = $width - $filledCount

    $filledBar = [string]::Join('', [char]::ConvertFromUtf32(9608) * $filledCount)
    $emptyBar = [string]::Join('', [char]::ConvertFromUtf32(9617) * $emptyCount)

    return "`r{0}{1} {2}%" -f $filledBar, $emptyBar, $percentage
}

if ($percentage) {
    if ($percentage -lt 0 -or $percentage -gt 100) {
        Write-Error "Percentage must be between 0 and 100"
    }
    else {
        GenerateAsciiBar $percentage $width
    }
}
else {
    $percentage = Get-Random -Minimum 0 -Maximum 101
    GenerateAsciiBar $percentage $width
}
