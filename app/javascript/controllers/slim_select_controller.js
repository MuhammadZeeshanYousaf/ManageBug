import { Controller } from "@hotwired/stimulus"
import SlimSelect from "slim-select";

// Connects to data-controller="slim-select"
export default class extends Controller {
  connect() {
    const select = new SlimSelect({
      select: this.element,
    })
  }
}
