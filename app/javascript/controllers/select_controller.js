import { Controller } from "@hotwired/stimulus"
import TomSelect from "tom-select"

// Connects to data-controller="select"
export default class extends Controller {

  connect() {
    this.element.classList.remove("hidden");
    var maxItems = this.element.dataset.maxitems;
    var create = this.element.dataset.create;

    new TomSelect(this.element,{
	       create: create,
         maxItems: maxItems,
         closeAfterSelect: true,
         duplicates: true,
         plugins: ['remove_button'],
         maxOptions: 100,
         sortField: {
           field: "text",
		       direction: "asc"
	      },
        render:{
      		option_create: function( data, escape ){
      			return '<div class="create">Ajouter <strong>' + escape(data.input) + '</strong>&hellip;</div>';
      		},
      		no_results: function( data, escape ){
      			return '<div class="no-results">Aucun résultat trouvé</div>';
      		},
    	}
    });
  }
}
