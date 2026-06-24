function Open-Tab {
    param (
        [Parameter(Mandatory)]
        [string]$Path,
        [string]$Color = '#FFFFFF',
        [string]$Command = '',
        [string]$Title = ''
    )
    $logPath = "$env:TEMP\OpenTab_trace.log"
    "[$(Get-Date -Format o)] Starting Open-Tab" | Out-File $logPath
    try {
        $pwshExe = "C:\Program Files\PowerShell\7\pwsh.exe"
        "Using pwshExe: $pwshExe" | Out-File $logPath -Append
        $absPath = (Resolve-Path $Path).Path
        $tabTitle = if ($Title) { $Title } else { Split-Path $absPath -Leaf }
        $scriptFile = [System.IO.Path]::Combine(
            $env:TEMP,
            "OpenTab_$($tabTitle.Replace(' ', '_')).ps1"
        )
        "scriptFile: $scriptFile" | Out-File $logPath -Append
        @"
Set-Location "$absPath"
`$host.UI.RawUI.WindowTitle = "$tabTitle"
$(if ($Command) { $Command })
"@ | Set-Content -Path $scriptFile -Encoding UTF8
        "Script written. Contents:" | Out-File $logPath -Append
        Get-Content $scriptFile | Out-File $logPath -Append
        $wtArgs = @(
            'new-tab',
            '--title', $tabTitle,
            '--tabColor', $Color,
            '--suppressApplicationTitle',
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

function Open-Tabs {
    param (
        [Parameter(Mandatory)]
        [array]$Tabs
    )
    foreach ($tab in $Tabs) {
        $path = $tab.Path
        $color = if ($tab.Color) { $tab.Color } else { '#FFFFFF' }
        $command = if ($tab.Command) { $tab.Command } else { '' }
        $title = if ($tab.Title) { $tab.Title } else { '' }
        Open-Tab -Path $path -Color $color -Command $command -Title $title
        Start-Sleep -Milliseconds 300
    }
}

function Open-VenvTab {
    param (
        [Parameter(Mandatory)]
        [string]$Path,
        [string]$Color = '#FFFFFF',
        [string]$Command = '',
        [string]$Title = ''
    )
    $logPath = "$env:TEMP\OpenVenvTab_trace.log"
    "[$(Get-Date -Format o)] Starting Open-VenvTab" | Out-File $logPath
    try {
        $pwshExe = "C:\Program Files\PowerShell\7\pwsh.exe"
        "Using pwshExe: $pwshExe" | Out-File $logPath -Append
        $absPath = (Resolve-Path $Path).Path
        $tabTitle = if ($Title) { $Title } else { Split-Path $absPath -Leaf }
        "absPath: $absPath" | Out-File $logPath -Append
        "tabTitle: $tabTitle" | Out-File $logPath -Append
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
        $scriptFile = [System.IO.Path]::Combine(
            $env:TEMP,
            "OpenVenvTab_$($tabTitle.Replace(' ', '_')).ps1"
        )
        "scriptFile: $scriptFile" | Out-File $logPath -Append
        @"
Set-Location "$absPath"
`$host.UI.RawUI.WindowTitle = "$tabTitle"
if (Test-Path "$venvActivate") {
    Write-Host "Activating virtual environment from $venvActivate..."
    & "$venvActivate"
} else {
    Write-Host "No virtual environment found."
}
$(if ($Command) { $Command })
"@ | Set-Content -Path $scriptFile -Encoding UTF8
        "Script written. Contents:" | Out-File $logPath -Append
        Get-Content $scriptFile | Out-File $logPath -Append
        $wtArgs = @(
            'new-tab',
            '--title', $tabTitle,
            '--tabColor', $Color,
            '--suppressApplicationTitle',
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
        [array]$Tabs
    )
    foreach ($tab in $Tabs) {
        $path = $tab.Path
        $color = if ($tab.Color) { $tab.Color } else { '#FFFFFF' }
        $command = if ($tab.Command) { $tab.Command } else { '' }
        $title = if ($tab.Title) { $tab.Title } else { '' }
        Open-VenvTab -Path $path -Color $color -Command $command -Title $title
        Start-Sleep -Milliseconds 300
    }
}
