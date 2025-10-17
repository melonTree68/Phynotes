# ================================
# update_repo.ps1
# 自动更新本地仓库（包含PR合并后的同步）
# 适用于 PowerShell
# ================================

Write-Host "🔍 检查当前目录..." -ForegroundColor Cyan

# 确认这是一个 Git 仓库
if (-not (Test-Path ".git")) {
    Write-Host "❌ 当前目录不是一个 Git 仓库！请先进入项目根目录。" -ForegroundColor Red
    exit
}

# 获取当前分支
$branch = git rev-parse --abbrev-ref HEAD
Write-Host "📂 当前分支: $branch" -ForegroundColor Yellow

# 检查是否有未提交的更改
$changes = git status --porcelain

if ($changes) {
    Write-Host "⚠️ 检测到未提交的更改，自动暂存这些改动..." -ForegroundColor Yellow
    git stash push -m "Auto stash before update_repo.ps1"
} else {
    Write-Host "✅ 无本地更改，直接更新..." -ForegroundColor Green
}

# 拉取远程更新
Write-Host "⬇️ 从远程仓库获取更新..." -ForegroundColor Cyan
git fetch origin

Write-Host "🔁 合并远程分支 origin/$branch ..." -ForegroundColor Cyan
git pull --rebase origin $branch

if ($LASTEXITCODE -eq 0) {
    Write-Host "✅ 远程更新成功。" -ForegroundColor Green
} else {
    Write-Host "❌ 拉取失败，请检查冲突。" -ForegroundColor Red
    exit
}

# 尝试恢复暂存的更改
$stash_list = git stash list
if ($stash_list -match "Auto stash before update_repo.ps1") {
    Write-Host "💾 恢复之前暂存的更改..." -ForegroundColor Cyan
    git stash pop
}

Write-Host ""
Write-Host "🎉 仓库已更新完成！" -ForegroundColor Green
Write-Host "📘 当前最新提交：" -ForegroundColor Cyan
git log -1 --oneline
