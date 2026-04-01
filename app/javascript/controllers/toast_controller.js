// app/javascript/controllers/toast_controller.js
import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static values = {
    duration: { type: Number, default: 4000 }
  }

  connect() {
    // Auto-dismiss after duration
    this.timeout = setTimeout(() => this.dismiss(), this.durationValue)

    // Slide in
    requestAnimationFrame(() => {
      this.element.classList.remove("translate-x-full", "opacity-0")
      this.element.classList.add("translate-x-0", "opacity-100")
    })
  }

  disconnect() {
    clearTimeout(this.timeout)
  }

  dismiss() {
    this.element.classList.remove("translate-x-0", "opacity-100")
    this.element.classList.add("translate-x-full", "opacity-0")
    setTimeout(() => this.element.remove(), 300)
  }
}