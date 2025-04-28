# Change C:\Users\bruce\OneDrive\Documents\PowerShell\Microsoft.PowerShell_profile.ps1
# To contain:
# . "C:\git\tools\Microsoft.PowerShell_profile.ps1"
# Edit using `code $PROFILE`


New-Alias which get-command

# $Env:PATH += ";" + "C:\Users\bruce\AppData\Local\Packages\PythonSoftwareFoundation.Python.3.12_qbz5n2kfra8p0\LocalCache\local-packages\Python312\Scripts"


# Ensure Git's grep.exe is available
if (-not (Get-Command grep -ErrorAction SilentlyContinue)) {
    $gitGrepPath = "C:\Program Files\Git\usr\bin"
    if (Test-Path "$gitGrepPath\grep.exe") {
        $env:PATH += ";$gitGrepPath"
    }
}


function up {
    pushd ..
    Write-Host "Moved up to $(Get-Location)"
}

function down {
    popd
    Write-Host "Returned to $(Get-Location)"
}


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

function a {
    # Initialize the directory to start searching from
    $currentDir = Get-Location

    while ($null -ne $currentDir) {
        # Create a DirectoryInfo object for the current directory
        $currentDirInfo = [System.IO.DirectoryInfo]::new($currentDir)

        # Construct the path to .venv in the current directory
        $venvPath = Join-Path -Path $currentDirInfo.FullName -ChildPath '.venv'

        if (Test-Path -Path $venvPath -PathType Container) {
            # If the .venv directory is found, activate the environment
            $activateScript = Join-Path -Path $venvPath -ChildPath 'Scripts\Activate.ps1'
            if (Test-Path -Path $activateScript) {
                Write-Output "Activating virtual environment from: $venvPath"
                & $activateScript
                return
            }
            else {
                Write-Output "Activation script not found in .venv directory at $venvPath."
                return
            }
        }

        # Move up to the parent directory, but stop if there is no parent
        if ($null -eq $currentDirInfo.Parent) {
            break
        }

        $currentDir = $currentDirInfo.Parent
    }

    # If no .venv directory is found
    Write-Output "No .venv directory found in the current directory or any parent directories."
}




function d {
    deactivate
}

# Function to activate the virtual environment if in the desired directory
function Enable-LazyGuideVenv {
    param (
        [Parameter(Mandatory = $true)]
        [string]$PathToCheck
    )

    # Check if we're in the desired directory or a subdirectory
    if ($PathToCheck -like 'C:\git\lazy_guide*') {
        # Activate the virtual environment if it's not already activated
        if (-not (Test-Path env:VIRTUAL_ENV)) {
            # Dynamically construct the full path to the activation script
            $venvActivatePath = Join-Path -Path (Resolve-Path 'C:\git\lazy_guide') -ChildPath '.venv\Scripts\Activate.ps1'

            # Check if the activation script exists before sourcing it
            if (Test-Path -Path $venvActivatePath) {
                . $venvActivatePath
            }
            else {
                Write-Output "Virtual environment activation script not found at $venvActivatePath"
            }
        }
    }
}



# Override Set-Location to activate virtual environment when navigating
function Set-Location {
    param (
        [Parameter(Mandatory = $true, Position = 0)]
        [string]$Path
    )

    # Call the original Set-Location to change the directory
    Microsoft.PowerShell.Management\Set-Location -Path $Path

    # Call the activation function after setting the new location
    $currentPath = Get-Location
    Enable-LazyGuideVenv -PathToCheck $currentPath.Path
}

# Check and activate the virtual environment at startup if we start in the desired directory
$currentPath = Get-Location
Enable-LazyGuideVenv -PathToCheck $currentPath.Path


# Import the Chocolatey Profile that contains the necessary code to enable
# tab-completions to function for `choco`.
# Be aware that if you are missing these lines from your profile, tab completion
# for `choco` will not function.
# See https://ch0.co/tab-completion for details.
$ChocolateyProfile = "$env:ChocolateyInstall\helpers\chocolateyProfile.psm1"
if (Test-Path($ChocolateyProfile)) {
    Import-Module "$ChocolateyProfile"
}
