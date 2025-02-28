document.addEventListener("DOMContentLoaded", () => {
  document.querySelectorAll(".submenu-header").forEach((header) => {
    header.addEventListener("click", () => {
      let parent = header.parentElement;
      parent.classList.toggle("active");
    });
  });
});
