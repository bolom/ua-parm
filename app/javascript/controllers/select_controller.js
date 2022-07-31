import { Controller } from "@hotwired/stimulus"
import TomSelect from "tom-select"

<<<<<<< HEAD
// Connects to data-controller="tom-select"
export default class extends Controller {
  connect() {
      new TomSelect(this.element, {
        sortField: {
          field: "text",
          direction: "asc"
        },
        maxItems: 3,
        allowEmptyOption: false,
        plugins: ['no_backspace_delete'],
      })
=======
// Connects to data-controller="select"
export default class extends Controller {
  connect() {
    console.log(this)
    new TomSelect(this.element,{
	       create: true,
         maxItems: 5,
         sortField: {
           field: "text",
		       direction: "asc"
	        }
    });
>>>>>>> origin/mc-ux
  }
}
