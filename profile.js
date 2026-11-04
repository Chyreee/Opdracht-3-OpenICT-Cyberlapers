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

async function loadProfileQuestions() {
    const userId = localStorage.getItem("userId");
    const questionsContainer = document.getElementById("profileQuestions");

    try {
        const response = await fetch(`/api/users/${userId}/questions`);

        if (!response.ok) {
            throw new Error("Could not load questions");
        }

        const questions = await response.json();

        questionsContainer.innerHTML = "";

        if (questions.length === 0) {
            questionsContainer.textContent = "You haven't posted any questions yet.";
            return;
        }

        questions.forEach(question => {
            const questionElement = document.createElement("div");
            questionElement.classList.add("profile-question");

            const title = document.createElement("h3");
            title.textContent = question.title;

            const description = document.createElement("p");
            description.textContent = question.question_text;

            const date = document.createElement("small");
            date.textContent = new Date(question.created_at).toLocaleDateString();

            questionElement.appendChild(title);
            questionElement.appendChild(description);
            questionElement.appendChild(date);

            questionsContainer.appendChild(questionElement);
        });

    } catch (error) {
        console.error("Error loading profile questions:", error);
        questionsContainer.textContent = "Could not load your questions.";
    }
}

loadProfileQuestions();