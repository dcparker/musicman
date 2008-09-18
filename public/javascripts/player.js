$().ready(function(){
  $.getJSON("/now_playing.json", function(playing){
    $('#elapsed').html(playing.position);
    $('#remaining').html(playing.length - playing.position);
    $('#track_name').html(playing.name);
    var slider = $("div#track_slider").slider({
      handle: 'div#track_handle',
      stop: function(event, ui){
        $.get("/seek?position="+ui.value);
      },
      startValue: playing.position/playing.length*100
    });
  });
});
