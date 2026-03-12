import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["modal"]

  connect() {
    this.modalTarget.style.display = "none"
  }

  open() {
    this.modalTarget.style.display = "flex"
    document.body.style.overflow = "hidden" // Previne scroll ao fundo
  }

  close() {
    this.modalTarget.style.display = "none"
    document.body.style.overflow = "auto"
  }

  // Fecha clicando fora
  closeOnClickOutside(event) {
    if (event.target === this.modalTarget) {
      this.close()
    }
  }
}
