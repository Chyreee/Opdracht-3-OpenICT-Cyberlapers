
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

commentForm.addEventListener("submit", event => {
    event.preventDefault();

    const text = commentInput.value.trim();
    if (text === "") return;

    const answerSound = prepareNotificationSound("Answer");
    const item = document.createElement("li");
    item.textContent = text;
    commentList.appendChild(item);

    commentInput.value = "";
    void answerSound.then(playNotificationSound);
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

        const voteControls = document.createElement("div");
        voteControls.classList.add("question-votes");
        voteControls.setAttribute("aria-label", "Vote on this question");

        const voteMessage = document.createElement("span");
        voteMessage.classList.add("vote-message");
        voteMessage.setAttribute("role", "status");

        const upvoteButton = createVoteButton(
            "up",
            question.upvotes ?? 0,
            question.user_vote === "up",
            question.id
        );
        const downvoteButton = createVoteButton(
            "down",
            question.downvotes ?? 0,
            question.user_vote === "down",
            question.id
        );

        voteControls.append(upvoteButton, downvoteButton, voteMessage);

        card.appendChild(heading);
        card.appendChild(description);
        card.appendChild(meta);
        card.appendChild(voteControls);

        card.addEventListener("click", () => openQuestion(question));

        questionsSection.appendChild(card);
    });
}

function createVoteButton(type, count, isSelected, questionId) {
    const button = document.createElement("button");
    const image = document.createElement("img");
    const countLabel = document.createElement("span");
    const isUpvote = type === "up";
    const label = isUpvote ? "Upvote" : "Downvote";

    button.type = "button";
    button.classList.add("vote-button", `${type}vote-button`);
    button.setAttribute("aria-label", `${label} (${count})`);
    button.setAttribute("aria-pressed", String(isSelected));
    button.dataset.vote = type;
    button.dataset.questionId = String(questionId);
    button.disabled = !localStorage.getItem("userId");

    image.src = isUpvote
        ? (isSelected ? "uparrowf.png" : "uparrow.png")
        : (isSelected ? "downarrowf.png" : "downarrow.png");
    image.alt = "";
    image.setAttribute("aria-hidden", "true");
    countLabel.classList.add("vote-count");
    countLabel.textContent = String(count);

    button.append(image, countLabel);
    button.addEventListener("click", handleVoteClick);
    return button;
}

async function handleVoteClick(event) {
    event.stopPropagation();

    const button = event.currentTarget;
    const controls = button.closest(".question-votes");
    const message = controls.querySelector(".vote-message");
    const userId = localStorage.getItem("userId");

    if (!userId) {
        message.textContent = "Please log in to vote.";
        return;
    }

    const currentVote = controls.querySelector('[aria-pressed="true"]')?.dataset.vote;
    const requestedVote = button.dataset.vote;
    const voteType = currentVote === requestedVote ? null : requestedVote;

    message.textContent = "";
    controls.querySelectorAll(".vote-button").forEach(voteButton => {
        voteButton.disabled = true;
    });

    try {
        const response = await fetch(
            `/api/questions/${button.dataset.questionId}/vote`,
            {
                method: "POST",
                headers: { "Content-Type": "application/json" },
                body: JSON.stringify({ user_id: Number(userId), vote_type: voteType })
            }
        );
        const result = await response.json();

        if (!response.ok) {
            throw new Error(result.detail || "Could not save your vote.");
        }

        const question = allQuestions.find(
            item => String(item.id) === button.dataset.questionId
        );
        if (question) {
            question.upvotes = result.upvotes;
            question.downvotes = result.downvotes;
            question.user_vote = result.user_vote;
        }

        controls.querySelectorAll(".vote-button").forEach(voteButton => {
            const isUpvote = voteButton.dataset.vote === "up";
            const selected = result.user_vote === voteButton.dataset.vote;
            const count = isUpvote ? result.upvotes : result.downvotes;
            const image = voteButton.querySelector("img");

            voteButton.setAttribute("aria-pressed", String(selected));
            voteButton.setAttribute(
                "aria-label",
                `${isUpvote ? "Upvote" : "Downvote"} (${count})`
            );
            image.src = isUpvote
                ? (selected ? "uparrowf.png" : "uparrow.png")
                : (selected ? "downarrowf.png" : "downarrow.png");
            voteButton.querySelector(".vote-count").textContent = String(count);
        });
    } catch (error) {
        console.error("Error saving question vote:", error);
        message.textContent = error.message || "Could not save your vote.";
    } finally {
        controls.querySelectorAll(".vote-button").forEach(voteButton => {
            voteButton.disabled = false;
        });
    }
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
        const userId = localStorage.getItem("userId");
        const userQuery = userId ? `?user_id=${encodeURIComponent(userId)}` : "";
        const response = await fetch(`/api/questions${userQuery}`);

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