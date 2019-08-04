$('.favorite a').on ('ajax:success', favoriteHighlight);

function favoriteHighlight(event, data) {
  $('body').append(data.id);
}
