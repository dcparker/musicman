class Amarok
  class << self
    def play!(url=nil)
      if url
        url.gsub!(/^\./,'')
        `dcop --user guest --session .DCOPserver_El-Aya__0 amarok playlist playMedia "#{url}"`
      end
      `dcop --user guest --session .DCOPserver_El-Aya__0 amarok player play`
    end

    def play_next(url)
      url.gsub!(/^\./,'')
      `dcop --user guest --session .DCOPserver_El-Aya__0 amarok playlist queueMedia "#{url}"`
    end

    def pause!
      `dcop --user guest --session .DCOPserver_El-Aya__0 amarok player pause`
    end

    def seek(position)
      `dcop --user guest --session .DCOPserver_El-Aya__0 amarok player seek #{position.to_i}`
    end

    def next!
      `dcop --user guest --session .DCOPserver_El-Aya__0 amarok player next`
    end
    def previous!
      `dcop --user guest --session .DCOPserver_El-Aya__0 amarok player prev`
    end

    def track_name
      Thread.current['track_name'] || Thread.current['track_name'] = `dcop --user guest --session .DCOPserver_El-Aya__0 amarok player nowPlaying`.chomp
    end
    def track_length
      Thread.current['track_length'] || Thread.current['track_length'] = `dcop --user guest --session .DCOPserver_El-Aya__0 amarok player trackTotalTime`.to_f
    end
    def track_position
      Thread.current['track_position'] || Thread.current['track_position'] = `dcop --user guest --session .DCOPserver_El-Aya__0 amarok player trackCurrentTime`.to_f
    end
    def elapsed
      "%s:%02d" % [(track_position / 60).to_i, (track_position % 60).to_i]
    end
    def remaining
      "%s:%02d" % [((track_length - track_position) / 60).to_i, ((track_length - track_position) % 60).to_i]
    end

    def score
      Thread.current['track_score'] || Thread.current['track_score'] = `dcop --user guest --session .DCOPserver_El-Aya__0 amarok player score`.to_f
    end

    def scoreDown!
      `dcop --user guest --session .DCOPserver_El-Aya__0 amarok player setScore #{score - 10}`
    end
    def scoreUp!
      `dcop --user guest --session .DCOPserver_El-Aya__0 amarok player setScore #{score + 10}`
    end

    def thumbsDown!
      scoreDown!
      next!
    end
    def thumbsUp!
      scoreUp!
    end
  end
end
