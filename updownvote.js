const upvoteButton = document.querySelector(".upvote-button");
const upvoteArrow = upvoteButton.querySelector("img");
const upvoteCount = upvoteButton.parentElement.querySelector(".vote-count");

const downvoteButton = document.querySelector(".downvote-button");
const downvoteArrow = downvoteButton.querySelector("img");
const downvoteCount = downvoteButton.parentElement.querySelector(".vote-count");

function setVoteCount(countElement, count) {
    countElement.textContent = String(count);
}

upvoteButton.addEventListener("click", () => {
    const isFilled = upvoteButton.getAttribute("aria-pressed") === "true";

    upvoteArrow.src = isFilled ? "uparrow.png" : "uparrowf.png";
    upvoteButton.setAttribute("aria-pressed", String(!isFilled));
    setVoteCount(upvoteCount, isFilled ? 0 : 1);

    if (!isFilled) {
        downvoteArrow.src = "downarrow.png";
        downvoteButton.setAttribute("aria-pressed", "false");
        setVoteCount(downvoteCount, 0);
    }
});

downvoteButton.addEventListener("click", () => {
    const isFilled = downvoteButton.getAttribute("aria-pressed") === "true";

    downvoteArrow.src = isFilled ? "downarrow.png" : "downarrowf.png";
    downvoteButton.setAttribute("aria-pressed", String(!isFilled));
    setVoteCount(downvoteCount, isFilled ? 0 : 1);

    if (!isFilled) {
        upvoteArrow.src = "uparrow.png";
        upvoteButton.setAttribute("aria-pressed", "false");
        setVoteCount(upvoteCount, 0);
    }
});