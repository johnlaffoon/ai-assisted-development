<#
    Script: link-shared-prompts.ps1
    Purpose: Creates a Windows junction point for the entire '.github/prompts' folder in a project repository, linking it to the shared repo.
    Usage:
        powershell -File .\link-shared-prompts.ps1 -ProjectRepoPath <absolute path to your project repo>

    - Run this script from the shared repo location.
    - It will create a junction in the target repo at .github/prompts, pointing to the shared repo's .github/prompts.
    - Ensures .gitignore in the target repo ignores .github/prompts.
    - All logic is self-contained.
#>
param(
    [Parameter(Mandatory=$true)]
    [string]$ProjectRepoPath
)

$SharedRepoPath = $PSScriptRoot
$folder = 'prompts'

Write-Host "Creating junction for folder: $folder"
$target = Join-Path -Path $SharedRepoPath -ChildPath ".github/$folder"
$junction = Join-Path -Path $ProjectRepoPath -ChildPath ".github/$folder"
$gitignore = Join-Path -Path $ProjectRepoPath -ChildPath ".gitignore"

if (-Not (Test-Path $junction)) {
    New-Item -ItemType Junction -Path $junction -Target $target
    Write-Host "Created junction: $junction -> $target"
} else {
    Write-Host "Junction already exists: $junction"
}

$relativeJunction = ".github/$folder/"
if (-Not (Test-Path $gitignore)) {
    Set-Content -Path $gitignore -Value $relativeJunction
    Write-Host "Created .gitignore and added $relativeJunction"
} else {
    $gitignoreContent = Get-Content $gitignore
    if ($gitignoreContent -notcontains $relativeJunction) {
        Add-Content -Path $gitignore -Value $relativeJunction
        Write-Host "Added $relativeJunction to .gitignore"
    } else {
        Write-Host "$relativeJunction already in .gitignore"
    }
}
