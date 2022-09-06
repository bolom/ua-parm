import { Controller } from "@hotwired/stimulus"
import TomSelect from "tom-select"

// Connects to data-controller="select"
export default class extends Controller {

  connect() {
    var maxItems = this.element.dataset.maxitems;
    new TomSelect(this.element,{
	       create: true,
         maxItems: maxItems,
         maxOptions: 500,
         sortField: {
           field: "text",
		       direction: "asc"
	        }
    });
  }
}
