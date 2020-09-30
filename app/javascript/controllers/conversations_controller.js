import { Controller } from "stimulus";
import Rails from "@rails/ujs"

export default class extends Controller {
  static targets = ['display'];

  connect() {}

  select(e) {
    e.preventDefault();
    const tab = e.currentTarget;
    const url = tab.getAttribute("href");
    fetch(url, { headers: { accept: "application/json" } })
      .then(response => response.json())
      .then((data) => {
        // console.log(data);
        const currentUser = data.current_user.id;

        let conversationContent = ""
        data.messages.forEach((message) => {
          const isCurrentUser = message.user_id === currentUser;
          // console.log(this.createMessage(message.content, isCurrentUser));
          conversationContent += this.createMessage(message.content, isCurrentUser);
          // console.log(conversationContent);
        })
        console.log(conversationContent);
        this.displayTarget.innerHTML = conversationContent;
        console.log(this.displayTarget.innerHTML);
      })
  }

  createMessage(message, isCurrentUser) {
    const messageClass = isCurrentUser ? 'message-sender' : 'message-receiver';
    const messageHTML = `
      <li class="message-content ${messageClass}">
        <p>${message}<p>
      </li>
    `
    return messageHTML;
  }

  result(e) {

    // const data = e.detail[0].body.querySelector('.listing-list-container').innerHTML
    // if (data.length > 0) {
    //   return this.displayTarget.innerHTML = data
    // }
  }

  error(e) {
    console.log('error::', e);
  }



  // search(e) {
  //   const query = this.queryTarget.value
  //   Rails.fire(this.formTarget, 'submit')
  // }

  // filter(e) {
  //   const select = this.selectTarget.value
  //   Rails.fire(this.formTarget, 'submit')
  // }

}
