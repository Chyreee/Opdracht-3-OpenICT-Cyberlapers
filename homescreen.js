
const searchInput = document.getElementById("searchInput");

let allQuestions = [];

const commentList = document.getElementById("commentList");
const commentForm = document.getElementById("commentForm");
const commentInput = document.getElementById("commentInput");

commentForm.addEventListener("submit", event => {
    event.preventDefault();

    const text = commentInput.value.trim();
    if (text === "") return;

    const item = document.createElement("li");
    item.textContent = text;
    commentList.appendChild(item);

    commentInput.value = "";

});
const questionDialog = document.getElementById("questionDialog");
const dialogTitle = document.getElementById("dialogTitle");
const dialogMeta = document.getElementById("dialogMeta");
const dialogText = document.getElementById("dialogText");
const dialogCode = document.getElementById("dialogCode");
const closeDialogButton = document.getElementById("closeDialogButton");

function openQuestion(question) {
    commentList.innerHTML = "";
    commentInput.value = "";
    dialogTitle.textContent = question.title;
    dialogMeta.textContent = `${question.beroepsrol} - Year ${question.study_year}`;
    dialogText.textContent = question.question_text;
    dialogCode.textContent = question.code;

    questionDialog.showModal();
}

closeDialogButton.addEventListener("click", () => {
    questionDialog.close();
});

questionDialog.addEventListener("click", event => {
    if (event.target === questionDialog) {
        questionDialog.close();
    }
});


function displayQuestions(questions, questionsSection) {
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

                card.addEventListener("click", () => openQuestion(question));

        questionsSection.appendChild(card);
    });
}


// SEARCH FUNCTIONALITY

function filterQuestions() {
    const searchValue = searchInput.value.toLowerCase().trim();

    const filteredQuestions = allQuestions.filter(question =>
        question.title.toLowerCase().includes(searchValue) ||
        question.question_text.toLowerCase().includes(searchValue)
    );

    const questionsSection = document.querySelector(".questions");

    questionsSection.querySelectorAll(".question-card").forEach(card => {
        card.remove();
    });

    displayQuestions(filteredQuestions, questionsSection);
}


searchInput.addEventListener("input", filterQuestions);


// LOAD QUESTIONS

async function loadQuestions() {
    try {
        const response = await fetch("/api/questions");

        if (!response.ok) {
            throw new Error("Could not load questions.");
        }

        allQuestions = await response.json();

        console.log("Questions loaded:", allQuestions);

        const questionsSection = document.querySelector(".questions");

        questionsSection.querySelectorAll(".question-card").forEach(card => {
            card.remove();
        });

        displayQuestions(allQuestions, questionsSection);

    } catch (error) {
        console.error("Error loading questions:", error);
    }
}


// QUESTION FORM

const askQuestionButton = document.getElementById("askQuestionButton");
const questionForm = document.getElementById("questionForm");
const cancelQuestionButton = document.getElementById("cancelQuestionButton");
const formMessage = document.getElementById("formMessage");


askQuestionButton.addEventListener("click", () => {
    questionForm.hidden = false;
    formMessage.textContent = "";
});


cancelQuestionButton.addEventListener("click", () => {
    questionForm.hidden = true;
    questionForm.reset();
    formMessage.textContent = "";
});


questionForm.addEventListener("submit", async event => {
    event.preventDefault();

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
        const response = await fetch("/api/questions", {
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

        await loadQuestions();

    } catch (error) {
        console.error("Error submitting question:", error);
        formMessage.textContent = error.message || "Could not connect to the backend.";
    }
});


loadQuestions();