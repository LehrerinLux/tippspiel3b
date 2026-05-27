# Define the input and output paths
$klarnamenPath = Join-Path $PSScriptRoot "..\klarnamen.csv"
$betsPath = Join-Path $PSScriptRoot "..\bets.csv"

# Import data
$data = Import-Csv -Path $klarnamenPath -Delimiter ";" -Encoding UTF8

# Get all column headers except the first one ('Klarname')
$allHeaders = $data[0].PSObject.Properties.Name
$dynamicHeaders = $allHeaders | Where-Object { $_ -ne "Klarname" }

# Build the header string dynamically (e.g., "Name;Wette(DEU-CUW);...")
$headerLine = $dynamicHeaders -join ";"
$lines = @($headerLine)

# Build the data rows dynamically
foreach ($row in $data) {
    $rowValues = foreach ($header in $dynamicHeaders) {
        $row.$header
    }
    $lines += ($rowValues -join ";")
}

# Save the lines to bets.csv without quotes
$lines | Set-Content -Path $betsPath -Encoding UTF8

Write-Host "bets.csv created successfully with dynamic columns." -ForegroundColor Green