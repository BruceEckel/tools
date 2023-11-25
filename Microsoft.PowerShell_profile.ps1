New-Alias which get-command

function touch {
    param (
        [Parameter(Mandatory = $true)]
        [string]$Path
    )

    if (Test-Path $Path) {
        # File exists, update its last write time
        (Get-Item $Path).LastWriteTime = Get-Date
    }
    else {
        # File doesn't exist, create a new file
        New-Item -ItemType File -Path $Path | Out-Null
    }
}

function prompt {
    # Update the tab title with the current directory name
    $folder = Split-Path -Path (Get-Location) -Leaf
    $host.UI.RawUI.WindowTitle = if ($folder) { $folder } else { "PowerShell" }

    # Return the default prompt
    "PS $($ExecutionContext.SessionState.Path.CurrentLocation)$('>' * ($nestedPromptLevel + 1)) "
}
