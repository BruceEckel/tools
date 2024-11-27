# tools
My personal tools that I use across Windows machines. Mostly written in Python with primary support for Windows 11. No documentation or support is offered, but you might find useful tidbits here and there. I'm just putting them here for my own convenience/reuse.

## Instructions for housing `settings.json` for console terminal in this repository:

1. Open a Powershell terminal in administrator mode

1. Delete old `settings.json` and immediately create a symbolic link to the one in this repo:

```powershell
Remove-Item "$env:LOCALAPPDATA\Packages\Microsoft.WindowsTerminal_8wekyb3d8bbwe\LocalState\settings.json" -Force; New-Item -ItemType SymbolicLink -Path "$env:LOCALAPPDATA\Packages\Microsoft.WindowsTerminal_8wekyb3d8bbwe\LocalState\settings.json" -Target "C:\git\tools\settings.json"
```
