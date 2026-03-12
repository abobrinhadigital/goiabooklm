import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["rule"]

  search(event) {
    const query = event.target.value.toLowerCase()

    this.ruleTargets.forEach(element => {
      const term = element.dataset.searchTerm.toLowerCase()
      if (term.includes(query)) {
        element.style.display = ""
      } else {
        element.style.display = "none"
      }
    })
  }
}
