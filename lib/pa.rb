MUSIC = {
  :library_dir => '/Users/daniel/Music/iTunes/iTunes Music',
  :ignore_list_file => 'ignore.list',
  :sink_nicknames => {
    'alsa_output.hw_0' => 'Downstairs',
    'alsa_output.hw_1' => 'Upstairs',
    'alsa_output.hw_2' => 'Downstairs Computer',
    'combined' => 'Combined'
  },
  :client_nicknames => [
    {
      /TCP\/IP client from 192.168.1.100/ => 'Fenestra'},
    {
      /TCP\/IP client from ([\d\.]+)/ => 'Other Computer: %s'}
  ]
}

class PulseAudio
  def self.list
    Thread.current['pactl list'] ||= PulseAudio.new
  end

  attr_reader :items

  def initialize
    @items = {}
    current = nil
    `pactl list`.each_line do |line|
      case line
      when /\*\*\*(.+?)\*\*\*/
        type, index = $1.strip.split(/#/).collect {|s| s.strip}
        @items[type] ||= []
        @items[type] << {:index => index}
        current = @items[type].last
      when /(.+?):(.*)/
        current[$1.strip] = $2.strip
      end
    end
  end

  def modules
    @items['Module'].collect {|m| PAModule.new(m)}
  end
  def module(atr={})
    key = atr.keys[0]
    val = atr.values[0]
    modules.select {|s| s[key] == val}[0]
  end

  def sinks
    @items['Sink'].collect {|s| Sink.new(s)}
  end
  def sink(atr={})
    key = atr.keys[0]
    val = atr.values[0]
    sinks.select {|s| s[key] == val}[0]
  end

  def sink_inputs
    @items['Sink Input'].collect {|s| SinkInput.new(s)}
  end
  def sink_input(atr={})
    key = atr.keys[0]
    val = atr.values[0]
    sink_inputs.select {|s| s[key] == val}[0]
  end

  def clients
    @items['Client'].collect {|c| Client.new(c)}.reject {|c| c.name == 'pactl'}
  end
  def client(atr={})
    key = atr.keys[0]
    val = atr.values[0]
    clients.select {|s| s[key] == val}[0]
  end

  def sources
    @items['Source']
  end
  def source(atr={})
    key = atr.keys[0]
    val = atr.values[0]
    sources.select {|s| s[key] == val}[0]
  end

  module PAThing
    def [](key)
      @attrs[key]
    end

    def index
      @attrs[:index]
    end
  end
  class PAModule
    include PAThing
    attr_reader :name, :argument

    def initialize(module_attrs)
      @attrs = module_attrs
      @name = module_attrs['Name']
      @argument = module_attrs['Argument']
    end
  end

  class Sink
    include PAThing
    attr_reader :description, :volume

    def initialize(sink_attrs)
      @attrs = sink_attrs
      @name = sink_attrs['Name']
      @description = sink_attrs['Description']
      @volume = sink_attrs['Volume'].split(/:?%? +/)[1]
    end

    def module
      PulseAudio.list.module(:index => @attrs['Owner Module'])
    end

    def volume=(volume)
      `echo "set-sink-volume #{index} #{65536*volume/100}" | pacmd 1>/dev/null`
    end

    def name
      if defined?(MUSIC)
        MUSIC[:sink_nicknames][@name]
      else
        @name
      end
    end
  end

  class SinkInput
    include PAThing
    attr_reader :name, :volume

    def initialize(sink_input_attrs)
      @attrs = sink_input_attrs
      @name = sink_input_attrs['Name']
      @client = sink_input_attrs['Client']
      @sink = sink_input_attrs['Sink']
      @volume = sink_input_attrs['Volume'].split(/:?%? +/)[1]
    end

    def client
      PulseAudio.list.client(:index => @client)
    end

    def sink
      PulseAudio.list.sink(:index => @sink)
    end

    def module
      PulseAudio.list.module(:index => @attrs['Owner Module'])
    end

    def volume=(volume)
      `echo "set-sink-input-volume #{index} #{65536*volume/100}" | pacmd 1>/dev/null`
    end

    def active?
      @attrs['Buffer Latency'].gsub(/\D/, '').to_i > 0
    end
  end

  class Client
    include PAThing
    attr_reader :name

    def initialize(client_attrs)
      @attrs = client_attrs
      @name = client_attrs['Name']
    end

    def nickname
      nick = nil
      MUSIC[:client_nicknames].each do |client_nickname|
        if @name =~ client_nickname.keys[0]
          nick = client_nickname.values[0]
          nick = nick % $~[1..$~.size] if $~.size > 1
          break
        end
      end
      nick || @name
    end

    def sink
      sink_input.sink
    end

    def sink_input
      PulseAudio.list.sink_input('Client' => index)
    end

    def sink=(sink_name)
      `pactl move-sink-input #{sink_input.index} #{PulseAudio.list.sink('Name' => sink_name).index}`
    end

    def network?
      sink_input.module.name == 'module-simple-protocol-tcp'
    end

    def active?
      sink_input.active?
    end
  end
end
