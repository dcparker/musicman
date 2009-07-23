use_orm :datamapper
use_test :rspec
use_template_engine :haml

dependency 'merb-helpers'

Merb::Config.use { |c|
  c[:framework] = { :public => [Merb.root / "public", nil] }
  c[:session_store]       = 'none'
  c[:exception_details]   = true
	c[:log_level]           = :debug # or error, warn, info or fatal
  c[:log_stream]          = STDOUT
  # or use file for logging:
  # c[:log_file]          = Merb.root / "log" / "merb.log"

	c[:reload_classes]   = true
	c[:reload_templates] = true
}

# Merb::BootLoader.after_app_loads do
#   DataMapper.setup(:default, 'sqlite3:musicman.sqlite3')
# end
 
# Routes.
Merb::Router.prepare do
  match('/').to(:controller => 'musicman', :action => 'index')
  match('/:action').to(:controller => 'musicman')
end

require 'lib/mixer'
require 'lib/amarok'
require 'lib/amarok/song'
require 'lib/amarok/artist'
require 'lib/pa'

# Controller
class Musicman < Merb::Controller
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
      :length => Amarok.track_length,
      :elapsed => Amarok.elapsed,
      :remaining => Amarok.remaining
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

  def seek
    Amarok.seek(params[:position])
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
    volume = case
    when params[:name]
      PulseAudio.list.sink_input(:nickname => params[:name].to_s).volume
    when params[:sink_input_index]
      PulseAudio.list.sink_input(:index => params[:sink_input_index].to_s).volume
    when params[:sink]
      PulseAudio.list.sink('Name' => params[:sink]).volume
    else
      Mixer.volume
    end.to_i
    "{'volume': #{volume}}"
  end
  def volume_set
    case
    when params[:name]
      PulseAudio.list.sink_input(:nickname => params[:name].to_s).volume = params[:volume].to_i
    when params[:sink_input_index]
      PulseAudio.list.sink_input(:index => params[:sink_input_index].to_s).volume = params[:volume].to_i
    when params[:sink]
      PulseAudio.list.sink('Name' => params[:sink]).volume = params[:volume].to_i
    else
      Mixer.volume(params[:volume].to_i)
    end.to_s
  end

  def move_sink_input
    case
    when params[:name]
      PulseAudio.list.client(:nickname => params[:nickname]).sink = params[:sink_name]
    when params[:client_index]
      PulseAudio.list.client(:index => params[:client_index]).sink = params[:sink_name]
    end
  end
end
