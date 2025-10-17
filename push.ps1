# =====================================
# push_update.ps1
# 自动将本地更改推送到 GitHub 远程仓库
# =====================================

Write-Host "🚀 开始推送本地更新到远程..." -ForegroundColor Cyan

# 检查是否是一个 Git 仓库
if (-not (Test-Path ".git")) {
    Write-Host "❌ 当前目录不是一个 Git 仓库！请进入项目根目录。" -ForegroundColor Red
    exit
}

# 获取当前分支名
$branch = git rev-parse --abbrev-ref HEAD
Write-Host "📂 当前分支: $branch" -ForegroundColor Yellow

# 显示当前状态
Write-Host "🔍 检查改动..."
git status

# 检查是否有改动
$changes = git status --porcelain
if (-not $changes) {
    Write-Host "✅ 没有检测到改动，本地已是最新版本。" -ForegroundColor Green
    exit
}

# 添加全部改动
Write-Host "📦 添加所有修改到暂存区..." -ForegroundColor Cyan
git add -A

# 自动生成提交信息
$timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
$commit_message = "Auto update at $timestamp"

Write-Host "📝 提交更改: $commit_message" -ForegroundColor Cyan
git commit -m "$commit_message"

# 推送到远程
Write-Host "⬆️ 推送到 GitHub (origin/$branch) ..." -ForegroundColor Cyan
git push origin $branch

if ($LASTEXITCODE -eq 0) {
    Write-Host "🎉 推送成功！本地更新已同步到远程。" -ForegroundColor Green
    git log -1 --oneline
} else {
    Write-Host "❌ 推送失败，请检查网络连接或远程仓库权限。" -ForegroundColor Red
}
