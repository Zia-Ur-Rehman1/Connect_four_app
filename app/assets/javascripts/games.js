function callSetPiece(gameId, event) {
  const coords = event.target.id; 
  const url = "/games/" + gameId + "/set_piece?coords="+coords;
  $.ajax({
      url: url,
      type: 'POST',
      success: function(response) {
        $('#' + response.id).addClass(response.class)
        winner = response.winner
        if (winner > 0) {
          $('#winner').html('Player ' + winner + ' is the winner');
          $('#board').addClass('disabled-click');
        }
      },
      error: function(xhr, status, error) {
      }
  });
}
