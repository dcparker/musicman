//    *****   VOLUME   *****
// Gets the current volume and sets up the volume slider.
$().ready(function(){
  $.getJSON("/volume_get", function(mixer){
    $("div#volume_slider").slider({
      handle: 'div#volume_handle',
      stop: function(event, ui){
        $.get("/volume_set?volume="+ui.value);
      },
      slide: function(event, ui){
        $.get("/volume_set?volume="+ui.value);
      },
      startValue: mixer.volume
    });
  });

  $('#song-search input#search').keyup(function(){
    $.ajax({
      url: "/search",
      data: {'q': this.value},
      cache: false,
      success: function(html){
        $("#song-results").html(html);
      }
    });
  });
});


var player = {};
player.percent_to_position = function(percent){
  return (percent / 100) * player.length;
};

//    *****   NOW PLAYING   *****
function updatePlayingIndicator(playing){
  player.length = playing.length;
  player.name = playing.name;
  player.position = playing.position;
  player.elapsed = playing.elapsed;
  player.remaining = playing.remaining;
  // Apply the texts to the page
  $('#elapsed').html(player.elapsed);
  $('#remaining').html(player.remaining);
  $('#track_name').html(player.name);
  player.percent_position = (playing.position / playing.length) * 100;
  $("div#track_slider").slider('moveTo', player.percent_position, $('#track_handle'));
}

$().ready(function(){
  $("div#track_slider").slider({
    handle: 'div#track_handle',
    stop: function(event, ui){
      // Only if it's a significant seek action. Also nullifies seeking every time the position is auto-updated.
      if(ui.value > player.percent_position+1 || ui.value < player.percent_position-1){
        $.get("/seek?position="+player.percent_to_position(ui.value));
      }
    },
    startValue: 0
  });
  $('#now-playing').everyTime(4000, 'indicator', function(){
    $.getJSON("/now_playing", updatePlayingIndicator);
  });
});
