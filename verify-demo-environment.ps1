# Demo Environment Verification Script
# Run this script before the GitHub Copilot demo to ensure everything is configured correctly

param(
    [switch]$Verbose
)

$ErrorActionPreference = "Continue"
$script:FailureCount = 0
$script:WarningCount = 0
$script:SuccessCount = 0

function Write-TestResult {
    param(
        [string]$TestName,
        [string]$Status,  # "Success", "Warning", "Failed"
        [string]$Message
    )
    
    $icon = switch ($Status) {
        "Success" { "✅"; $script:SuccessCount++ }
        "Warning" { "⚠️ "; $script:WarningCount++ }
        "Failed"  { "❌"; $script:FailureCount++ }
    }
    
    Write-Host "$icon $TestName" -ForegroundColor $(
        switch ($Status) {
            "Success" { "Green" }
            "Warning" { "Yellow" }
            "Failed"  { "Red" }
        }
    )
    
    if ($Message) {
        Write-Host "   $Message" -ForegroundColor Gray
    }
}

function Test-CommandExists {
    param([string]$Command)
    $null -ne (Get-Command $Command -ErrorAction SilentlyContinue)
}

Write-Host "`n============================================" -ForegroundColor Cyan
Write-Host "GitHub Copilot Demo - Environment Verification" -ForegroundColor Cyan
Write-Host "============================================`n" -ForegroundColor Cyan

# Test 1: Git
Write-Host "[1/15] Checking Git..." -ForegroundColor Cyan
if (Test-CommandExists "git") {
    $gitVersion = git --version
    Write-TestResult "Git installed" "Success" "$gitVersion"
} else {
    Write-TestResult "Git not found" "Failed" "Install Git from https://git-scm.com/"
}

# Test 2: .NET SDK
Write-Host "`n[2/15] Checking .NET SDK..." -ForegroundColor Cyan
if (Test-CommandExists "dotnet") {
    $dotnetVersion = dotnet --version
    $majorVersion = [int]($dotnetVersion -split '\.')[0]
    
    if ($majorVersion -ge 8) {
        Write-TestResult ".NET SDK installed" "Success" "Version: $dotnetVersion"
    } else {
        Write-TestResult ".NET SDK version too old" "Warning" "Found $dotnetVersion, recommend 8.0+"
    }
} else {
    Write-TestResult ".NET SDK not found" "Failed" "Install from https://dot.net/"
}

# Test 3: SQL Server LocalDB
Write-Host "`n[3/15] Checking SQL Server LocalDB..." -ForegroundColor Cyan
try {
    $sqlcmd = Get-Command SqlLocalDB -ErrorAction Stop
    $instances = SqlLocalDB info
    if ($instances -contains "MSSQLLocalDB") {
        Write-TestResult "SQL Server LocalDB found" "Success" "MSSQLLocalDB instance available"
    } else {
        Write-TestResult "LocalDB instance missing" "Warning" "MSSQLLocalDB instance not found"
    }
} catch {
    Write-TestResult "SQL Server LocalDB not found" "Failed" "Install SQL Server Express with LocalDB"
}

# Test 4: Node.js
Write-Host "`n[4/15] Checking Node.js..." -ForegroundColor Cyan
if (Test-CommandExists "node") {
    $nodeVersion = node --version
    Write-TestResult "Node.js installed" "Success" "$nodeVersion"
} else {
    Write-TestResult "Node.js not found" "Failed" "Install from https://nodejs.org/"
}

# Test 5: npm
Write-Host "`n[5/15] Checking npm..." -ForegroundColor Cyan
if (Test-CommandExists "npm") {
    $npmVersion = npm --version
    Write-TestResult "npm installed" "Success" "Version: $npmVersion"
} else {
    Write-TestResult "npm not found" "Failed" "npm comes with Node.js"
}

# Test 6: Current Directory
Write-Host "`n[6/15] Checking current directory..." -ForegroundColor Cyan
$currentPath = Get-Location
if (Test-Path "ContosoUniversity.sln") {
    Write-TestResult "Correct directory" "Success" "Found ContosoUniversity.sln"
} else {
    Write-TestResult "Wrong directory" "Failed" "Navigate to repository root containing ContosoUniversity.sln"
}

# Test 7: Git Branch
Write-Host "`n[7/15] Checking Git branches..." -ForegroundColor Cyan
try {
    $branches = git branch -a 2>&1
    if ($branches -match "local-testing") {
        Write-TestResult "local-testing branch exists" "Success" "Demo starting point available"
    } else {
        Write-TestResult "local-testing branch missing" "Warning" "May need to fetch from remote"
    }
} catch {
    Write-TestResult "Cannot check Git branches" "Warning" "Ensure you're in a Git repository"
}

# Test 8: Solution Restore
Write-Host "`n[8/15] Testing dotnet restore..." -ForegroundColor Cyan
$restoreOutput = dotnet restore .\ContosoUniversity.sln 2>&1
if ($LASTEXITCODE -eq 0) {
    Write-TestResult "NuGet packages restored" "Success" "All dependencies available"
} else {
    Write-TestResult "Restore failed" "Failed" "Check NuGet configuration and internet connection"
}

# Test 9: Solution Build
Write-Host "`n[9/15] Testing dotnet build..." -ForegroundColor Cyan
$buildOutput = dotnet build .\ContosoUniversity.sln -c Debug 2>&1
if ($LASTEXITCODE -eq 0) {
    Write-TestResult "Solution builds successfully" "Success" "No compilation errors"
} else {
    Write-TestResult "Build failed" "Failed" "Check build output for errors"
}

