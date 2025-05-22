. $PSScriptRoot\RemoveGoneBranches.ps1

function Get-GitLog { 
    git log --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --abbrev-commit
}
New-Alias -Name glog -Value Get-GitLog

function Get-LogMe {
    get-git-log | Select-String -Pattern 'Sten Marius'
}
New-Alias -Name glogme -Value get-log-me

function Select-SearchLog($1) {
    get-git-log | Select-String -Pattern $1
}
New-Alias -Name slog -Value Select-SearchLog
function Get-GitStatus {
    git status
}
New-Alias -Name gist -Value Get-GitStatus

function Set-GitMaster {
    git checkout master
}
New-Alias -Name master -Value Set-GitMaster

function Set-GitMain {
    git checkout main
}
New-Alias -Name main -Value Set-GitMain

function Set-GitAddCommit($message) {
    git add -A; 
    git commit -m $message;
}
New-Alias -Name gac -Value Set-GitAddCommit

function Set-GitAddCommitPush($message) {
    git add -A; 
    git commit -m $message;
    git push;
}
New-Alias -Name acp -Value Set-GitAddCommitPush

function Get-GitRepo {
    git config --get remote.origin.url
}
New-Alias -Name repo -Value Get-GitRepo

function Select-AppCommits($to, $from) {
    echo "$to..$from"
    git log --pretty=oneline "$to..$from" | Select-String -Pattern "APP-"
}
New-Alias -Name sla -Value Select-AppCommits

function Select-AppCommitsLatest() {
    $latestTag = git describe --abbrev=0 --tags
    find-app-commits $latestTag HEAD
}
New-Alias -Name slal -Value Select-AppCommitsLatest

function Open-GitRemote() {
    $repo = git config --get remote.origin.url
    Start-Process "chrome.exe" $repo
}
New-Alias -Name ggr -Value Go-GitRemote