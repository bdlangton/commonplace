// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, or any plugin's
// vendor/assets/javascripts directory can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file. JavaScript code in this file should be added after the last require_* statement.
//
// Read Sprockets README (https://github.com/rails/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require jquery
//= require rails-ujs
//= require popper
//= require bootstrap
//= require_tree .

document.addEventListener("DOMContentLoaded", function(event) {
  // TODO: Move this JS to only show on pages that it needs to be on.
  $('a.favorite').bind('ajax:success', favoriteHighlight);
  $('a.publish').bind('ajax:success', publishHighlight);

  function favoriteHighlight(event, data) {
    // TODO: Why is data null?
    if (event.detail[0].favorite) {
      $('#favorite-' + event.detail[0].id).removeClass('gray').addClass('red');
      $('#favorite-' + event.detail[0].id).attr('href', '/highlights/' + event.detail[0].id + '/unfavorite');
    }
    else {
      $('#favorite-' + event.detail[0].id).removeClass('red').addClass('gray');
      $('#favorite-' + event.detail[0].id).attr('href', '/highlights/' + event.detail[0].id + '/favorite');
    }
  }

  function publishHighlight(event, data) {
    // TODO: Why is data null?
    if (event.detail[0].published) {
      $('#publish-' + event.detail[0].id).removeClass('red').addClass('gray');
      $('#publish-' + event.detail[0].id).attr('href', '/highlights/' + event.detail[0].id + '/unpublish');
    }
    else {
      $('#publish-' + event.detail[0].id).removeClass('gray').addClass('red');
      $('#publish-' + event.detail[0].id).attr('href', '/highlights/' + event.detail[0].id + '/publish');
    }
  }

  // Hide flash notices after a few seconds.
  $('.flash').fadeOut(3000);
});

$(function(){ $(document).foundation(); });
