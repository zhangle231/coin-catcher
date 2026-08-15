# Godot Test Runner - PowerShell Script
# Run this to execute all tests for the Coin Catcher project

$GodotPath = "C:\Users\Administrator\Godot\Godot_v4.7.1-stable_win64_console.exe"
$ProjectPath = $PSScriptRoot
$TestDir = Join-Path $ProjectPath "tests"
$ResultDir = Join-Path $ProjectPath "test_results"

Write-Host "========================================" -ForegroundColor Cyan
Write-Host "  Coin Catcher - GUT Test Runner" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

# Check Godot installation
if (-not (Test-Path $GodotPath)) {
    Write-Host "ERROR: Godot not found at: $GodotPath" -ForegroundColor Red
    exit 1
}
Write-Host "Godot: $GodotPath" -ForegroundColor Green

# Check project
if (-not (Test-Path (Join-Path $ProjectPath "project.godot"))) {
    Write-Host "ERROR: project.godot not found" -ForegroundColor Red
    exit 1
}
Write-Host "Project: $ProjectPath" -ForegroundColor Green

# Check GUT
if (-not (Test-Path (Join-Path $ProjectPath "addons\gut\gut_cmdln.gd"))) {
    Write-Host "ERROR: GUT not found in addons/" -ForegroundColor Red
    exit 1
}
Write-Host "GUT: OK" -ForegroundColor Green
Write-Host ""

# Create results directory
New-Item -ItemType Directory -Path $ResultDir -Force | Out-Null

# Find all test scripts
$TestScripts = Get-ChildItem -Path $TestDir -Recurse -Filter "*_test.gd" | ForEach-Object { $_.FullName }
if ($TestScripts.Count -eq 0) {
    Write-Host "ERROR: No test scripts found in $TestDir" -ForegroundColor Red
    exit 1
}
Write-Host "Found $($TestScripts.Count) test script(s)" -ForegroundColor Green
Write-Host ""

# Run tests
Write-Host "Running tests..." -ForegroundColor Yellow
Write-Host ""

$Args = @("--headless", "--path", $ProjectPath, "-s", "res://addons/gut/gut_cmdln.gd")
foreach ($Script in $TestScripts) {
    # Convert full path to relative path for GUT
    $RelPath = $Script.Replace($ProjectPath + "\", "").Replace("\", "/")
    $Args += @("-gtest=$RelPath")
}
$Args += @("-gexit")

$Process = Start-Process -FilePath $GodotPath -ArgumentList $Args -NoNewWindow -Wait -PassThru

$ExitCode = $Process.ExitCode

Write-Host ""
Write-Host "Exit code: $ExitCode" -ForegroundColor $(if ($ExitCode -eq 0) { 'Green' } else { 'Red' })

exit $ExitCode
