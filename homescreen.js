
async function loadQuestions() {
    const response = await fetch("http://127.0.0.1:8000/api/questions");

    const questions = await response.json();

    const questionsSection = document.querySelector(".questions");

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
}

loadQuestions();
