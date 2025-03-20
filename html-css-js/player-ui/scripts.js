const playButton = document.querySelector(".play");

playButton.addEventListener("click", () => {
  if (playButton.innerHTML === "▶") {
    playButton.innerHTML = "⏸";
  } else {
    playButton.innerHTML = "▶";
  }
});
