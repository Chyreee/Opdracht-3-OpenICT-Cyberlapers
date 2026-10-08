const upvoteButton = document.querySelector(".upvote-button");
const upvoteArrow = upvoteButton.querySelector("img");
const upvoteCount = upvoteButton.parentElement.querySelector(".vote-count");

const downvoteButton = document.querySelector(".downvote-button");
const downvoteArrow = downvoteButton.querySelector("img");
const downvoteCount = downvoteButton.parentElement.querySelector(".vote-count");

function setVoteCount(countElement, count) {
    countElement.textContent = String(count);
}

function changeVoteCount(countElement, amount) {
    const currentCount = Number.parseInt(countElement.textContent, 10);
    setVoteCount(countElement, currentCount + amount);
}

upvoteButton.addEventListener("click", () => {
    const isFilled = upvoteButton.getAttribute("aria-pressed") === "true";

    upvoteArrow.src = isFilled ? "uparrow.png" : "uparrowf.png";
    upvoteButton.setAttribute("aria-pressed", String(!isFilled));
    changeVoteCount(upvoteCount, isFilled ? -1 : 1);

    if (!isFilled) {
        downvoteArrow.src = "downarrow.png";
        if (downvoteButton.getAttribute("aria-pressed") === "true") {
            downvoteButton.setAttribute("aria-pressed", "false");
            changeVoteCount(downvoteCount, -1);
        }
    }
});

downvoteButton.addEventListener("click", () => {
    const isFilled = downvoteButton.getAttribute("aria-pressed") === "true";

    downvoteArrow.src = isFilled ? "downarrow.png" : "downarrowf.png";
    downvoteButton.setAttribute("aria-pressed", String(!isFilled));
    changeVoteCount(downvoteCount, isFilled ? -1 : 1);

    if (!isFilled) {
        upvoteArrow.src = "uparrow.png";
        if (upvoteButton.getAttribute("aria-pressed") === "true") {
            upvoteButton.setAttribute("aria-pressed", "false");
            changeVoteCount(upvoteCount, -1);
        }
    }
});