import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = [ "form"]

  static get targets() {
    return ["form"]
  }

  submit(event) {
    this.formTarget.requestSubmit()
  }
}
