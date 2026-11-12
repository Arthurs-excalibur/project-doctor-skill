# Project Doctor Installer & Uninstaller for Windows (PowerShell)
# Supports: Claude Code CLI, Cursor, Antigravity, and Agent Skills standard

param(
    [switch]$Global,
    [switch]$Project,
    [switch]$Uninstall
)

$RepoRawUrl = "https://raw.githubusercontent.com/Arthurs-excalibur/project-doctor-skill/main"
$SkillRelPath = "skills\project-doctor\SKILL.md"
$CursorRelPath = ".cursor\rules\project-doctor.mdc"
$Commands = @(".claude\commands\doctor.md", ".claude\commands\doctor-fix.md", ".claude\commands\doctor-deploy.md")

if ($Uninstall) {
    Write-Host "Uninstalling Project Doctor..." -ForegroundColor Yellow

    $claudeGlobal = Join-Path $HOME ".claude\skills\project-doctor"
    if (Test-Path $claudeGlobal) { Remove-Item -Recurse -Force $claudeGlobal }
    foreach ($cmd in $Commands) {
        $cmdGlobal = Join-Path $HOME $cmd
        if (Test-Path $cmdGlobal) { Remove-Item -Force $cmdGlobal }
    }

    $antigravityGlobal = Join-Path $HOME ".gemini\antigravity\skills\project-doctor"
    if (Test-Path $antigravityGlobal) { Remove-Item -Recurse -Force $antigravityGlobal }

    if (Test-Path ".git") {
        if (Test-Path ".claude\skills\project-doctor") { Remove-Item -Recurse -Force ".claude\skills\project-doctor" }
        foreach ($cmd in $Commands) {
            if (Test-Path $cmd) { Remove-Item -Force $cmd }
        }
        if (Test-Path ".gemini\skills\project-doctor") { Remove-Item -Recurse -Force ".gemini\skills\project-doctor" }
        if (Test-Path ".cursor\rules\project-doctor.mdc") { Remove-Item -Force ".cursor\rules\project-doctor.mdc" }
    }

    Write-Host "[OK] Project Doctor has been removed." -ForegroundColor Green
    return
}

if (-not $Global -and -not $Project) {
    $Global = $true
    $Project = $true
}

Write-Host "Installing Project Doctor..." -ForegroundColor Cyan

function Copy-Or-DownloadFile {
    param(
        [string]$RelativePath,
        [string]$DestinationPath
    )
    $destDir = Split-Path -Parent $DestinationPath
    if (-not (Test-Path $destDir)) {
        New-Item -ItemType Directory -Path $destDir -Force | Out-Null
    }
    if (Test-Path $RelativePath) {
        Copy-Item -Path $RelativePath -Destination $DestinationPath -Force
    } else {
        $url = "$RepoRawUrl/" + ($RelativePath -replace '\\', '/')
        Invoke-WebRequest -Uri $url -OutFile $DestinationPath
    }
}

# 1. Claude Code CLI Global
if ($Global) {
    $claudeGlobal = Join-Path $HOME ".claude\skills\project-doctor\SKILL.md"
    Copy-Or-DownloadFile -RelativePath $SkillRelPath -DestinationPath $claudeGlobal
    Write-Host "  [OK] Claude Code (Global): $claudeGlobal" -ForegroundColor Green
    foreach ($cmd in $Commands) {
        $cmdDest = Join-Path $HOME $cmd
        Copy-Or-DownloadFile -RelativePath $cmd -DestinationPath $cmdDest
        Write-Host "  [OK] Claude Code (Global): $cmdDest" -ForegroundColor Green
    }
}

# 2. Antigravity Global
if ($Global) {
    $antigravityGlobal = Join-Path $HOME ".gemini\antigravity\skills\project-doctor\SKILL.md"
    Copy-Or-DownloadFile -RelativePath $SkillRelPath -DestinationPath $antigravityGlobal
    Write-Host "  [OK] Antigravity (Global): $antigravityGlobal" -ForegroundColor Green
}

# 3. Project-level install
if ($Project -and (Test-Path ".git")) {
    $localClaude = ".claude\skills\project-doctor\SKILL.md"
    Copy-Or-DownloadFile -RelativePath $SkillRelPath -DestinationPath $localClaude
    Write-Host "  [OK] Current Project (.claude/skills): $localClaude" -ForegroundColor Green
    foreach ($cmd in $Commands) {
        Copy-Or-DownloadFile -RelativePath $cmd -DestinationPath $cmd
        Write-Host "  [OK] Current Project: $cmd" -ForegroundColor Green
    }
    $localCursor = ".cursor\rules\project-doctor.mdc"
    Copy-Or-DownloadFile -RelativePath $CursorRelPath -DestinationPath $localCursor
    Write-Host "  [OK] Current Project (.cursor/rules): $localCursor" -ForegroundColor Green
    $localAntigravity = ".gemini\skills\project-doctor\SKILL.md"
    Copy-Or-DownloadFile -RelativePath $SkillRelPath -DestinationPath $localAntigravity
    Write-Host "  [OK] Current Project (.gemini/skills): $localAntigravity" -ForegroundColor Green
}

Write-Host "`nInstallation complete. You can now use Project Doctor in your AI prompts." -ForegroundColor Cyan
Write-Host "Claude Code users: type /doctor, /doctor-fix, or /doctor-deploy." -ForegroundColor Gray
