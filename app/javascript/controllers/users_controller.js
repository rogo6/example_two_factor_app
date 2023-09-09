import { Controller } from "@hotwired/stimulus"

export default class extends Controller {

  static targets = ['qrCode', 'twoFactorSelect']

  connect() {
    console.log("USERS CONTROLLER SAYS HELLO")
  }

  toggleQrCode() {
    this.twoFactorSelectTarget.value === 'authenticator' ? this.qrCodeTarget.classList.remove('hidden') : this.qrCodeTarget.classList.add('hidden')
  }
}