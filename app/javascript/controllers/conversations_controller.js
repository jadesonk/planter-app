import { Controller } from "stimulus";
import Rails from "@rails/ujs"
import { fetchWithToken } from "../utils/fetch_with_token";

export default class extends Controller {
  static targets = ['display', 'form', 'header', 'message', 'input'];

  connect() {
    this.refreshChat();
    setInterval(this.refreshChat, 5000);
  }

  refreshChat = () => {
    if (window.location.hash !== "") {
      const id = window.location.hash.replace("#", '')
      const url = `/conversations/${id}`
      this.inputTarget.classList.add('active');
      this.fetchChat(url);
    }
  }

  fetchChat = (url) => {
    fetch(url, { headers: { accept: "application/json" } })
      .then(response => response.json())
      .then((data) => {
        this.headerTarget.dataset.conversationId = data.conversation.id;
        this.displayTarget.innerHTML = ""
        this.renderChat(data);
      })
  }

  renderChat = (data) => {
    const currentUser = data.current_user.id;
    data.messages.forEach((message) => {
      const isCurrentUser = message.user_id === currentUser;
      this.displayTarget.insertAdjacentHTML('afterbegin', this.createMessage(message.content, isCurrentUser))
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

  select(e) {
    e.preventDefault();
    const tab = e.currentTarget;
    const url = tab.getAttribute("href");
    this.inputTarget.classList.add('active');
    window.location.hash = tab.href.slice(-1);
    this.fetchChat(url);
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
          this.displayTarget.insertAdjacentHTML('afterbegin', this.createMessage(data.message, true))
          this.messageTarget.value = ""
        } else {
          console.log(data.errors);
        }
      })
  }

  result(e) {}

  error(e) {
    console.log('error::', e);
  }
}
