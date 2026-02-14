# ==============================
# CONFIG
# ==============================
$REMOTE_NAME = "origin"
$REMOTE_URL  = "git@github.com:hdinceler/esp.git"
$BRANCH      = "main"

Write-Host "Git Otomatik Yolla Scripti"

# ==============================
# INIT REPO IF NEEDED
# ==============================
if (!(Test-Path ".git")) {
    Write-Host "Git repo yok -> git init"
    git init
    if ($LASTEXITCODE -ne 0) { exit 1 }
}
else {
    Write-Host "Git repo mevcut"
}

# ==============================
# REMOTE CHECK
# ==============================
$remoteExists = git remote | Select-String "^$REMOTE_NAME$"

if (!$remoteExists) {
    Write-Host "Remote ekleniyor: $REMOTE_URL"
    git remote add $REMOTE_NAME $REMOTE_URL
    if ($LASTEXITCODE -ne 0) { exit 1 }
}
else {
    Write-Host "Remote mevcut"
}

# ==============================
# BRANCH CHECK
# ==============================
$branchExists = git branch --list $BRANCH

if (!$branchExists) {
    Write-Host "Branch oluşturuluyor: $BRANCH"
    git checkout -b $BRANCH
}
else {
    git checkout $BRANCH
}

if ($LASTEXITCODE -ne 0) { exit 1 }

# ==============================
# ADD & COMMIT
# ==============================
git add .

git diff --cached --quiet
if ($LASTEXITCODE -eq 0) {
    Write-Host "Commit edilecek degisiklik yok"
}
else {
    $timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
    $COMMIT_MSG = "Auto commit: $timestamp"
    Write-Host "Commit atiliyor: $COMMIT_MSG"
    git commit -m "$COMMIT_MSG"
    if ($LASTEXITCODE -ne 0) { exit 1 }
}

# ==============================
# PUSH LOGIC
# ==============================
Write-Host "Push deneniyor..."

git push -u $REMOTE_NAME $BRANCH
if ($LASTEXITCODE -ne 0) {
    Write-Host "Normal push basarisiz -> force push deneniyor"
    git push -u $REMOTE_NAME $BRANCH --force
    if ($LASTEXITCODE -ne 0) { exit 1 }
}

Write-Host "Git push tamamlandi"
