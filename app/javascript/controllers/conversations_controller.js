import { Controller } from "stimulus";
import Rails from "@rails/ujs"

export default class extends Controller {
  // static targets = ['form', 'query', 'select', 'display', 'header'];

  connect() {
    console.log('hello');
  }

  // search(e) {
  //   const query = this.queryTarget.value
  //   Rails.fire(this.formTarget, 'submit')
  // }

  // filter(e) {
  //   const select = this.selectTarget.value
  //   Rails.fire(this.formTarget, 'submit')
  // }

  // result(e) {
  //   const data = e.detail[0].body.querySelector('.listing-list-container').innerHTML
  //   if (data.length > 0) {
  //     return this.displayTarget.innerHTML = data
  //   }
  // }

  // error(e) {
  //   console.log('error::', e);
  // }
}
