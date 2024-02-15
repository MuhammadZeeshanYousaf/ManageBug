// Configure your import map in config/importmap.rb. Read more: https://github.com/rails/importmap-rails
//= require jquery3
//= require popper
//= require bootstrap-sprockets
import "@hotwired/turbo-rails"
import "controllers"

window.bootstrap = bootstrap;

$(document).ready(function () {
  $(".custom-card").mouseenter(function() {
    $(this).find(".card-arrow").show()

  })

  $(".custom-card").mouseleave(function() {
    $(this).find(".card-arrow").hide()
  })

})