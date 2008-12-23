// Gets the current volume and sets up the volume slider.
$().ready(function(){
  $.getJSON("/volume_get", function(mixer){
    var slider = $("div#volume_slider").slider({
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
