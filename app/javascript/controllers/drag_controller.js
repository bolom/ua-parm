import { Controller } from "@hotwired/stimulus"
import Sortable from "sortablejs"

// Connects to data-controller="drag"
export default class extends Controller {
  connect() {
    this.sortable = Sortable.create(this.element, {
      onEnd: this.end.bind(this)
    })
  }
  end(event) {
    let id = event.item.id.replace('image_','')
    let data = new FormData()
    data.append("position", event.newIndex + 1)
    console.log(this.data.get("url"))

    fetch(this.data.get("url").replace(":id", id), {
      method: "PATCH",
      headers: {
        "X-CSRF-Token": document.querySelector("[name='csrf-token']").content,
      },
      body: data,
    });

  }
}
