import { Controller } from "stimulus";
import Rails from "@rails/ujs"
import { fetchWithToken } from "../utils/fetch_with_token";

export default class extends Controller {
  static targets = ['display', 'form', 'header', 'message'];

  connect() {}

  select(e) {
    e.preventDefault();
    const tab = e.currentTarget;
    const url = tab.getAttribute("href");
    fetch(url, { headers: { accept: "application/json" } })
      .then(response => response.json())
      .then((data) => {
        console.log(data);
        const currentUser = data.current_user.id;
        let conversationContent = ""

        this.headerTarget.dataset.conversationId = data.conversation.id;

        data.messages.forEach((message) => {
          const isCurrentUser = message.user_id === currentUser;
          // console.log(this.createMessage(message.content, isCurrentUser));
          conversationContent += this.createMessage(message.content, isCurrentUser);
          // console.log(conversationContent);
        })
        // console.log(conversationContent);
        this.displayTarget.innerHTML = conversationContent;
        // console.log(this.displayTarget.innerHTML);
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

  submit(e) {
    e.preventDefault();
    const conversationId = this.headerTarget.dataset.conversationId;
    const url = `/conversations/${conversationId}/messages`;
    this.formTarget.action = url;
    // Rails.fire(this.formTarget, 'submit')
    fetchWithToken(url, {
      method: "POST",
      headers: {
        "Accept": "application/json",
        "Content-Type": "application/json"
      },
      body: JSON.stringify({ message: { content: this.messageTarget.value } })
    })
      .then(response => response.json())
      .then((data) => {
        if (data.success) {
          this.displayTarget.insertAdjacentHTML('beforeend', this.createMessage(data.message, true))
          this.messageTarget.value = ""
        } else {
          console.log(data.errors);
        }
      })

//       const searchAlgoliaPlaces = (event) => {
//   fetch("https://places-dsn.algolia.net/1/places/query", {
//     method: "POST",
//     body: JSON.stringify({ query: event.currentTarget.value })
//   })
//     .then(response => response.json())
//     .then((data) => {
//       console.log(data.hits); // Look at local_names.default
//     });
// };
  }

  result(e) {
    const conversationId = this.headerTarget.dataset.conversationId;
    const url = `/conversations/${conversationId}`;
    // fetch(url, { headers: { accept: "application/json" } })
    //   .then(response => response.json())
    //   .then((data) => {
    //     console.log(data);
    //     const currentUser = data.current_user.id;
    //     let conversationContent = ""

    //     // this.headerTarget.dataset.conversationId = data.conversation.id;

    //     data.messages.forEach((message) => {
    //       const isCurrentUser = message.user_id === currentUser;
    //       // console.log(this.createMessage(message.content, isCurrentUser));
    //       conversationContent += this.createMessage(message.content, isCurrentUser);
    //       // console.log(conversationContent);
    //     })
    //     console.log(conversationContent);
    //     this.displayTarget.innerHTML = conversationContent;
    //     // console.log(this.displayTarget.innerHTML);
    //   })
  }

  error(e) {
    console.log('error::', e);
  }
}
