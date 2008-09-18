require 'lib/mixer'
require 'lib/amarok'

class MusicMan < Merb::Controller
  autoload(:Song, 'models/song')
  autoload(:Artist, 'models/artist')

  def _template_location(action, type=nil, controller=controller_name)
    controller == "layout" ? "layout.#{action}.#{type}" : "#{action}.#{type}"
  end

  def index
    render
  end

  def search
    return render('<span style="color:gray">Search for a song...</span>', :layout => 'search') if params[:q].to_s == ''
    @songs = Song.all(:url.like => "%#{params[:q]}%", :limit => 15)
    render :template => 'search', :layout => 'search'
  end

  def now_playing
    playing = {
      :name => Amarok.track_name,
      :position => Amarok.track_position,
      :length => Amarok.track_length
    }
    display(playing, :format => :json)
  end

  def play
    if song = params[:song]
      Amarok.play!(song)
    else
      Amarok.play!
    end
    ''
  end

  def play_next
    Amarok.play_next(params[:song])
    ''
  end

  def pause
    Amarok.pause!
    ''
  end

  def next
    Amarok.next!
    ''
  end

  def previous
    Amarok.previous!
    ''
  end

  def volume_get
    "{'volume': #{Mixer.volume}}"
  end
  def volume_set
    Mixer.volume(params[:volume].to_i).to_s
  end
end
