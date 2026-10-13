function registreren() {
    document.getElementById("titel").innerHTML = "Signup";
    
    document.getElementById("knop").value = "Registreren";

    document.getElementById("tekst").innerHTML =
        'Heb je al een account? <a href="#" onclick="inloggen()">Inloggen</a>';
}

function inloggen() {
    document.getElementById("titel").innerHTML = "Login";

    document.getElementById("knop").value = "Inloggen";

    document.getElementById("tekst").innerHTML =
        'Nog geen account? <a href="#" onclick="registreren()">Registreren</a>';
}