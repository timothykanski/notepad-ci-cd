$watcher = New-Object System.IO.FileSystemWatcher
$watcher.Path = (Get-Location).Path
$watcher.Filter = "index.html"
$watcher.EnableRaisingEvents = $true

Register-ObjectEvent $watcher 'Changed' -Action {
  Start-Sleep -Milliseconds 100 # debounce
  git add .
  git commit -m "Auto-commit from Notepad"
  git push
  Write-Host "✅ Deployed from Notepad"
}
