$ErrorActionPreference = "Stop"

# we already have 1 merged PR (yolo), need 15 more for bronze pull shark (16 total)
for ($i = 1; $i -le 15; $i++) {
    $branch = "pull-shark-$i"
    $paddedNum = $i.ToString("D2")
    
    Write-Host "--- PR $i/15 ---"
    
    # make sure we're on latest master
    git checkout master
    git pull origin master
    
    # create branch
    git checkout -b $branch
    
    # create a unique file
    $content = "# pull shark catch #$i`n`nthis PR exists to feed the pull shark.`n`ncatch number: $i of 15`n"
    $filePath = "badges/pull-shark/catch-$paddedNum.md"
    New-Item -ItemType Directory -Force -Path "badges/pull-shark" | Out-Null
    Set-Content -Path $filePath -Value $content
    
    git add .
    git commit -m "pull shark: catch #$i"
    git push origin $branch
    
    # create PR and merge it
    $prUrl = gh pr create --repo compusophy/badge-farm --title "pull shark: catch #$i" --body "feeding the shark ($i/15)" --base master --head $branch
    Write-Host "Created: $prUrl"
    
    # extract PR number and merge
    $prNum = ($prUrl -split '/')[-1]
    gh pr merge $prNum --repo compusophy/badge-farm --merge --admin
    Write-Host "Merged PR #$prNum"
    
    # small delay to avoid rate limiting
    Start-Sleep -Milliseconds 500
}

Write-Host "`n=== done! 15 PRs created and merged ==="
Write-Host "total merged PRs: 16 (1 yolo + 15 pull shark)"
Write-Host "pull shark bronze tier should be unlocked!"
