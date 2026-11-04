let isRegistering = false;

function registreren() {
    isRegistering = true;
    document.getElementById("titel").innerHTML = "Signup";
    document.getElementById("knop").value = "Registreren";

    document.getElementById("studyYear").style.display = "block";
    document.getElementById("beroepsrol").style.display = "block";
    document.getElementById("studyYearInput").required = true;
    document.getElementById("beroepsrolInput").required = true;

    document.getElementById("tekst").innerHTML =
        'Heb je al een account? <a href="#" onclick="inloggen()">Inloggen</a>';
}

function inloggen() {
    isRegistering = false;
    document.getElementById("titel").innerHTML = "Login";
    document.getElementById("knop").value = "Inloggen";

    document.getElementById("studyYear").style.display = "none";
    document.getElementById("beroepsrol").style.display = "none";
    document.getElementById("studyYearInput").required = false;
    document.getElementById("beroepsrolInput").required = false;

    document.getElementById("tekst").innerHTML =
        'Nog geen account? <a href="#" onclick="registreren()">Registreren</a>';
}

document.getElementById("loginForm").addEventListener("submit", function(event) {
    event.preventDefault();

    const body = {
        username: document.getElementById("username").value,
        password: document.getElementById("password").value
    };


    if (isRegistering) {
        body.studyYear = document.getElementById("studyYearInput").value;
        body.beroepsrol = document.getElementById("beroepsrolInput").value;
    }

    fetch(isRegistering ? "/api/register" : "/api/login", {
        method: "post",
        headers: { "Content-type": "application/json" },
        body: JSON.stringify(body)
    })
    .then(async response => {
        const data = await response.json();

        if (!response.ok) {
            alert(data.detail || "Something went wrong");
            return;
        }


        localStorage.setItem("userId", data.id);
        localStorage.setItem("username", data.username);


        window.location.href = "homescreen.html";
    })
    .catch(error => {
        console.error(error);
        alert("Could not connect to the backend");
    });
});