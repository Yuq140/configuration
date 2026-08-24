
# [Console]::OutputEncoding = [Text.Encoding]::UTF8

$env:PROJECTS = ""
$env:OMP_CONFIG_FILE = ""

$env:XDG_CONFIG_HOME = ""
$env:EDITOR = "nvim"
$env:VISUAL = "nvim"

function Clone-Window {
    [CmdletBinding()]
    param(
        # Optional target directory. If omitted, use the current location.
        [string]$Directory,

        # Optional command to run in the new tab (everything after the directory)
        [Parameter(ValueFromRemainingArguments = $true)]
        [string[]]$Command
    )

    # Resolve target directory
    if ($Directory) {
        if (-not (Test-Path $Directory -PathType Container)) {
            Write-Error "Directory '$Directory' does not exist."
            return
        }
        $dir = (Resolve-Path $Directory).Path
    } else {
        $dir = (Get-Location).Path
    }

    $title = Split-Path -Leaf $dir

    # Use the same PowerShell executable as the current session
    $psExe = (Get-Process -Id $PID).Path

    if ($Command.Count -gt 0) {
        $cmdLine = $Command -join ' '

        & wt -w 0 nt -d $dir --title $title `
            $psExe -NoExit -Command $cmdLine
    }
    else {
        & wt -w 0 nt -d $dir --title $title
    }
}

function gwt {
    param(
        [string]$Name
    )

    $wts = git worktree list
    if (-not $wts) { 
        Write-Host "No worktrees found." -ForegroundColor Yellow
        return 
    }

    # If a name is provided: try to jump directly to that worktree
    if ($Name) {
        # Match on either directory name (leaf of the path) OR branch name ([branch])
        $match = $wts |
            Where-Object {
                $path    = ($_ -split '\s+')[0]
                $wtName  = Split-Path $path -Leaf
                $branch  = if ($_ -match '\[(.*?)\]') { $Matches[1] } else { $null }

                ($wtName -eq $Name) -or ($branch -eq $Name)
            } |
            Select-Object -First 1

        if ($match) {
            $path = ($match -split '\s+')[0]
            Set-Location $path
            return
        }
        else {
            Write-Host "Worktree '$Name' not found by folder or branch name. Opening fzf..." -ForegroundColor Yellow
        }
    }

    # No name (or name not found) → fall back to fzf chooser
    $choice = $wts | fzf --height=40% --border --prompt "Select worktree: " --ansi
    if ($choice) {
        $path = ($choice -split '\s+')[0]
        Set-Location $path
    }
}

{
    $branch = git branch --all --sort=-committerdate --format="%(refname:short)" | fzf --ansi --height=40% --border --prompt "Select branch: " --preview 'git log -n 5 --color=always --oneline {-1}'

    if (-not $branch) {
        return
    }

    $selectedBranch = $branch.Trim()

    git show-ref --verify --quiet "refs/heads/$selectedBranch"
    if ($LASTEXITCODE -eq 0) {
        git switch @args $selectedBranch
        return
    }

    git show-ref --verify --quiet "refs/remotes/$selectedBranch"
    if ($LASTEXITCODE -eq 0) {
        $localBranch = $selectedBranch.Substring($selectedBranch.IndexOf('/') + 1)

        git show-ref --verify --quiet "refs/heads/$localBranch"
        if ($LASTEXITCODE -eq 0) {
            git switch @args $localBranch
        }
        else {
            git switch @args --track $selectedBranch
        }

        return
    }

    git switch @args $selectedBranch
}

function Change-Project {
    param(
        [string]$Name
    )

    if (-not $env:PROJECTS) {
        Write-Host "PROJECTS environment variable is not set." -ForegroundColor Red
        return
    }

    if (-not (Test-Path $env:PROJECTS)) {
        Write-Host "Projects directory does not exist: $env:PROJECTS" -ForegroundColor Red
        return
    }

    $dirs = Get-ChildItem -Path $env:PROJECTS -Directory | Sort-Object Name
    if ($dirs.Count -eq 0) {
        Write-Host "No directories found in $env:PROJECTS" -ForegroundColor Yellow
        return
    }

    # If a name is provided: try to jump directly to that project
    if ($Name) {
        # Case-insensitive match on directory name
        $target = $dirs |
            Where-Object { $_.Name -ieq $Name } |
            Select-Object -First 1

        if ($target) {
            Set-Location $target.FullName
            return
        }
        else {
            Write-Host "Project '$Name' not found. Opening fzf..." -ForegroundColor Yellow
        }
    }

    # No name (or name not found) → fall back to fzf chooser
    $selection = $dirs |
        ForEach-Object { $_.Name } |
        fzf --height=40% --border --prompt "Select project: " --ansi

    if ($selection) {
        Set-Location (Join-Path $env:PROJECTS $selection)
    }
}

# function gwt {
#     param(
#         [string]$Name
#     )
#
#     $wts = git worktree list
#     if (-not $wts) { 
#         Write-Host "No worktrees found." -ForegroundColor Yellow
#         return 
#     }
#
#     # Parse worktrees into objects
#     $wtList = @()
#     $i = 1
#     foreach ($wt in $wts) {
#         $path   = ($wt -split '\s+')[0]
#         $branch = if ($wt -match '\[(.*?)\]') { $Matches[1] } else { "detached" }
#         $short  = Split-Path $path -Leaf
#
#         $wtList += [PSCustomObject]@{
#             Index  = $i
#             Path   = $path
#             Branch = $branch
#             Name   = $short
#         }
#         $i++
#     }
#
#     # If a name was provided, try to jump directly
#     if ($Name) {
#         $matches = $wtList | Where-Object {
#             $_.Name   -eq $Name -or
#             $_.Branch -eq $Name
#         }
#
#         if (-not $matches) {
#             Write-Host "No worktree found matching '$Name'." -ForegroundColor Red
#             Write-Host "Available worktrees:" -ForegroundColor Cyan
#             $wtList | ForEach-Object {
#                 Write-Host " - $($_.Name) [$($_.Branch)] ($($_.Path))"
#             }
#             return
#         }
#
#         if ($matches.Count -gt 1) {
#             Write-Host "Multiple worktrees match '$Name':" -ForegroundColor Yellow
#             $matches | ForEach-Object {
#                 Write-Host " - $($_.Name) [$($_.Branch)] ($($_.Path))"
#             }
#             Write-Host "Refine the name or use interactive 'gwt'." -ForegroundColor Yellow
#             return
#         }
#
#         # Single match – jump there
#         Set-Location $matches[0].Path
#         return
#     }
#
#     # No name: show interactive selector (original behavior)
#     Write-Host "`nAvailable Git Worktrees:" -ForegroundColor Cyan
#     foreach ($wt in $wtList) {
#         Write-Host "[$($wt.Index)] " -NoNewline -ForegroundColor Green
#         Write-Host "$($wt.Branch) " -NoNewline -ForegroundColor Yellow
#         Write-Host "($($wt.Path))"
#     }
#
#     Write-Host ""
#     $selection = Read-Host "Enter number to jump (or press Enter to cancel)"
#
#     if ($selection -match '^\d+$' -and
#         $selection -le $wtList.Count -and
#         $selection -gt 0) {
#
#         Set-Location $wtList[$selection - 1].Path
#     }
#     elseif ($selection) {
#         Write-Host "Invalid selection." -ForegroundColor Red
#     }
# }

Register-ArgumentCompleter -CommandName gwt -ParameterName Name -ScriptBlock {
    param(
        $commandName,
        $parameterName,
        $wordToComplete,
        $commandAst,
        $fakeBoundParameters
    )

    git worktree list | ForEach-Object {
        # First field is the path
        $path = ($_ -split '\s+')[0]
        $name = Split-Path $path -Leaf

        # Only suggest names that match what the user has started typing
        if ($name -like "*$wordToComplete*") {
            [System.Management.Automation.CompletionResult]::new(
                $name,         # Text inserted on completion
                $name,         # List text shown in the menu
                'ParameterValue',
                $path          # Tooltip / description
            )
        }
    }
}

Register-ArgumentCompleter -CommandName Change-Project -ParameterName Name -ScriptBlock {
    param($commandName, $parameterName, $wordToComplete, $commandAst, $fakeBoundParameters)

    $root = $env:PROJECTS
    if (-not $root -or -not (Test-Path $root)) {
        return
    }

    Get-ChildItem -Path $root -Directory |
        Where-Object { $_.Name -like "*$wordToComplete*" } |
        ForEach-Object {
            [System.Management.Automation.CompletionResult]::new(
                $_.Name,           # completion text inserted
                $_.Name,           # list item shown
                'ParameterValue',  # completion type
                $_.FullName        # tooltip
            )
        }
}

Set-Alias -Name grep -Value rg
Set-Alias -Name vim -Value nvim
Set-Alias -Name clone -Value Clone-Window
Set-Alias -Name project -Value Change-Project

oh-my-posh init pwsh --config $env:OMP_CONFIG_FILE | Invoke-Expression
