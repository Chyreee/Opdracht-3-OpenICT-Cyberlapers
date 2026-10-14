
async function loadQuestions() {
    try {
        const response = await fetch("http://127.0.0.1:8000/api/questions");

        if (!response.ok) {
            throw new Error("Could not load questions.");
        }

        const questions = await response.json();
        const questionsSection = document.querySelector(".questions");

        // Remove old question cards before loading them again.
        questionsSection.querySelectorAll(".question-card").forEach(card => {
            card.remove();
        });

        questions.forEach(question => {
            const card = document.createElement("div");
            card.classList.add("question-card");

            const heading = document.createElement("h3");
            heading.classList.add("question-heading");
            heading.textContent = question.title;

            const description = document.createElement("p");
            description.textContent = question.question_text;

            const meta = document.createElement("div");
            meta.classList.add("question-meta");

            const role = document.createElement("span");
            role.textContent = question.beroepsrol;

            const year = document.createElement("span");
            year.textContent = `Year ${question.study_year}`;

            meta.appendChild(role);
            meta.appendChild(year);

            card.appendChild(heading);
            card.appendChild(description);
            card.appendChild(meta);

            questionsSection.appendChild(card);
        });
    } catch (error) {
        console.error("Error loading questions:", error);
    }
}

// Get the form elements.
const askQuestionButton = document.getElementById("askQuestionButton");
const questionForm = document.getElementById("questionForm");
const cancelQuestionButton = document.getElementById("cancelQuestionButton");
const formMessage = document.getElementById("formMessage");

// Open the form.
askQuestionButton.addEventListener("click", () => {
    questionForm.hidden = false;
    formMessage.textContent = "";
});

// Close the form and clear its fields.
cancelQuestionButton.addEventListener("click", () => {
    questionForm.hidden = true;
    questionForm.reset();
    formMessage.textContent = "";
});

// Submit a new question.
questionForm.addEventListener("submit", async event => {
    event.preventDefault();

    // Get the logged-in user's ID.
    const userId = localStorage.getItem("userId");

    if (!userId) {
        formMessage.textContent = "Please log in before submitting a question.";
        return;
    }

    const question = {
        title: document.getElementById("title").value.trim(),
        question_text: document.getElementById("questionText").value.trim(),
        code: document.getElementById("code").value,
        author_id: Number(userId),
        study_year: Number(document.getElementById("studyYear").value),
        beroepsrol: document.getElementById("beroepsrol").value
    };

    try {
        const response = await fetch("http://127.0.0.1:8000/api/questions", {
            method: "POST",
            headers: {
                "Content-Type": "application/json"
            },
            body: JSON.stringify(question)
        });

        const data = await response.json();

        if (!response.ok) {
            throw new Error(data.detail || "Could not submit question.");
        }

        alert("Question submitted successfully!");

        questionForm.reset();
        questionForm.hidden = true;

        // Reload the cards to display the new question.
        await loadQuestions();

    } catch (error) {
        console.error("Error submitting question:", error);
        formMessage.textContent = error.message || "Could not connect to the backend.";
    }
});

// Load existing questions when the homepage opens.
loadQuestions();
