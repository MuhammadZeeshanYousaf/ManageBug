import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="previews"
export default class extends Controller {
  static targets = ["input", "preview", "showImage", "showLabel"];
  connect() {
    // console.log("Hello stimulus controller")
    this.showImageTarget.hidden = true;
  }

  preview() {
    // TODO: this
    let input = this.inputTarget;
    let preview = this.previewTarget;
    let file = input.files[0];
    let reader = new FileReader();

    reader.onloadend = function () {
      preview.src = reader.result;
    };

    if (file) {
      reader.readAsDataURL(file);
      this.showImageTarget.hidden = false;
      this.showLabelTarget.hidden = true;
    } else {
      preview.src = "";
      this.showImageTarget.hidden = true;
      this.showLabelTarget.hidden = false;
    }
  }
}
