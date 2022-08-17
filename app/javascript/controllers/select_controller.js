import { Controller } from "@hotwired/stimulus"
import TomSelect from "tom-select"

// Connects to data-controller="select"
export default class extends Controller {

  connect() {

    console.log(this.element.dataset)
    console.log(this.element.dataset.controller);
    console.log(this.element.dataset.maxitems);
    var maxItems = this.element.dataset.maxitems;

    new TomSelect(this.element,{
	       create: true,
         maxItems: maxItems,
         sortField: {
           field: "text",
		       direction: "asc"
	        }
    });
  }
}
