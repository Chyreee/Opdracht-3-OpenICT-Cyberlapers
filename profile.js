const username = localStorage.getItem("username");
document.getElementById("profileUsername").textContent = username;
console.log(username);

const userId = localStorage.getItem("userId");
document.getElementById("profileUserId").textContent = userId;
console.log(userId)

const semester = localStorage.getItem("semester");
document.getElementById("profileSemester").textContent = semester;
console.log(semester);

const beroepsrol = localStorage.getItem("beroepsrol");
document.getElementById("profileBeroepsrol").textContent = beroepsrol;
console.log(beroepsrol);

pfpInput.addEventListener("change", function () {
    const file = this.files[0];

    if (!file) return;

    if (!file.type.startsWith("image/")) {
        alert("Please select an image.");
        return;
    }

    reader.readAsDataURL(file);
});
const logoutButton = document.getElementById("logoutButton");

logoutButton.addEventListener("click", () => {
    localStorage.removeItem("userId");
    window.location.href = "login.html";
});