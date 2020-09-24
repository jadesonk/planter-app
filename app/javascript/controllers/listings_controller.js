import { Controller } from "stimulus";

export default class extends Controller {
  static targets = [ 'select' ];

  connect() {
    console.log('Hello!');
    console.log('selectTarget', this.selectTarget);
  }

  filter(e) {
    const value = this.selectTarget.value



    // fetch('/listings', {
    //   headers: { accept: "application/json" }
    // })
    //   .then(response => response.json())
    //   .then((data) => {
    //     console.log(data);
    //   });
  }

  result(e) {}

  error(e) {
    console.log(e);
  }
}
