Write-Host ""
Write-Host "========================================" -ForegroundColor Cyan
Write-Host " ACE POC Prerequisite Check" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

# Function to check whether a command exists
function Test-RequiredCommand {

    param (
        [string]$CommandName,
        [string]$DisplayName
    )

    $Command = Get-Command $CommandName -ErrorAction SilentlyContinue

    if ($Command) {
        Write-Host "[OK] $DisplayName found" -ForegroundColor Green
        Write-Host "     Location: $($Command.Source)"
        return $true
    }
    else {
        Write-Host "[MISSING] $DisplayName not found" `
            -ForegroundColor Red
        return $false
    }
}

# Function to check whether a port is currently listening
function Test-LocalPort {

    param (
        [int]$Port
    )

    $Connection = Get-NetTCPConnection `
        -LocalPort $Port `
        -State Listen `
        -ErrorAction SilentlyContinue

    if ($Connection) {
        Write-Host "[LISTENING] Port $Port is currently in use" `
            -ForegroundColor Green

        foreach ($Item in $Connection) {
            Write-Host "            Process ID: $($Item.OwningProcess)"
        }
    }
    else {
        Write-Host "[FREE] Port $Port is not currently listening" `
            -ForegroundColor Yellow
    }
}

Write-Host "1. Checking Git" -ForegroundColor Cyan

$GitAvailable = Test-RequiredCommand `
    -CommandName "git" `
    -DisplayName "Git"

if ($GitAvailable) {
    $GitVersion = git --version
    Write-Host "     Version: $GitVersion"
}

Write-Host ""
Write-Host "2. Checking Java" -ForegroundColor Cyan

$JavaAvailable = Test-RequiredCommand `
    -CommandName "java" `
    -DisplayName "Java"

if ($JavaAvailable) {
    $JavaVersion = & java -version 2>&1 | Select-Object -First 1
    Write-Host "     Version: $JavaVersion"
}

Write-Host ""
Write-Host "3. Checking IBM ACE commands" -ForegroundColor Cyan

$ACEAvailable = Test-RequiredCommand `
    -CommandName "mqsilist" `
    -DisplayName "IBM ACE mqsilist command"

Test-RequiredCommand `
    -CommandName "mqsicreateworkdir" `
    -DisplayName "IBM ACE mqsicreateworkdir command"

Write-Host ""
Write-Host "4. Checking IBM MQ commands" -ForegroundColor Cyan

Test-RequiredCommand `
    -CommandName "dspmq" `
    -DisplayName "IBM MQ dspmq command"

Test-RequiredCommand `
    -CommandName "runmqsc" `
    -DisplayName "IBM MQ runmqsc command"

Write-Host ""
Write-Host "5. Checking required ports" -ForegroundColor Cyan
Write-Host ""

$Ports = @(7600, 7800, 1414, 8080)

foreach ($Port in $Ports) {
    Test-LocalPort -Port $Port
}

Write-Host ""
Write-Host "========================================" -ForegroundColor Cyan
Write-Host " Prerequisite check completed" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

Write-Host "Port reference:" -ForegroundColor Yellow
Write-Host "7600 - ACE-related port, depending on your configuration"
Write-Host "7800 - ACE HTTP Input or REST API port"
Write-Host "1414 - IBM MQ queue manager listener port"
Write-Host "8080 - Jenkins or another web application port"
Write-Host ""