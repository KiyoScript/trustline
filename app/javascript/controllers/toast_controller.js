import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  connect() {
    setTimeout(() => {
      this.dismiss()
    }, 4000) // auto dismiss after 4 seconds
  }

  dismiss() {
    this.element.classList.add("opacity-0", "transition-opacity", "duration-500")
    setTimeout(() => this.element.remove(), 500)
  }
}