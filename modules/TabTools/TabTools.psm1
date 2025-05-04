function Open-VenvTab {
    param (
        [Parameter(Mandatory)]
        [string]$Path,

        [string]$Color = '#FFFFFF'
    )

    $logPath = "$env:TEMP\OpenVenvTab_trace.log"
    "[$(Get-Date -Format o)] Starting Open-VenvTab" | Out-File $logPath

    try {
        $pwshExe = "C:\Program Files\PowerShell\7\pwsh.exe"
        "Using pwshExe: $pwshExe" | Out-File $logPath -Append

        # Resolve the absolute path and tab title
        $absPath = (Resolve-Path $Path).Path
        $tabTitle = Split-Path $absPath -Leaf
        "absPath: $absPath" | Out-File $logPath -Append
        "tabTitle: $tabTitle" | Out-File $logPath -Append

        # Search upward for .venv\Scripts\Activate.ps1
        $venvActivate = $null
        $searchDir = [System.IO.DirectoryInfo]$absPath
        while ($searchDir -ne $null) {
            $candidate = Join-Path $searchDir.FullName '.venv\Scripts\Activate.ps1'
            if (Test-Path $candidate) {
                $venvActivate = $candidate
                break
            }
            $searchDir = $searchDir.Parent
        }
        "venvActivate: $venvActivate" | Out-File $logPath -Append

        # Prepare the script file that will run in the new tab
        $scriptFile = [System.IO.Path]::Combine(
            $env:TEMP,
            "OpenVenvTab_$($tabTitle.Replace(' ', '_')).ps1"
        )
        "scriptFile: $scriptFile" | Out-File $logPath -Append

        @"
Set-Location "$absPath"

if (Test-Path "$venvActivate") {
    Write-Host "Activating virtual environment from $venvActivate..."
    & "$venvActivate"
} else {
    Write-Host "No virtual environment found."
}
"@ | Set-Content -Path $scriptFile -Encoding UTF8

        "Script written. Contents:" | Out-File $logPath -Append
        Get-Content $scriptFile | Out-File $logPath -Append

        # Launch a new Windows Terminal tab
        $wtArgs = @(
            'new-tab',
            '--title', $tabTitle,
            '--tabColor', $Color,
            '--',
            $pwshExe, '-NoExit', '-File', $scriptFile
        )
        "Final wt args:" | Out-File $logPath -Append
        $wtArgs | Out-File $logPath -Append

        & 'wt' @wtArgs
        "wt launched successfully." | Out-File $logPath -Append
    }
    catch {
        "`n[$(Get-Date -Format o)] ERROR: $_" | Out-File $logPath -Append
    }

    Write-Host "Log written to $logPath"
}

function Open-VenvTabs {
    param (
        [Parameter(Mandatory)]
        [array]$Tabs  # Each element should be a hashtable with Path and optional Color
    )

    foreach ($tab in $Tabs) {
        $path = $tab.Path
        $color = $tab.Color
        if (-not $color) { $color = '#FFFFFF' }
        Open-VenvTab -Path $path -Color $color
        Start-Sleep -Milliseconds 300  # brief delay to avoid race conditions
    }
}