# Test 10: Custom Instructions
Write-Host "`n[10/15] Checking custom instructions..." -ForegroundColor Cyan
$instructionsPath = "ContosoUniversity\.github\instructions\dotnet-architecture-best-practices.instructions.md"
if (Test-Path $instructionsPath) {
    Write-TestResult "Custom instructions found" "Success" "$instructionsPath"
} else {
    Write-TestResult "Custom instructions missing" "Failed" "Create .github/instructions/ folder with instruction files"
}

# Test 11: Custom Agents
Write-Host "`n[11/15] Checking custom agents..." -ForegroundColor Cyan
$agentsPath = "ContosoUniversity\.github\agents"
if (Test-Path $agentsPath) {
    $agentFiles = Get-ChildItem "$agentsPath\*.json" -ErrorAction SilentlyContinue
    if ($agentFiles.Count -gt 0) {
        Write-TestResult "Custom agents found" "Success" "$($agentFiles.Count) agent(s) configured"
    } else {
        Write-TestResult "No agent JSON files" "Warning" "Create agent configuration files"
    }
} else {
    Write-TestResult "Agents folder missing" "Warning" "Create .github/agents/ folder"
}

# Test 12: Demo Documentation
Write-Host "`n[12/15] Checking demo documentation..." -ForegroundColor Cyan
$demoGuide = "DEMO_INSTRUCTOR_GUIDE.md"
$quickRef = "DEMO_QUICK_REFERENCE.md"

$docsFound = 0
if (Test-Path $demoGuide) { $docsFound++ }
if (Test-Path $quickRef) { $docsFound++ }

if ($docsFound -eq 2) {
    Write-TestResult "Demo documentation complete" "Success" "All guides available"
} elseif ($docsFound -eq 1) {
    Write-TestResult "Demo documentation incomplete" "Warning" "Some guides missing"
} else {
    Write-TestResult "Demo documentation missing" "Failed" "Create DEMO_INSTRUCTOR_GUIDE.md"
}

# Test 13: Playwright Tests
Write-Host "`n[13/15] Checking Playwright tests..." -ForegroundColor Cyan
$playwrightPath = "ContosoUniversity\ContosoUniversity.PlaywrightTests"
if (Test-Path $playwrightPath) {
    Push-Location $playwrightPath
    if (Test-Path "package.json") {
        Write-TestResult "Playwright project found" "Success" "E2E tests available"
        
        # Check if node_modules exists
        if (Test-Path "node_modules") {
            Write-TestResult "Playwright dependencies installed" "Success" "node_modules folder exists"
        } else {
            Write-TestResult "Playwright dependencies not installed" "Warning" "Run 'npm install' in PlaywrightTests folder"
        }
    } else {
        Write-TestResult "Playwright not configured" "Warning" "Missing package.json"
    }
    Pop-Location
} else {
    Write-TestResult "Playwright tests folder missing" "Warning" "E2E tests not available"
}

# Test 14: Run Tests (check for intentional failure)
Write-Host "`n[14/15] Running test suite (checking for intentional failure)..." -ForegroundColor Cyan
$testOutput = dotnet test .\ContosoUniversity.sln -c Debug --logger "console;verbosity=quiet" 2>&1
$testResultString = $testOutput -join "`n"

if ($testResultString -match "StudentsControllerTests\.Index_ReturnsViewWithPaginatedList") {
    Write-TestResult "Intentional test failure detected" "Success" "Demo test is failing as expected"
} else {
    Write-TestResult "Expected test failure not found" "Warning" "The demo assumes Index_ReturnsViewWithPaginatedList test fails"
}

# Test 15: VS Code
Write-Host "`n[15/15] Checking VS Code..." -ForegroundColor Cyan
if (Test-CommandExists "code") {
    Write-TestResult "VS Code CLI available" "Success" "Can open project with 'code .'"
} else {
    Write-TestResult "VS Code CLI not in PATH" "Warning" "Install VS Code or add to PATH"
}

# Summary
Write-Host "`n============================================" -ForegroundColor Cyan
Write-Host "Verification Complete" -ForegroundColor Cyan
Write-Host "============================================`n" -ForegroundColor Cyan

Write-Host "✅ Passed: $script:SuccessCount" -ForegroundColor Green
Write-Host "⚠️  Warnings: $script:WarningCount" -ForegroundColor Yellow
Write-Host "❌ Failed: $script:FailureCount" -ForegroundColor Red

Write-Host "`n"

if ($script:FailureCount -eq 0 -and $script:WarningCount -eq 0) {
    Write-Host "🎉 Environment is ready for the demo!" -ForegroundColor Green
    Write-Host "`nNext steps:" -ForegroundColor Cyan
    Write-Host "1. Open VS Code: code ." -ForegroundColor White
    Write-Host "2. Review DEMO_INSTRUCTOR_GUIDE.md" -ForegroundColor White
    Write-Host "3. Create demo branch: git checkout -b demo/copilot-capabilities" -ForegroundColor White
} elseif ($script:FailureCount -eq 0) {
    Write-Host "⚠️  Environment has warnings but should work for demo" -ForegroundColor Yellow
    Write-Host "`nReview warnings above and address if needed." -ForegroundColor White
} else {
    Write-Host "❌ Environment has critical issues that must be fixed" -ForegroundColor Red
    Write-Host "`nAddress failed checks above before proceeding." -ForegroundColor White
}

Write-Host "`n"
