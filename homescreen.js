
const searchInput = document.getElementById("searchInput");
const floorMapFrame = document.getElementById("floorMapFrame");

window.addEventListener("message", event => {
    if (event.source !== floorMapFrame.contentWindow) {
        return;
    }

    const isLocalFileMessage = window.location.protocol === "file:" && event.origin === "null";
    if (event.origin !== window.location.origin && !isLocalFileMessage) {
        return;
    }

    if (event.data?.type === "floor-map-open") {
        floorMapFrame.classList.add("is-expanded");
    } else if (event.data?.type === "floor-map-close") {
        floorMapFrame.classList.remove("is-expanded");
    }
});

let allQuestions = [];

const notificationSounds = {
    Question: "sounds/1.wav",
    Answer: "sounds/2.wav"
};
const decodedNotificationSounds = new Map();
let notificationAudioContext = null;

async function prepareNotificationSound(type) {
    const AudioContextClass = window.AudioContext || window.webkitAudioContext;

    if (!AudioContextClass) {
        console.warn("Audio notifications are not supported in this browser.");
        return null;
    }

    try {
        if (!notificationAudioContext) {
            notificationAudioContext = new AudioContextClass();
        }

        if (notificationAudioContext.state === "suspended") {
            await notificationAudioContext.resume();
        }

        if (!decodedNotificationSounds.has(type)) {
            const response = await fetch(notificationSounds[type]);
            if (!response.ok) {
                throw new Error(`Could not load ${notificationSounds[type]} (${response.status}).`);
            }

            const sound = await notificationAudioContext.decodeAudioData(
                await response.arrayBuffer()
            );
            decodedNotificationSounds.set(type, sound);
        }

        return decodedNotificationSounds.get(type);
    } catch (error) {
        console.warn(`Could not prepare the ${type.toLowerCase()} notification sound:`, error);
        return null;
    }
}

function playNotificationSound(sound) {
    if (!sound || !notificationAudioContext) {
        return;
    }

    try {
        const source = notificationAudioContext.createBufferSource();
        source.buffer = sound;
        source.connect(notificationAudioContext.destination);
        source.start();
    } catch (error) {
        console.warn("Could not play notification sound:", error);
    }
}

const commentList = document.getElementById("commentList");
const commentForm = document.getElementById("commentForm");
const commentInput = document.getElementById("commentInput");
let activeQuestionId = null;

function displayComment(comment) {
    const item = document.createElement("li");

    const author = document.createElement("strong");
    author.textContent = comment.username;

    const text = document.createElement("span");
    text.textContent = `: ${comment.comment_text}`;

    item.appendChild(author);
    item.appendChild(text);

    commentList.appendChild(item);
}


async function loadQuestionComments(questionId) {
    commentList.innerHTML = "";

    const loadingMessage = document.createElement("li");
    loadingMessage.textContent = "Loading comments...";
    commentList.appendChild(loadingMessage);

    try {
        const response = await fetch(
            `/api/questions/${questionId}/comments`
        );

        if (!response.ok) {
            throw new Error("Could not load comments.");
        }

        const comments = await response.json();

        // Make sure we're still viewing the same question.
        if (activeQuestionId !== questionId) return;

        commentList.innerHTML = "";

        if (comments.length === 0) {
            const emptyMessage = document.createElement("li");
            emptyMessage.textContent = "No comments yet.";
            commentList.appendChild(emptyMessage);
            return;
        }

        comments.forEach(displayComment);

    } catch (error) {
        console.error("Error loading comments:", error);

        if (activeQuestionId === questionId) {
            commentList.innerHTML = "";

            const errorMessage = document.createElement("li");
            errorMessage.textContent = "Could not load comments.";
            commentList.appendChild(errorMessage);
        }
    }
}

commentForm.addEventListener("submit", async event => {
    event.preventDefault();

    const text = commentInput.value.trim();

    if (text === "") return;

    const userId = localStorage.getItem("userId");

    if (!userId) {
        alert("Please log in before commenting.");
        return;
    }

    if (!activeQuestionId) {
        alert("No question selected.");
        return;
    }

    const questionId = activeQuestionId;
    const answerSound = prepareNotificationSound("Answer");

    try {
        const response = await fetch(
            `/api/questions/${questionId}/comments`,
            {
                method: "POST",
                headers: {
                    "Content-Type": "application/json"
                },
                body: JSON.stringify({
                    comment_text: text,
                    author_id: Number(userId)
                })
            }
        );

        const data = await response.json();

        if (!response.ok) {
            throw new Error(data.detail || "Could not submit comment.");
        }

        commentInput.value = "";

        // Reload comments from the database.
        if (activeQuestionId === questionId) {
            await loadQuestionComments(questionId);
        }

        void answerSound.then(playNotificationSound);

    } catch (error) {
        console.error("Error submitting comment:", error);
        alert(error.message || "Could not submit comment.");
    }
});
const questionDialog = document.getElementById("questionDialog");
const dialogTitle = document.getElementById("dialogTitle");
const dialogMeta = document.getElementById("dialogMeta");
const dialogText = document.getElementById("dialogText");
const dialogCode = document.getElementById("dialogCode");
const closeDialogButton = document.getElementById("closeDialogButton");

function openQuestion(question) {
    activeQuestionId = question.id;

    commentList.innerHTML = "";
    commentInput.value = "";

    dialogTitle.textContent = question.title;
    dialogMeta.textContent = `${question.beroepsrol} - Year ${question.study_year}`;
    dialogText.textContent = question.question_text;
    dialogCode.textContent = question.code;

    questionDialog.showModal();

    loadQuestionComments(question.id);
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

    const questionSound = prepareNotificationSound("Question");
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

        void questionSound.then(playNotificationSound);
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