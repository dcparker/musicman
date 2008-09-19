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


var player = {'updated':(new Date()).getTime() - 160, 'update':(new Date()).getTime()};
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
  if(player.hidden){
    $('#now-playing div').show('slow');
  }
  $("div#track_slider").slider('moveTo', player.percent_position, $('#track_handle'));
}

function guiUpdate(){
  getNowPlayingUpdate();
  player.active = (new Date()).getTime();
}

function getNowPlayingUpdate(){
  var now = (new Date()).getTime();
  if(now < (player.active + 60000)){
    // Max frequency every 1.2 seconds
    if(now > (player.updated + 1200)){
      player.updated = now;
      $.getJSON("/now_playing", updatePlayingIndicator);
    }
  }else{
    console.info("Last active: "+player.active+", Now: "+now);
    player.hidden = true;
    $('#now-playing div').hide('slow');
  }
  return now;
}

$().ready(function(){
  player.active = (new Date()).getTime();
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
  // Stops updating when you've been inactive in the app for over a minute.
  $('#now-playing').everyTime(4000, 'indicator', getNowPlayingUpdate);
  // This keeps updating the slider every 2 seconds as long as it notices mouse activity in the app.
  $("body").mousemove(guiUpdate);
  $("body").keypress(guiUpdate);
});
