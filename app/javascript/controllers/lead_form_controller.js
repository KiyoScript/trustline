import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["lastContactDate", "nextActionDate"]

  autoNextActionDate() {
    const lastContactValue = this.lastContactDateTarget.value
    if (!lastContactValue) return

    // Parse as local date to avoid timezone offset issues
    const [year, month, day] = lastContactValue.split("-").map(Number)
    const lastContact = new Date(year, month - 1, day)

    // Add 4 days
    lastContact.setDate(lastContact.getDate() + 4)

    // Format back as YYYY-MM-DD
    const yyyy = lastContact.getFullYear()
    const mm = String(lastContact.getMonth() + 1).padStart(2, "0")
    const dd = String(lastContact.getDate()).padStart(2, "0")

    this.nextActionDateTarget.value = `${yyyy}-${mm}-${dd}`
  }
}