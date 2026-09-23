// Replaces the native browser confirm() for every data-turbo-confirm action
// (sign out, delete guide/post) with a dialog styled to match the design system.
import { Turbo } from "@hotwired/turbo-rails"

let overlay

function buildOverlay() {
  const el = document.createElement("div")
  el.className = "confirm-overlay"
  el.innerHTML = `
    <div class="confirm-dialog" role="alertdialog" aria-modal="true" aria-labelledby="confirm-dialog-message">
      <p id="confirm-dialog-message" class="confirm-dialog-message"></p>
      <div class="confirm-dialog-actions d-flex justify-content-between align-items-center">
        <button type="button" class="btn btn-secondary confirm-dialog-confirm">Confirm</button>
        <button type="button" class="btn confirm-dialog-cancel">Cancel</button>
      </div>
    </div>
  `
  document.body.appendChild(el)
  return el
}

function getOverlay() {
  if (!overlay || !document.body.contains(overlay)) overlay = buildOverlay()
  return overlay
}

Turbo.config.forms.confirm = (message, formElement, submitter) => {
  return new Promise((resolve) => {
    const dialog = getOverlay()
    const messageEl = dialog.querySelector(".confirm-dialog-message")
    const confirmBtn = dialog.querySelector(".confirm-dialog-confirm")
    const cancelBtn = dialog.querySelector(".confirm-dialog-cancel")

    messageEl.textContent = message

    const isDanger = submitter?.classList?.contains("btn-outline-danger")
    cancelBtn.classList.toggle("btn-primary", !isDanger)
    cancelBtn.classList.toggle("btn-danger", isDanger)

    const cleanup = (result) => {
      dialog.classList.remove("is-open")
      confirmBtn.removeEventListener("click", onConfirm)
      cancelBtn.removeEventListener("click", onCancel)
      dialog.removeEventListener("click", onOverlayClick)
      document.removeEventListener("keydown", onKeydown)
      resolve(result)
    }

    const onConfirm = () => cleanup(true)
    const onCancel = () => cleanup(false)
    const onOverlayClick = (event) => {
      if (event.target === dialog) cleanup(false)
    }
    const onKeydown = (event) => {
      if (event.key === "Escape") cleanup(false)
    }

    confirmBtn.addEventListener("click", onConfirm)
    cancelBtn.addEventListener("click", onCancel)
    dialog.addEventListener("click", onOverlayClick)
    document.addEventListener("keydown", onKeydown)

    dialog.classList.add("is-open")
    cancelBtn.focus()
  })
}
