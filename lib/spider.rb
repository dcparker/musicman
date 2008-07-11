module Spider
  class << self
    def crawl!(start_dir=APP[:library_dir])
      count = 0
      stepped_on = File.new(start_dir)
      if stepped_on.stat.directory?
        Dir.new(stepped_on.path).each do |fn|
          next if fn =~ /^\.+$/
          count += Spider.crawl!("#{stepped_on.path}/#{fn}")
        end
        return count
      elsif stepped_on.stat.file? && stepped_on.path =~ /\.(mp3|mp4|m4a|m4p|wav)$/
        Catalog.create(:filename => stepped_on.path.gsub(APP[:library_dir]+'/',''))
        return 1
      else
        return 0
      end
    end
  end
end

# This isn't being used, yet.
module Ignore
  class << self
    def patterns
      @patterns ||= File.read(APP[:ignore_list_file])
    end

    # Returns true if filename should be ignored.
    def include?(filename)
      
    end
  end
end
