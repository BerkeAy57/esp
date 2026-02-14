$REPO_URL="https://github.com/BerkeAy57/esp.git"
$BRANCH="main"

if (!(Test-Path ".git")) {
    Write-Host "Git repo yok. Oluşturuluyor..."
    git init
    git branch -M $BRANCH
    git remote add origin $REPO_URL
}
else {
    Write-Host "Git repo mevcut."
}

git add .

if (git diff --cached --quiet) {
    Write-Host "Değişiklik yok."
} else {
    git commit -m "Otomatik commit - $(Get-Date)"
}

git pull origin $BRANCH --rebase
git push -u origin $BRANCH

Write-Host "İşlem tamam 🚀"
