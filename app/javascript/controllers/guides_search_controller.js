import { Controller } from "@hotwired/stimulus"

// Filters the guide cards client-side by title/description as the user types.
export default class extends Controller {
  static targets = ["input", "card", "empty"]

  filter() {
    const query = this.inputTarget.value.trim().toLowerCase()
    let visibleCount = 0

    this.cardTargets.forEach((card) => {
      const matches = card.dataset.searchText.includes(query)
      card.hidden = !matches
      if (matches) visibleCount++
    })

    this.emptyTarget.classList.toggle("d-none", visibleCount > 0)
  }
}
