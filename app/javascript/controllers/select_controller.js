import { Controller } from "@hotwired/stimulus"
import TomSelect from "tom-select"

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
  }
}
