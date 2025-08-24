$watcher = New-Object System.IO.FileSystemWatcher
$watcher.Path = (Get-Location).Path
$watcher.Filter = "*"
$watcher.EnableRaisingEvents = $true

Register-ObjectEvent $watcher 'Changed' -Action {
    Start-Sleep -Milliseconds 100  # debounce

    $changedFile = $Event.SourceEventArgs.Name
    $timestamp = Get-Date -Format 'HH:mm:ss'

    try {
      git add .
      git commit -m $commitMsg
      git push
      Write-Host "Auto-commit and push triggered by file change: $changedFile @ $timestamp"
    } catch {
      Write-Host "Push failed. Try pulling latest changes with 'git pull' and resolve conflicts if needed."
    }

}