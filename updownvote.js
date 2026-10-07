const upvoteButton = document.querySelector(".upvote-button");
const upvoteArrow = upvoteButton.querySelector("img");

upvoteButton.addEventListener("click", () => {
    const isFilled = upvoteButton.getAttribute("aria-pressed") === "true";

    upvoteArrow.src = isFilled ? "uparrow.png" : "uparrowf.png";
    upvoteButton.setAttribute("aria-pressed", String(!isFilled));
});

const downvoteButton = document.querySelector(".downvote-button");
const downvoteArrow = downvoteButton.querySelector("img");

downvoteButton.addEventListener("click", () => {
    const isFilled = downvoteButton.getAttribute("aria-pressed") === "true";

    downvoteArrow.src = isFilled ? "downarrow.png" : "downarrowf.png";
    downvoteButton.setAttribute("aria-pressed", String(!isFilled));
});