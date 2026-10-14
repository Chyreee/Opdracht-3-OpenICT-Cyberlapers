let isRegistering = false;

function registreren() {
    isRegistering = true;
    document.getElementById("titel").innerHTML = "Signup";
    
    document.getElementById("knop").value = "Registreren";

    document.getElementById("tekst").innerHTML =
        'Heb je al een account? <a href="#" onclick="inloggen()">Inloggen</a>';
}

function inloggen() {
    isRegistering = false;
    document.getElementById("titel").innerHTML = "Login";

    document.getElementById("knop").value = "Inloggen";

    document.getElementById("tekst").innerHTML =
        'Nog geen account? <a href="#" onclick="registreren()">Registreren</a>';
}

document.getElementById("loginForm").addEventListener("submit", function(event) {
    event.preventDefault();

   fetch(
    isRegistering
        ? "http://127.0.0.1:8000/api/register"
        : "http://127.0.0.1:8000/api/login",
     {
        method: "post",
        headers:  {
            "Content-type": "application/json"
        },
        body: JSON.stringify({
            "username": document.getElementById("username").value,
            "password": document.getElementById("password").value
        })
   })
    .then(async response => {
    const data = await response.json();

    if (!response.ok) {
        alert(data.detail || "Something went wrong");
        return;
    }

    alert(data.message || "Request successful");
})
.catch(error => {
    console.error(error);
    alert("Could not connect to the backend");
});
});