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
        type, index = $1.strip.split(/\s+/)
        @items[type] ||= []
        @items[type] << {:index => index}
        current = @items[type].last
      when /(\w+):(.*)/
        current[$1] = $2.strip
      end
    end
  end

  def modules
    @items['Module']
  end
  def module(atr={})
    key = atr.keys[0]
    val = atr.values[0]
    modules.select {|s| s[key] == val}[0]
  end

  def sinks
    @items['Sink']
  end
  def sink(atr={})
    key = atr.keys[0]
    val = atr.values[0]
    sinks.select {|s| s[key] == val}[0]
  end

  def clients
    @items['Client']
  end
  def client(atr={})
    key = atr.keys[0]
    val = atr.values[0]
    client.select {|s| s[key] == val}[0]
  end

  def sources
    @items['Source']
  end
  def source(atr={})
    key = atr.keys[0]
    val = atr.values[0]
    sources.select {|s| s[key] == val}[0]
  end
end

# *** Module #0 ***
# Name: module-alsa-sink
# Argument: device=hw:0
# Usage counter: n/a
# Auto unload: no
# 
# *** Module #1 ***
# Name: module-alsa-source
# Argument: device=hw:0
# Usage counter: n/a
# Auto unload: no
# 
# *** Module #2 ***
# Name: module-alsa-sink
# Argument: device=hw:1
# Usage counter: n/a
# Auto unload: no
# 
# *** Module #3 ***
# Name: module-alsa-source
# Argument: device=hw:1
# Usage counter: n/a
# Auto unload: no
# 
# *** Module #4 ***
# Name: module-alsa-sink
# Argument: device=hw:2
# Usage counter: n/a
# Auto unload: no
# 
# *** Module #5 ***
# Name: module-alsa-source
# Argument: device=hw:2
# Usage counter: n/a
# Auto unload: no
# 
# *** Module #7 ***
# Name: module-native-protocol-unix
# Argument: 
# Usage counter: n/a
# Auto unload: no
# 
# *** Module #8 ***
# Name: module-simple-protocol-tcp
# Argument: listen=192.168.1.102 port=4712
# Usage counter: n/a
# Auto unload: no
# 
# *** Module #9 ***
# Name: module-volume-restore
# Argument: 
# Usage counter: n/a
# Auto unload: no
# 
# *** Module #10 ***
# Name: module-default-device-restore
# Argument: 
# Usage counter: n/a
# Auto unload: no
# 
# *** Module #11 ***
# Name: module-rescue-streams
# Argument: 
# Usage counter: n/a
# Auto unload: no
# 
# *** Module #12 ***
# Name: module-suspend-on-idle
# Argument: 
# Usage counter: n/a
# Auto unload: no
# 
# *** Module #13 ***
# Name: module-combine
# Argument: 
# Usage counter: n/a
# Auto unload: no
# 
# *** Module #14 ***
# Name: module-rtp-recv
# Argument: 
# Usage counter: n/a
# Auto unload: no
# 
# *** Module #15 ***
# Name: module-native-protocol-tcp
# Argument: auth-anonymous=1
# Usage counter: n/a
# Auto unload: no
# 
# *** Module #16 ***
# Name: module-esound-protocol-tcp
# Argument: auth-anonymous=1
# Usage counter: n/a
# Auto unload: no
# 
# *** Module #17 ***
# Name: module-zeroconf-publish
# Argument: 
# Usage counter: n/a
# Auto unload: no
# 
# *** Module #18 ***
# Name: module-gconf
# Argument: 
# Usage counter: n/a
# Auto unload: no
# 
# *** Module #19 ***
# Name: module-x11-publish
# Argument: 
# Usage counter: n/a
# Auto unload: no
# 
# *** Sink #0 ***
# Name: alsa_output.hw_0
# Driver: modules/module-alsa-sink.c
# Description: ALSA PCM on hw:0 (RIPTIDE) via DMA
# Sample Specification: s16le 2ch 44100Hz
# Channel Map: front-left,front-right
# Owner Module: 0
# Volume: 0:  87% 1:  87%
# Monitor Source: 0
# Latency: 90249 usec
# Flags: HW_VOLUME_CTRL LATENCY HARDWARE
# 
# *** Sink #1 ***
# Name: alsa_output.hw_1
# Driver: modules/module-alsa-sink.c
# Description: ALSA PCM on hw:1 (ES1371 DAC2/ADC) via DMA
# Sample Specification: s16le 2ch 44100Hz
# Channel Map: front-left,front-right
# Owner Module: 2
# Volume: 0:  70% 1:  70%
# Monitor Source: 2
# Latency: 83265 usec
# Flags: HW_VOLUME_CTRL LATENCY HARDWARE
# 
# *** Sink #2 ***
# Name: alsa_output.hw_2
# Driver: modules/module-alsa-sink.c
# Description: ALSA PCM on hw:2 (Intel 82801BA-ICH2) via DMA
# Sample Specification: s16le 2ch 44100Hz
# Channel Map: front-left,front-right
# Owner Module: 4
# Volume: 0: 100% 1: 100%
# Monitor Source: 4
# Latency: 89251 usec
# Flags: HW_VOLUME_CTRL LATENCY HARDWARE
# 
# *** Sink #3 ***
# Name: combined
# Driver: modules/module-combine.c
# Description: Simultaneous output to ALSA PCM on hw:0 (RIPTIDE) via DMA, ALSA PCM on hw:1 (ES1371 DAC2/ADC) via DMA, ALSA PCM on hw:2 (Intel 82801BA-ICH2) via DMA
# Sample Specification: s16le 2ch 44100Hz
# Channel Map: front-left,front-right
# Owner Module: 13
# Volume: 0: 100% 1: 100%
# Monitor Source: 6
# Latency: 108356 usec
# Flags: LATENCY 
# 
# *** Source #0 ***
# Name: alsa_output.hw_0.monitor
# Driver: modules/module-alsa-sink.c
# Description: Monitor Source of ALSA PCM on hw:0 (RIPTIDE) via DMA
# Sample Specification: s16le 2ch 44100Hz
# Channel Map: front-left,front-right
# Owner Module: 0
# Volume: 0: 100% 1: 100%
# Monitor of Sink: 0
# Latency: 0 usec
# Flags: 
# 
# *** Source #1 ***
# Name: alsa_input.hw_0
# Driver: modules/module-alsa-source.c
# Description: ALSA PCM on hw:0 (RIPTIDE) via DMA
# Sample Specification: s16le 2ch 44100Hz
# Channel Map: front-left,front-right
# Owner Module: 1
# Volume: 0: 100% 1: 100%
# Monitor of Sink: no
# Latency: 0 usec
# Flags: HW_VOLUME_CTRL LATENCY HARDWARE
# 
# *** Source #2 ***
# Name: alsa_output.hw_1.monitor
# Driver: modules/module-alsa-sink.c
# Description: Monitor Source of ALSA PCM on hw:1 (ES1371 DAC2/ADC) via DMA
# Sample Specification: s16le 2ch 44100Hz
# Channel Map: front-left,front-right
# Owner Module: 2
# Volume: 0: 100% 1: 100%
# Monitor of Sink: 1
# Latency: 0 usec
# Flags: 
# 
# *** Source #3 ***
# Name: alsa_input.hw_1
# Driver: modules/module-alsa-source.c
# Description: ALSA PCM on hw:1 (ES1371 DAC2/ADC) via DMA
# Sample Specification: s16le 2ch 44100Hz
# Channel Map: front-left,front-right
# Owner Module: 3
# Volume: 0: 100% 1: 100%
# Monitor of Sink: no
# Latency: 0 usec
# Flags: HW_VOLUME_CTRL LATENCY HARDWARE
# 
# *** Source #4 ***
# Name: alsa_output.hw_2.monitor
# Driver: modules/module-alsa-sink.c
# Description: Monitor Source of ALSA PCM on hw:2 (Intel 82801BA-ICH2) via DMA
# Sample Specification: s16le 2ch 44100Hz
# Channel Map: front-left,front-right
# Owner Module: 4
# Volume: 0: 100% 1: 100%
# Monitor of Sink: 2
# Latency: 0 usec
# Flags: 
# 
# *** Source #5 ***
# Name: alsa_input.hw_2
# Driver: modules/module-alsa-source.c
# Description: ALSA PCM on hw:2 (Intel 82801BA-ICH2) via DMA
# Sample Specification: s16le 2ch 44100Hz
# Channel Map: front-left,front-right
# Owner Module: 5
# Volume: 0: 100% 1: 100%
# Monitor of Sink: no
# Latency: 0 usec
# Flags: HW_VOLUME_CTRL LATENCY HARDWARE
# 
# *** Source #6 ***
# Name: combined.monitor
# Driver: modules/module-combine.c
# Description: Monitor Source of Simultaneous output to ALSA PCM on hw:0 (RIPTIDE) via DMA, ALSA PCM on hw:1 (ES1371 DAC2/ADC) via DMA, ALSA PCM on hw:2 (Intel 82801BA-ICH2) via DMA
# Sample Specification: s16le 2ch 44100Hz
# Channel Map: front-left,front-right
# Owner Module: 13
# Volume: 0: 100% 1: 100%
# Monitor of Sink: 3
# Latency: 0 usec
# Flags: 
# 
# *** Sink Input #3 ***
# Name: TCP/IP client from 192.168.1.100:54832
# Driver: pulsecore/protocol-simple.c
# Owner Module: 8
# Client: 0
# Sink: 1
# Sample Specification: s16le 2ch 44100Hz
# Channel Map: front-left,front-right
# Volume: 0: 100% 1: 100%
# Buffer Latency: 0 usec
# Sink Latency: 93605 usec
# Resample method: auto
# 
# *** Sink Input #5 ***
# Name: TCP/IP client from 192.168.1.100:55489
# Driver: pulsecore/protocol-simple.c
# Owner Module: 8
# Client: 4
# Sink: 3
# Sample Specification: s16le 2ch 44100Hz
# Channel Map: front-left,front-right
# Volume: 0: 100% 1: 100%
# Buffer Latency: 354965 usec
# Sink Latency: 107940 usec
# Resample method: auto
# 
# *** Sink Input #11 ***
# Name: Simultaneous output on ALSA PCM on hw:0 (RIPTIDE) via DMA
# Driver: modules/module-combine.c
# Owner Module: 13
# Client: n/a
# Sink: 0
# Sample Specification: s16le 2ch 44145Hz
# Channel Map: front-left,front-right
# Volume: 0: 100% 1: 100%
# Buffer Latency: 7996 usec
# Sink Latency: 99773 usec
# Resample method: trivial
# 
# *** Sink Input #12 ***
# Name: Simultaneous output on ALSA PCM on hw:1 (ES1371 DAC2/ADC) via DMA
# Driver: modules/module-combine.c
# Owner Module: 13
# Client: n/a
# Sink: 1
# Sample Specification: s16le 2ch 44100Hz
# Channel Map: front-left,front-right
# Volume: 0: 100% 1: 100%
# Buffer Latency: 0 usec
# Sink Latency: 94693 usec
# Resample method: trivial
# 
# *** Sink Input #13 ***
# Name: Simultaneous output on ALSA PCM on hw:2 (Intel 82801BA-ICH2) via DMA
# Driver: modules/module-combine.c
# Owner Module: 13
# Client: n/a
# Sink: 2
# Sample Specification: s16le 2ch 44077Hz
# Channel Map: front-left,front-right
# Volume: 0: 100% 1: 100%
# Buffer Latency: 16062 usec
# Sink Latency: 96235 usec
# Resample method: trivial
# 
# *** Client #0 ***
# Name: TCP/IP client from 192.168.1.100:54832
# Driver: pulsecore/protocol-simple.c
# Owner Module: 8
# 
# *** Client #4 ***
# Name: TCP/IP client from 192.168.1.100:55489
# Driver: pulsecore/protocol-simple.c
# Owner Module: 8
# 
# *** Client #30 ***
# Name: pactl
# Driver: pulsecore/protocol-native.c
# Owner Module: 7
