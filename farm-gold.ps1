$ErrorActionPreference = "Continue"

# we have 128 merged PRs, need 896 more for gold (1024 total)
$totalNeeded = 896

for ($i = 1; $i -le $totalNeeded; $i++) {
    $branch = "shark-gold-$i"
    $paddedNum = $i.ToString("D4")
    
    Write-Host "--- gold grind $i/$totalNeeded ($(($i + 128))/1024 total) ---"
    
    $null = git checkout master 2>&1
    $null = git pull origin master 2>&1
    $null = git checkout -b $branch 2>&1
    
    $content = "# gold catch #$i`n`ngold tier grind.`ncatch $i of $totalNeeded`ntotal: $(($i + 128)) of 1024`n"
    $null = New-Item -ItemType Directory -Force -Path "badges/pull-shark/gold"
    Set-Content -Path "badges/pull-shark/gold/catch-$paddedNum.md" -Value $content
    
    $null = git add . 2>&1
    $null = git commit -m "shark gold: catch #$i" 2>&1
    $null = git push origin $branch 2>&1
    
    $prUrl = gh pr create --repo compusophy/badge-farm --title "shark gold: catch #$i" --body "gold grind ($i/$totalNeeded)" --base master --head $branch 2>&1
    $prNum = ($prUrl -split '/')[-1]
    $null = gh pr merge $prNum --repo compusophy/badge-farm --merge --admin 2>&1
    
    if ($i % 50 -eq 0) {
        Write-Host "  >>> $i/$totalNeeded done ($(($i + 128))/1024 total)"
    }
    
    Start-Sleep -Milliseconds 300
}

Write-Host "`n=== gold grind complete! ==="
Write-Host "total merged PRs: 1024"
Write-Host "pull shark gold tier unlocked!"
