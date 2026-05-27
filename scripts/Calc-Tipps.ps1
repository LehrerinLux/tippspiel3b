# Define the paths based on the script's location
$gamesPath = Join-Path $PSScriptRoot "..\games.csv"
$betsPath  = Join-Path $PSScriptRoot "..\bets.csv"
$tippsPath = Join-Path $PSScriptRoot "..\tipps.csv"

# Current date to check for past games
$currentDate = Get-Date

# Import the CSV files
$games = Import-Csv -Path $gamesPath -Delimiter ";" -Encoding UTF8
$bets  = Import-Csv -Path $betsPath -Delimiter ";" -Encoding UTF8
$tipps = Import-Csv -Path $tippsPath -Delimiter ";" -Encoding UTF8

# Iterate through existing tipps to preserve the exact order of names
foreach ($tipp in $tipps) {
    $name = $tipp.Name
    $points = 0

    # Find the bet entry for the current participant
    $userBet = $bets | Where-Object { $_.Name -eq $name }
    
    if ($userBet) {
        foreach ($game in $games) {
            $gameDate = [datetime]$game.Datum
            
            # Only process games in the past
            if ($gameDate -lt $currentDate) {
                $gameName = $game.Spiel
                $result = $game.Ergebnis
                
                # Get the column value for this specific game
                $betColumn = "Wette($gameName)"
                $bet = $userBet.$betColumn
                
                if (-not [string]::IsNullOrWhiteSpace($bet) -and -not [string]::IsNullOrWhiteSpace($result)) {
                    $rSplit = $result -split ":"
                    $bSplit = $bet -split ":"
                    
                    if ($rSplit.Count -eq 2 -and $bSplit.Count -eq 2) {
                        $rHome = [int]$rSplit[0]
                        $rAway = [int]$rSplit[1]
                        $bHome = [int]$bSplit[0]
                        $bAway = [int]$bSplit[1]
                        
                        # 3 Points: Exact result
                        if ($rHome -eq $bHome -and $rAway -eq $bAway) {
                            $points += 3
                        }
                        # 1 Point: Correct tendency (Winner or Draw)
                        elseif (($rHome -gt $rAway -and $bHome -gt $bAway) -or 
                                ($rHome -lt $rAway -and $bHome -lt $bAway) -or 
                                ($rHome -eq $rAway -and $bHome -eq $bAway)) {
                            $points += 1
                        }
                    }
                }
            }
        }
    }
    
    # Update the points for the participant
    $tipp.Punkte = $points
}

# Export the updated points back to the tipps.csv without altering the structure
$tipps | Export-Csv -Path $tippsPath -Delimiter ";" -NoTypeInformation -Encoding UTF8

Write-Host "Points calculated successfully. 'tipps.csv' has been updated." -ForegroundColor Green