// We assume the CSV is located at the root level, named tipps.csv
fetch('../tipps.csv')
.then(response => response.text())
.then(data => {
    // Split the file into rows
    const rows = data.split('\n');
    const students = [];

    // Loop through rows, skipping the header line (i = 1)
    for (let i = 1; i < rows.length; i++) {
        const row = rows[i].trim();
        if (row) {
            const columns = row.split(';'); // Split by your ; delimiter
            if (columns.length >= 2) {
                students.push({
                    name: columns[0].trim(),
                    points: parseInt(columns[1].trim(), 10) || 0
                });
            }
        }
    }

    // Sort students by points (highest to lowest)
    students.sort((a, b) => b.points - a.points);

    // Build the HTML
    const container = document.getElementById('leaderboard-container');
    let html = '';

    students.forEach((student, index) => {
        // Assign Medals
        let medal = '🏅';
        if (index === 0) medal = '🥇';
        else if (index === 1) medal = '🥈';
        else if (index === 2) medal = '🥉';

        // Grammar fix for "1 Punkt" vs "2 Punkte"
        const pointText = student.points === 1 ? 'Punkt' : 'Punkte';

        html += `
            <div class="kind-reihe">
                <span>${medal} ${index + 1}. ${student.name}</span>
                <span class="punkte-badge">${student.points} ${pointText}</span>
            </div>
        `;
    });

    // Put the newly created HTML onto the page
    container.innerHTML = html;
})
.catch(error => {
    console.error('Error loading CSV:', error);
    document.getElementById('leaderboard-container').innerHTML = 
        '<p style="text-align:center; color:red;">Fehler beim Laden der Daten. Bitte überprüfe die CSV-Datei!</p>';
});