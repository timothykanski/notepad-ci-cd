$watcher = New-Object System.IO.FileSystemWatcher
$watcher.Path = (Get-Location).Path
$watcher.Filter = "*"
$watcher.NotifyFilter = [IO.NotifyFilters]'FileName, LastWrite'
$watcher.IncludeSubdirectories = $true
$watcher.EnableRaisingEvents = $true

function Trigger-Deploy($changeType, $changedFile){
    Start-Sleep -Milliseconds 100  # debounce
    
    $timestamp = Get-Date -Format 'HH:mm:ss'
    $commitMsg = "Auto-commit: $changedFile @ $timestamp"

    Write-Host "Detected: $changeType → $changedFile"

    git add .

    # Check if there is anything to commit.
    $status = git status --porcelain
    if(-not $status){
        Write-Host "No changes to commit.  Skipping push."
        return
    }

    try {
      git commit -m $commitMsg
      git push
      Write-Host "Auto-commit and push complete: $changedFile @ $timestamp"
    } catch {
      Write-Host "Push failed. Try 'git pull' and resolve any merge conflicts."
    }
}

Register-ObjectEvent $watcher 'Changed' -Action {
    if ($Event.SourceEventArgs.FullPath -match '\\\.git\\') {
        return  # skip .git changes
    }

    $changedFile = $Event.SourceEventArgs.Name
    $changeType = "Changed"
    Trigger-Deploy $changeType $changedFile
}

Register-ObjectEvent $watcher 'Created' -Action {
    if ($Event.SourceEventArgs.FullPath -match '\\\.git\\') {
        return  # skip .git changes
    }

    $newFile = $Event.SourceEventArgs.Name
    $changeType = "Created"
    Trigger-Deploy $changeType $newFile
}

Register-ObjectEvent $watcher 'Renamed' -Action {
    if ($Event.SourceEventArgs.FullPath -match '\\\.git\\') {
        return  # skip .git changes
    }

    $newName = $Event.SourceEventArgs.Name
    $changeType = "Renamed"
    Trigger-Deploy $changeType $newName
}

# Initial Log Message
Write-Host "Watching for file changes in: $($watcher.Path)"

# Keep Session Alive
while ($true) {
 Start-Sleep -Seconds 5

 $currentSnapshot = Get-ChildItem -Recurse | ForEach-Object { $_.FullName, $_.LastWriteTime }

 if($currentSnapshot -ne $lastSnapshot){
   Trigger-Deploy "FallbackPoll" "manual-scan"
   $lastSnapshot = $currentSnapshot
 }
 
}