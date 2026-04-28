$ErrorActionPreference = "Continue"

# we have 16 merged PRs, need 112 more for silver (128 total)
$totalNeeded = 112

for ($i = 1; $i -le $totalNeeded; $i++) {
    $branch = "shark-silver-$i"
    $paddedNum = $i.ToString("D3")
    
    Write-Host "--- silver grind $i/$totalNeeded ($(($i + 16))/128 total) ---"
    
    $null = git checkout master 2>&1
    $null = git pull origin master 2>&1
    $null = git checkout -b $branch 2>&1
    
    $content = "# silver catch #$i`n`nsilver tier grind.`ncatch $i of $totalNeeded`ntotal: $(($i + 16)) of 128`n"
    $null = New-Item -ItemType Directory -Force -Path "badges/pull-shark/silver"
    Set-Content -Path "badges/pull-shark/silver/catch-$paddedNum.md" -Value $content
    
    $null = git add . 2>&1
    $null = git commit -m "shark silver: catch #$i" 2>&1
    $null = git push origin $branch 2>&1
    
    $prUrl = gh pr create --repo compusophy/badge-farm --title "shark silver: catch #$i" --body "silver grind ($i/$totalNeeded)" --base master --head $branch 2>&1
    $prNum = ($prUrl -split '/')[-1]
    $null = gh pr merge $prNum --repo compusophy/badge-farm --merge --admin 2>&1
    
    if ($i % 10 -eq 0) {
        Write-Host "  >>> $i/$totalNeeded done ($(($i + 16))/128 total)"
    }
    
    Start-Sleep -Milliseconds 300
}

Write-Host "`n=== silver grind complete! ==="
Write-Host "total merged PRs: 128"
Write-Host "pull shark silver tier unlocked!"
