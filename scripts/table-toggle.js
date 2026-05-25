function toggleTable(sectionId) {
    var section = document.getElementById(sectionId);
    if (section.style.display === "none") {
        section.style.display = "table-row-group";
    } else {
        section.style.display = "none";
    }
}
