# Shortcut command: (Target)
# powershell.exe -ExecutionPolicy Bypass -F C:\git\tools\console.ps1


# Create a Shortcut:

# Right-click on the desktop or in a folder, and select New > Shortcut.
# Follow the on-screen prompts to specify the location of the file or application. For example, if it’s a website, type the URL (e.g., https://www.example.com).
# Name your shortcut and click Finish.
# Pin to Taskbar:

# Right-click on the newly created shortcut.
# Choose Show more options (or hold Shift and right-click).
# Select Pin to taskbar.


# Enable or Disable "Do you want to close all tabs" in Windows Terminal Settings

# 1 Open Windows Terminal.

# 2 Click/tap on the down arrow button on the top bar, and click/tap on Settings Ctrl + , (comma). (see screenshot below)

# 3 Click/tap on Interaction in the left pane. (see screenshot below)

# 4 Turn On (default) or Off Warn when closing more than one tab for what you want.

# 5 Click/tap on Save to apply.


wt --tabColor '#CCCC00' -d C:\git\pybooktools\src\pybooktools `; new-tab --tabColor '#f59218' -d C:\git\LazyGuide\chapters `; new-tab --tabColor '#009999' -d C:\git\lazy_guide\src\types;




# wt --title "lazy_guide code" --tabColor '#009999' -d C:\git\lazy_guide `; new-tab --title "Lazy Guide Chapters" --tabColor '#f59218' -d C:\git\LazyGuide\chapters\ `;