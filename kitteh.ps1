# Powershell script to output system information, the unixporn way, basic neofetch-adjacent workalike.

function Get-SystemInfo {
    [CmdletBinding()]
    param()

    $bold = "[1m"
    $reset = "[0m"

    $osLabel = "${bold}OS:${reset}"
    $cpuLabel = "${bold}SOC:${reset}"
    $ramLabel = "${bold}RAM:${reset}"
    $gpuLabel = "${bold}GPU:${reset}"
    $spotifyLabel = "${bold}Currently Playing:${reset}"
    $foregroundColor = "Red"

    Function Get-SpotifyCurrentTrack {
        $spotify = Get-Process | Where-Object { $_.ProcessName -eq "Spotify" }
        if ($spotify -ne $null) {
            $title = $spotify.MainWindowTitle
            if ($title -match " - ") {
                $artist = $title.split(" - ")[0]
                $track = $title.split(" - ")[1]
                return [PSCustomObject]@{ Artist = $artist; Name = $track }
            }
        }
    }

    $osValue = "Windows $(Get-CimInstance Win32_OperatingSystem).Caption"
    $processor = Get-WmiObject Win32_Processor
    $cpuValue = "$($processor.Name) $($processor.NumberOfCores) cores @ $($processor.MaxClockSpeed / 1)GHz"
    $memory = Get-WmiObject Win32_OperatingSystem
    $ramValue = "$($memory.FreePhysicalMemory / 1MB)GB / $($memory.TotalVisibleMemorySize / 1MB)GB"
    $gpuList = Get-WmiObject Win32_VideoController | Select-Object Name, AdapterRAM
    $gpuInfo = $gpuList | ForEach-Object { "$($_.Name) @ $($_.AdapterRAM / 1GB)GB" }
    $spotifyValue = Get-SpotifyCurrentTrack -ErrorAction SilentlyContinue | ForEach-Object { "$($_.Artist) - $($_.Name)" }

    Write-Host @"
  ${bold}      .oo.           ${reset} $osLabel $osValue
  ${bold}    oGGGGMMb         ${reset} $cpuLabel $cpuValue
  ${bold}   dMMGGMMMMMMb       ${reset} $gpuLabel $($gpuInfo[0]) `n${bold}                   ${reset} $($gpuInfo[1])
  ${bold}  @@@@@@@@@@@M       ${reset} $ramLabel $ramValue
  ${bold} GGGGGGGGGGGG       ${reset} 
  ${bold} G:::::::::::G      ${reset} 
  ${bold} G:::::::::::G      ${reset} $spotifyLabel $spotifyValue
  ${bold} G:::GGGGGGGG:::G    ${reset} 
  ${bold} G:::G::::::::G     ${reset} 
  ${bold} G:::G::::::::G     ${reset} 
  ${bold} G::::Gooooooo::::G  ${reset} 
  ${bold} G::::G         GGGGGG${reset} 
  ${bold} G::::G              ${reset} 
  ${bold}  G:::::G            ${reset} 
   ${bold}  GG:::::G           ${reset} 
     ${bold}GGGGGGG            ${reset} 

"@ -ForegroundColor $foregroundColor
}

Get-SystemInfo
