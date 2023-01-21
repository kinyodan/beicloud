import { Controller } from "@hotwired/stimulus"

console.log("Controller")
export default class extends Controller {
  connect() {
    this.element.textContent = "Hello World!"
  }
}
