import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  connect() {
    const saved = localStorage.getItem('hr-theme')
    if (saved) {
      document.documentElement.setAttribute('data-theme', saved)
      const radio = this.element.querySelector(`input[value="${saved}"]`)
      if (radio) radio.checked = true
    }
  }

  save(event) {
    const theme = event.target.value
    document.documentElement.setAttribute('data-theme', theme)
    localStorage.setItem('hr-theme', theme)
  }
}