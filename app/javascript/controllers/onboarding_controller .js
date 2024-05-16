import { Controller } from "@hotwired/stimulus"

console.log("onboarding Controller")
export default class extends Controller {
  connect() {
    console.log("connected onboarding controller  World!")
  }

}
