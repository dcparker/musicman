# Arguments:
#   URL(s)                    Files/URLs to open
# 
# Options:
#   -r, --previous            Skip backwards in playlist
#   -p, --play                Start playing current playlist
#   -t, --play-pause          Play if stopped, pause if playing
#   --pause                   Pause playback
#   -s, --stop                Stop playback
#   -f, --next                Skip forwards in playlist
# 
# Additional options:
#   -a, --append              Append files/URLs to playlist
#   -e, --enqueue             See append, available for backwards compatability
#   --queue                   Queue URLs after the currently playing track
#   -l, --load                Load URLs, replacing current playlist
#   -m, --toggle-playlist-window Toggle the Playlist-window
#   --wizard                  Run first-run wizard
#   --engine <name>           Use the <name> engine
#   --cwd <directory>         Base for relative filenames/URLs
#   --cdplay <device>         Play an AudioCD from <device>

Amarok = Object.new
class << Amarok
  def play!(url=nil)
    if url
      url.gsub!(/^\./,'')
      `amarok --queue "#{url}"; amarok --next`
    end
    `amarok --play`
  end

  def play_next(url)
    url.gsub!(/^\./,'')
    `amarok --queue "#{url}"`
  end

  def pause!
    `amarok --pause`
  end

  def next!
    `amarok --next`
  end
  def previous!
    `amarok --previous`
  end
end
