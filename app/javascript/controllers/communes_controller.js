import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="communes"
export default class extends Controller {
  // static targets = ["department", "dptcommunes","postCode"]
  static targets = ["department", "dptcommunes"]
  connect() {
    console.log("Hello from our first Stimulus controller");
    // console.log("my dropdoww", this.departmentTarget.value);
    console.log(this.dptcommunesTarget)

  }
  fetchDepartment(query) {

    // console.log(query)
    fetch(`https://geo.api.gouv.fr/departements/${query}/communes`)
    // fetch(`https://api.mapbox.com/geocoding/v5/mapbox.places/${query}.json?access_token=${token}`)
       .then(response => response.json())
       .then((data) => {
          console.log(data);
          const communes = data.map( hash => hash["nom"] );
          const post_codes = data.map( hash => hash["codesPostaux"] );
          // const code_insee = data.map( hash => hash["code"] );
          console.log(communes);
          console.log(this.dptcommunesTarget)

          // Clear the existing city options
          this.dptcommunesTarget.innerHTML = '';
          // this.postCodeTarget.innerHTML = '';

          communes.forEach((city) => {
            const option = document.createElement("option");
            option.value = city;
            option.textContent = city;
            this.dptcommunesTarget.appendChild(option);
          });

          // post_codes.forEach((post_code) => {
          //   const option2 = document.createElement("option");
          //   option2.value = post_code;
          //   option2.textContent = post_code;
          //   this.postCodeTarget.appendChild(option2);
          // });
     });
  }


  dptChoice(event) {
    // event.preventDefault();
    // console.log(event)

    const userDepartment = this.departmentTarget.value;
    console.log(userDepartment);
    const dptNumber = userDepartment.substring(0, userDepartment.indexOf(" -"));
    // console.log(dptNumber);
    this.fetchDepartment(dptNumber);
  }



}
