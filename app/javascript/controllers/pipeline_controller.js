// app/javascript/controllers/pipeline_controller.js
import { Controller } from "@hotwired/stimulus"
import Sortable from "sortablejs"

export default class extends Controller {
  static values = {
    moveUrl: String,
    csrfToken: String
  }

  connect() {
    this.initSortable()
  }

  disconnect() {
    this.sortableInstances?.forEach(s => s.destroy())
  }

  initSortable() {
    this.sortableInstances = []

    const columns = this.element.querySelectorAll("[data-pipeline-stage]")

    columns.forEach(column => {
      const stage = column.dataset.pipelineStage

      const sortable = Sortable.create(column, {
        group: "pipeline",
        animation: 150,
        ghostClass: "opacity-30",
        chosenClass: "shadow-lg",
        dragClass: "shadow-xl",
        emptyInsertThreshold: 40,
        filter: "a",
        preventOnFilter: false,
        onStart: () => {
          // Highlight all columns as drop targets
          columns.forEach(col => col.classList.add("ring-2", "ring-primary/20", "ring-inset"))
        },
        onEnd: (evt) => {
          // Remove highlight from all columns
          columns.forEach(col => col.classList.remove("ring-2", "ring-primary/20", "ring-inset"))

          const leadId = evt.item.dataset.leadId
          const newStage = evt.to.dataset.pipelineStage
          const oldStage = evt.from.dataset.pipelineStage

          // No change if dropped in same column
          if (oldStage === newStage) return

          this.updateStage(leadId, newStage, evt)
        }
      })

      this.sortableInstances.push(sortable)
    })
  }

  async updateStage(leadId, newStage, evt) {
    const card = evt.item

    // Optimistic UI — dim card while saving
    card.classList.add("opacity-60", "pointer-events-none")

    try {
      const response = await fetch(this.moveUrlValue, {
        method: "PATCH",
        headers: {
          "Content-Type": "application/json",
          "X-CSRF-Token": this.csrfTokenValue,
          "Accept": "application/json"
        },
        body: JSON.stringify({ lead_id: leadId, stage: newStage })
      })

      const data = await response.json()

      if (response.ok && data.success) {
        // Update the column count badges
        this.updateColumnCounts()
        card.classList.remove("opacity-60", "pointer-events-none")
      } else {
        // Revert card to original column on failure
        evt.from.insertBefore(card, evt.from.children[evt.oldIndex] || null)
        card.classList.remove("opacity-60", "pointer-events-none")
        alert("Failed to move lead: " + (data.error || "Unknown error"))
      }
    } catch (err) {
      // Revert on network error
      evt.from.insertBefore(card, evt.from.children[evt.oldIndex] || null)
      card.classList.remove("opacity-60", "pointer-events-none")
      console.error("Pipeline move error:", err)
    }
  }

  updateColumnCounts() {
    const columns = this.element.querySelectorAll("[data-pipeline-stage]")
    columns.forEach(column => {
      const stage = column.dataset.pipelineStage
      const count = column.querySelectorAll("[data-lead-id]").length
      const badge = this.element.querySelector(`[data-count-stage="${stage}"]`)
      if (badge) badge.textContent = count
    })
  }
}