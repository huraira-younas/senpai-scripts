document.addEventListener("DOMContentLoaded", () => {
  const button = document.getElementById("uploadBtn");

  button.addEventListener("click", () => {
    if (button.classList.contains("loading")) return;
    button.classList.add("shrinking");

    setTimeout(() => {
      button.classList.add("loading");

      setTimeout(() => {
        button.classList.remove("loading");
        button.classList.add("success");

        setTimeout(() => {
          button.classList.remove("success", "shrinking");
          button.classList.add("reset");

          setTimeout(() => {
            button.classList.remove("reset");
          }, 300);
        }, 1500);
      }, 2000);
    }, 300);
  });
});
