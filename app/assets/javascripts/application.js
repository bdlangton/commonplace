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
//= require jquery-ui/widgets/autocomplete
//= require autocomplete-rails
//= require popper
//= require bootstrap
//= require_tree .

document.addEventListener("DOMContentLoaded", function(event) {
  // TODO: Move this JS to only show on pages that it needs to be on.
  $('a.favorite').bind('ajax:success', favoriteHighlight);
  $('a.publish').bind('ajax:success', publishHighlight);

  // Favorite or unfavorite a highlight.
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

  // Publish or unpublish a highlight.
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

  // Update tag colors based on the first letter of each tag.
  $('.tag.badge').each(function () {
    var first_char = $(this).html().substring(0, 1).toLowerCase();
    if ($.inArray(first_char, ['a', 'q']) > -1) {
      $(this).css('background-color', 'navy');
    }
    else if ($.inArray(first_char, ['b', 'r']) > -1) {
      $(this).css('background-color', 'blue');
    }
    else if ($.inArray(first_char, ['c', 's']) > -1) {
      $(this).css('color', 'black');
      $(this).css('background-color', 'aqua');
    }
    else if ($.inArray(first_char, ['d', 't']) > -1) {
      $(this).css('background-color', 'teal');
    }
    else if ($.inArray(first_char, ['e', 'u']) > -1) {
      $(this).css('background-color', 'olive');
    }
    else if ($.inArray(first_char, ['f', 'v']) > -1) {
      $(this).css('background-color', 'green');
    }
    else if ($.inArray(first_char, ['g', 'w']) > -1) {
      $(this).css('color', 'black');
      $(this).css('background-color', 'lime');
    }
    else if ($.inArray(first_char, ['h', 'x']) > -1) {
      $(this).css('color', 'black');
      $(this).css('background-color', 'yellow');
    }
    else if ($.inArray(first_char, ['i', 'y']) > -1) {
      $(this).css('background-color', 'orange');
    }
    else if ($.inArray(first_char, ['j', 'z']) > -1) {
      $(this).css('background-color', 'red');
    }
    else if (first_char == 'k') {
      $(this).css('background-color', 'maroon');
    }
    else if (first_char == 'l') {
      $(this).css('background-color', 'fuchsia');
    }
    else if (first_char == 'm') {
      $(this).css('background-color', 'purple');
    }
    else if (first_char == 'n') {
      $(this).css('background-color', 'black');
    }
    else if (first_char == 'o') {
      $(this).css('background-color', 'gray');
    }
    else if (first_char == 'p') {
      $(this).css('color', 'black');
      $(this).css('background-color', 'silver');
    }
  });

  // Hide flash notices after a few seconds.
  $('.flash').fadeOut(3000);
});

$(function(){ $(document).foundation(); });
