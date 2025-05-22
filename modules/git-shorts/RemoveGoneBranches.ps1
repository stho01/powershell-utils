<#
.SYNOPSIS
  Sletter alle lokale grener som har status ": gone]" (fjernet fra remote).

.EXAMPLE
  .\Remove-DeletedGitBranches.ps1
  # Rydder repoet i nåværende mappe

  .\Remove-DeletedGitBranches.ps1 -RepoPath "C:\code\mitt-repo" -Force
  # Rydder et annet repo og tvinger sletting (-D)
#>
function Remove-GoneBranches {
    [CmdletBinding()]
    param (
        # Mappe som inneholder Git-repoet
        [string]$RepoPath = ".",
    
        # Navnet på remote (origin er standard)
        [string]$RemoteName = "origin",
    
        # Bruk -Force for å tvinge sletting (git branch -D)
        [switch]$Force
    )
    
    # --- Bytt til repo-mappen ----------------------------------------------------
    try {
        Set-Location -Path $RepoPath -ErrorAction Stop
    } catch {
        Write-Error "Finner ikke repo-mappen: $RepoPath"
        exit 1
    }
    
    # --- Hent oppdaterte referanser og prune -------------------------------------
    Write-Host "Henter fra '$RemoteName' og pruner fjernreferanser …"
    git fetch $RemoteName --prune
    
    if ($LASTEXITCODE -ne 0) {
        Write-Error "git fetch feilet – avbryter."
        exit 1
    }
    
    # --- Finn grener som er 'gone' ------------------------------------------------
    $goneBranches = git branch -vv |
        Where-Object { $_ -match ': gone\]' } |
        ForEach-Object {
            # Stripp av eventuell stjerne (*) foran aktiv gren og klipp ut selve navnet
            ($_ -replace '^\*', '').Trim().Split(' ')[0]
        }
    
    if (-not $goneBranches) {
        Write-Host "Ingen lokale grener å slette – alt er allerede ryddig. 🙂"
        exit 0
    }
    
    # --- Slett grenene -----------------------------------------------------------
    $deleteFlag = if ($Force) { '-D' } else { '-d' }
    
    Write-Host ""
    Write-Host "Sletter følgende grener med 'git branch $deleteFlag':"
    $goneBranches | ForEach-Object { Write-Host "  $_" }
    
    foreach ($branch in $goneBranches) {
        git branch $deleteFlag $branch
    }
    
    Write-Host ""
    Write-Host "Ferdig! Totalt slettet: $($goneBranches.Count)"
}