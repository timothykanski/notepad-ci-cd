$watcher = New-Object System.IO.FileSystemWatcher
$watcher.Path = (Get-Location).Path
$watcher.Filter = "*"
$watcher.NotifyFilter = [IO.NotifyFilters]'FileName, LastWrite, Size, Attributes, CreationTime'
$watcher.IncludeSubdirectories = $true
$watcher.EnableRaisingEvents = $true

function Trigger-Deploy($changeType, $changedFile){
    Start-Sleep -Milliseconds 100  # debounce
    
    $timestamp = Get-Date -Format 'HH:mm:ss'
    $commitMsg = "Auto-commit: $changedFile @ $timestamp"

    Write-Host "Detected: $changeType → $changedFile"

    Update-BlogManifest

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

function Update-BlogManifest {
    $blogDir = "blog"
    $manifest = @()
    $filesProcessed = 0
    $filesSkipped = 0

    Write-Host "Scanning for markdown files in '$blogDir'..."

    # Loop through all markdown files in /blog
    Get-ChildItem "$blogDir\*.md" | ForEach-Object {
      $file = $_.FullName
      $filename = $_.Name
      $slug = [System.IO.Path]::GetFileNameWithoutExtension($filename)

        
      Write-Host "`Processing file: $filename"

      try {
        $content = Get-Content $file -Raw

        # Extract YAML frontmatter
        if ($content -match "^---\s*([\s\S]*?)\s*---") {
            $metaBlock = $matches[1]
            Write-Host "Found YAML frontmatter block:"
            Write-Host $metaBlock

            $meta = @{}
            foreach ($line in $metaBlock -split "`n") {
                if ($line -match "^\s*(\w+)\s*:\s*(.+)$") {
                    $key = $matches[1]
                    $value = $matches[2].Trim()
                    $meta[$key] = $value
                    Write-Host "$key = $value"
                } else {
                  Write-Host "Skipping malformed line: '$line'"
                }
            }


          # Build entry
          $entry = [PSCustomObject]@{
            filename    = $filename
            slug        = $slug
            title       = $meta.title
            date        = $meta.date
            description = $meta.description
          }

          $manifest += $entry
          Write-Host "Added entry: $($entry | ConvertTo-Json -Compress)"
          $filesProcessed++
        } else {
          Write-Host "No YAML frontmatter found in $filename"
          $filesSkipped++
        }
      } catch {
        Write-Host "Error reading file ${filename}: $_"
        $filesSkipped++
      }
    }

    # Convert new manifest to JSON
    $newJson = ([System.Collections.ArrayList]$manifest | ConvertTo-Json -Depth 2 -Compress).Trim()

    # Read existing file (if it exists)
    $existingPath = "$blogDir\files.json"
    $oldJson = if (Test-Path $existingPath) {
        (Get-Content $existingPath -Raw).Trim()
    } else {
        ""
    }

    # Only write if different
    if ($newJson -ne $oldJson) {
        $newJson | Out-File $existingPath -Encoding utf8
        Write-Host "Blog manifest updated: $existingPath"
    } else {
        Write-Host "Blog manifest unchanged. Skipping file update."
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