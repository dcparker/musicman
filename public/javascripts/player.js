// Creates the volume sliders
// .volume_slider{:style => 'clear:both'}
//   .floatleft
//     %span{:style => 'font-family:arial;font-size:16pt'} Volume:
//   .floatleft
//     .slider_bar
//       .slider_handle
$().ready(function(){
  $('div.sink_volume_slider').volume_slider(function(){
    var $slider = this;
    return {
      url: "/volume_get?sink="+$slider.attr('sink_name'),
      stop: function(event, ui){
        $.ajax({
          url:'/volume_set',
          data:{
            volume : ui.value,
            sink : $slider.attr('sink_name')
          },
          type:'GET'
        });
      },
      slide: function(event, ui){
        $.ajax({
          url:'/volume_set',
          data:{
            volume : ui.value,
            sink : $slider.attr('sink_name')
          },
          type:'GET'
        });
      }
    };
  });

  $('div.client_volume_slider').volume_slider(function(){
    var $slider = this;
    return {
      url: "/volume_get?sink_input_index="+$slider.attr('sink_input_index'),
      stop: function(event, ui){
        $.ajax({
          url:'/volume_set',
          data:{
            volume : ui.value,
            sink_input_index : $slider.attr('sink_input_index')
          },
          type:'GET'
        });
      },
      slide: function(event, ui){
        $.ajax({
          url:'/volume_set',
          data:{
            volume : ui.value,
            sink_input_index : $slider.attr('sink_input_index')
          },
          type:'GET'
        });
      }
    };
  });
});

$.fn.volume_slider = function(options_function){
  this.each(function(){
    var $slider = $(this);
    $slider.append("<div class='floatleft'><span>Volume:</span></div><div class='floatleft'><div class='slider_bar'><div class='slider_handle'></div></div></div>");
    var options = options_function.call($slider);
    $.getJSON(options.url, function(mixer){
      options.handle = $slider.find('div.slider_bar > div.slider_handle');
      options.startValue = mixer.volume;
      $slider.find('div.slider_bar').slider(options);
    });
  });
};

// Initialize the live search.
$().ready(function(){
// This is what the search section looked like:
// #songs{:style => "clear:both"}
//   #song-search
//     Search:
//     %input#search{:type => 'search'}
//   #song-results

  // $('#song-search input#search').keyup(function(){
  //   $.ajax({
  //     url: "/search",
  //     data: {'q': this.value},
  //     cache: false,
  //     success: function(html){
  //       $("#song-results").html(html);
  //     }
  //   });
  // });
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
    player.hidden = false;
    $('#now-playing div').show('slow');
  }
  player.updated = now;
  $("div#track_slider").slider('moveTo', player.percent_position, $('#track_handle'));
}

function guiUpdate(){
  getNowPlayingUpdate();
  player.active = (new Date()).getTime();
}

function getNowPlayingUpdate(){
  var now = (new Date()).getTime();
  if(now < (player.active + 20000)){ // hide after 20 seconds
    // Max frequency every 1.2 seconds
    if(now > (player.updated + 1200)){
      $.getJSON("/now_playing", updatePlayingIndicator);
    }
  }else{
    // Soon after the last-known song is finished playing, we'll grab the status again to update the song name.
    if(((player.length - player.position)*1000 + player.updated) < now){
      $.getJSON("/now_playing", updatePlayingIndicator);
    } else {
      player.hidden = true;
      $('#now-playing div').hide('slow');
    }
  }
  return now;
}

// This is what the now-playing slider looked like:
// #now-playing
//   %h4#track_name
//   .floatleft
//     %span#elapsed{:style => 'font-family:arial;font-size:16pt'}
//   .floatleft
//     #track_slider
//       #track_handle
//   .floatleft
//     %span#remaining{:style => 'font-family:arial;font-size:16pt'}

// $().ready(function(){
//   player.active = (new Date()).getTime();
//   $("div#track_slider").slider({
//     handle: 'div#track_handle',
//     stop: function(event, ui){
//       // Only if it's a significant seek action. Also nullifies seeking every time the position is auto-updated.
//       if(ui.value > player.percent_position+1 || ui.value < player.percent_position-1){
//         $.get("/seek?position="+player.percent_to_position(ui.value));
//       }
//     },
//     startValue: 0
//   });
//   // Stops updating when you've been inactive in the app for over a minute.
//   $('#now-playing').everyTime(2000, 'indicator', getNowPlayingUpdate);
//   // This keeps updating the slider every 2 seconds as long as it notices mouse activity in the app.
//   $("body").mousemove(guiUpdate);
//   $("body").click(guiUpdate);
//   $("body").keypress(guiUpdate);
// });
