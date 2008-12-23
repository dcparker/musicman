$().ready(startupSoundManager);

function startupSoundManager() {
	soundManager.url = '/soundmanager2.swf';
	soundManager.debugMode = false;
	$(".mp3").each(function(){
		createAudioPlayerOnPage(this);
	});
	// We cannot load any sounds or do pretty much anything until we have loaded the Sound Manager or it freaks out
	soundManager.onload = function() {
		$(".mp3").each(function(){
			loadAudioFile(this);
		});
	}
}

function loadAudioFile(object) {
	soundManager.createSound({
		id: object.id,
		url: object.href,
		autoLoad: false,
		autoPlay: false,
		onfinish: function(){
			$("#" + object.id + "_button").click();
		}
	});
}

function createAudioPlayerOnPage(object) {
	var objectID = object.id;
	var objectButtonID = object.id + "_button";
	var objectSliderID = object.id + "_slider";
	var objectVolumeID = object.id + "_volume";
	// This puts the AudioPlayer DIV on the page, just before the direct Download button
	$(object).before('<br /><br /><div class="audioPlayer"><div class="audioPlayer_button" id="' + objectButtonID + '"></div><div id="' + objectSliderID + '" class="audioPlayer-slider-2 audioPlayer-track" style="margin:10px;"><div class="audioPlayer-slider-handle"></div></div><span class="audioPlayer-volume-text">Volume</span><div id="' + objectVolumeID + '" class="audioPlayer-slider-1 audioPlayer-volume" style="margin:10px;"><div class="audioPlayer-slider-handle"></div></div></div>');

	$("#" + objectSliderID).slider({slide: function(slider, handle){
		sound = soundManager.getSoundById(objectID);
		percent = handle.value;
		total = sound.durationEstimate;
		position = total * percent / 100;
		soundManager.setPosition(objectID,position);
	}});

	$("#" + objectVolumeID).slider({
		// 'axis': 'vertical',
		slide: function(slider, handle){
			soundManager.setVolume(objectID,handle.value);
		}
	});

	$('#' + objectID).everyTime(1000, 'updates the slider', function(){
		sound = soundManager.getSoundById(objectID);
		if(sound == undefined)
			return true;
		slider = $('#'+objectSliderID).sliderInstance();
		position = sound.position;
		total = sound.durationEstimate;
		percent = position / total * 100;
		slider.moveTo(percent);
	}, 0, true);
	
	$("#" + objectVolumeID).sliderInstance().moveTo(80);

	// Play and Pause button, toggles play and pause AND changes button bg image via add/remove class
	$("#" + objectButtonID).toggle(function(){
		$("#" + objectButtonID).toggleClass("audioPlayer_pause");
		soundManager.play(objectID);
	},function(){
		$("#" + objectButtonID).toggleClass("audioPlayer_pause");
		soundManager.pause(objectID);
	});
}