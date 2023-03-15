[CmdletBinding()]
param(
    [string]$Search,
    [switch]$Download
)

$fortuneFile = "$env:USERPROFILE\.dotfortunes"
$remoteFortuneUrl = "https://raw.githubusercontent.com/bmc/fortunes/master/fortunes"

if ($Download) {
    Write-Verbose "Downloading fortune file from $remoteFortuneUrl ..."
    Invoke-WebRequest $remoteFortuneUrl -OutFile $fortuneFile -ErrorAction SilentlyContinue
}

if (!(Test-Path $fortuneFile)) {
    Write-Warning "Fortune file not found at $fortuneFile. Use -Download to download a default file from $remoteFortuneUrl."
    exit
}

$fortunes = Get-Content $fortuneFile -Delimiter "%"

if ($Search) {
    $matchingFortunes = $fortunes -match "(?i)\b$Search\b"
    if ($matchingFortunes.Count -eq 0) {
        Write-Warning "No matching fortunes found for '$Search'."
        exit
    }
    Write-Output ($matchingFortunes -join "`n")
}
else {
    $randomIndex = Get-Random -Minimum 0 -Maximum ($fortunes.Count - 1)
    $randomFortune = $fortunes[$randomIndex].Trim()
    Write-Output $randomFortune
}
