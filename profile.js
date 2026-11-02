const username = localStorage.getItem("username");
document.getElementById("profileUsername").textContent = username;
const userId = localStorage.getItem("userId");
document.getElementById("profileUserId").textContent = userId;
console.log(userId);