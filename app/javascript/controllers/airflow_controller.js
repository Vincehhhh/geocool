import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="communes"
export default class extends Controller {
  // static targets = ["department", "dptcommunes","postCode"]
  static targets = ["flowrate", "buildingarea", "tip"]
  connect() {

    console.log("Hello from airflow controller 4");
  }

  // airflowpositif(event){
  //   if (this.flowrateTarget.value < 0) {
  //     const warning = "Le débit d'air doit être un entier positif";
  //     console.log(warning);
  // }

  writetip(event) {
    // event.preventDefault();
    // console.log(event)

    const buildingArea = this.buildingareaTarget.value;
    console.log(this.buildingareaTarget.value);
    const advicedValue = Math.round(buildingArea * 2.75 * 0.6)
    const advice = `Tips : Pour une bonne qualité d'air, un déit de ventilation d'au moins 0.60 vol/h est recommandé. Conseil Geocool: ${advicedValue} m³/h`;
    // console.log(this.tipTarget)
    this.tipTarget.innerHTML = advice// console.log(advice);
    if (this.flowrateTarget.value < advicedValue ) {
      this.tipTarget.style.color = "orange"
    } else {
      this.tipTarget.style.color = "green"
    }
  }

}
