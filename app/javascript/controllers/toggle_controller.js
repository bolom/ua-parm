import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = [ "form"]

   toggle() {
      this.contentTarget.classList.toggle('hidden')
    }
}