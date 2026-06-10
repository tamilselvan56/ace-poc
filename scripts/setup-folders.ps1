# Root folder for the ACE POC project
$RootFolder = "C:\ACEPOC"

Write-Host ""
Write-Host "Creating ACE POC folder structure..." -ForegroundColor Cyan
Write-Host ""

# List of folders to create
$Folders = @(
    "workspace",
    "ace-workdir",
    "bars",
    "mq",
    "scripts",
    "config",
    "tests",
    "tests\requests",
    "tests\postman",
    "cicd",
    "docs",
    "docs\evidence",
    "logs"
)

# Create the root folder if it does not exist
New-Item `
    -ItemType Directory `
    -Path $RootFolder `
    -Force | Out-Null

# Create every project folder
foreach ($Folder in $Folders) {

    $FullPath = Join-Path $RootFolder $Folder

    New-Item `
        -ItemType Directory `
        -Path $FullPath `
        -Force | Out-Null

    Write-Host "[CREATED] $FullPath" -ForegroundColor Green
}

Write-Host ""
Write-Host "ACE POC folder structure created successfully." `
    -ForegroundColor Green

Write-Host ""
Write-Host "Folder structure:" -ForegroundColor Yellow

cmd /c "tree C:\ACEPOC"