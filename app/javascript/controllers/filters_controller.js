import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = [ "form",'result']
  static values = {url: String}

  static get targets() {
    return ["form"]
  }

  submit(event) {
    this.formTarget.requestSubmit()
  }

  findResults(event) {
   var url = this.urlValue.replace(/%s/g, encodeURIComponent(event.target.value)) ;
   console.log(url);
   fetch(url, {
    method: 'GET',
    }).then(response => response.json())
    .then((data) => {
       this.refreshDropdownValues(data)
    })
  }


  refreshDropdownValues(data) {
    console.log(data)
    let dropdown= document.getElementById("plant_scientific");
    console.log(dropdown);
    dropdown.innerHTML = ""
     for(var i = 0; i < data.length; i++) {
       var opt = data[i]
       console.log(opt)
       dropdown.innerHTML += "<option value=\"" + opt.name + "\">" + opt.name + "</option>"
     }
 }


}