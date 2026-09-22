import { Controller } from "@hotwired/stimulus"

// Adds/removes nested fieldsets (e.g. guide steps) without a server round-trip.
export default class extends Controller {
  static targets = ["container", "template", "fields"]

  add(event) {
    event.preventDefault()
    const content = this.templateTarget.innerHTML.replace(/NEW_RECORD/g, Date.now())
    this.containerTarget.insertAdjacentHTML("beforeend", content)
  }

  remove(event) {
    event.preventDefault()
    const fields = event.target.closest("[data-nested-fields-target='fields']")
    const destroyField = fields.querySelector("input[name$='[_destroy]']")

    if (destroyField) {
      destroyField.value = "1"
      fields.hidden = true
    } else {
      fields.remove()
    }
  }
}
