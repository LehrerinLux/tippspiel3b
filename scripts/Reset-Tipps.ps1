# Define the path to the tipps.csv
$tippsPath = Join-Path $PSScriptRoot "..\tipps.csv"

# Import the CSV to get the data
$tipps = Import-Csv -Path $tippsPath -Delimiter ";" -Encoding UTF8

# Construct the file content manually to avoid quotes
$header = "Name;Punkte"
$lines = @($header)

foreach ($row in $tipps) {
    # We set Punkte to 0 here
    $lines += "$($row.Name);0"
}

# Save the lines to the file
$lines | Set-Content -Path $tippsPath -Encoding UTF8

Write-Host "All points have been reset to 0 in 'tipps.csv' (clean format)." -ForegroundColor Green