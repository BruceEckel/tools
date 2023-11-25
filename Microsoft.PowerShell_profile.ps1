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
function Set-TabTitle {
    $path = (Get-Location).Path
    $folder = Split-Path $path -Leaf
    $host.UI.RawUI.WindowTitle = $folder
}

# Set the tab title on opening a new tab
Set-TabTitle

# Update the tab title every time the directory changes
$Prompt = {
    Set-TabTitle
    # Original prompt functionality
    "PS $($ExecutionContext.SessionState.Path.CurrentLocation)$('>' * ($nestedPromptLevel + 1)) "
}
