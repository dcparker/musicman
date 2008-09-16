Mixer = Object.new
class << Mixer
  def volume(ctl=nil)
    case ctl
    when :up
      volume(volume + 4)
    when :down
      volume(volume - 4)
    when nil
      `amixer sget "Master"`.match(/\[(\d+)%\]/)[1].to_i
    else
      `amixer sset "Master" "#{ctl.to_i}%"`
      volume
    end
  end
end
