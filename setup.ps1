
$ErrorActionPreference = "Stop"

Write-Host "`n=== Code Sharing App Setup ===" -ForegroundColor Cyan

# 1. Check Python
Write-Host "`nChecking Python..."
python --version
if ($LASTEXITCODE -ne 0) {
    throw "Python is not installed or is not available in PATH."
}

# 2. Create virtual environment if needed
if (-not (Test-Path ".venv")) {
    Write-Host "`nCreating virtual environment..."
    python -m venv .venv

    if ($LASTEXITCODE -ne 0) {
        throw "Failed to create the virtual environment."
    }
} else {
    Write-Host "`nVirtual environment already exists."
}

# 3. Install required dependencies
Write-Host "`nChecking Python dependencies..."
& ".\.venv\Scripts\python.exe" -m pip install -r requirements.txt

if ($LASTEXITCODE -ne 0) {
    throw "Dependency installation failed."
}

# 4. Check dependencies
Write-Host "`nVerifying dependencies..."
& ".\.venv\Scripts\python.exe" -m pip check

if ($LASTEXITCODE -ne 0) {
    throw "Dependency check failed. No automatic repair will be attempted."
}

Write-Host "`nSetup complete!" -ForegroundColor Green
Write-Host "Next, start the database and run the SQL setup."
