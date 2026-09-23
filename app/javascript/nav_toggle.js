// Opens/closes the mobile nav-links dropdown. Event delegation on document
// so it keeps working across Turbo page loads without re-binding.
document.addEventListener("click", (event) => {
  const toggle = event.target.closest(".nav-toggle")
  const link = event.target.closest(".nav-links a")

  if (toggle) {
    const navbar = toggle.closest(".navbar")
    const isOpen = navbar.classList.toggle("nav-open")
    toggle.setAttribute("aria-expanded", isOpen)
    return
  }

  if (link) {
    link.closest(".navbar")?.classList.remove("nav-open")
  }
})
