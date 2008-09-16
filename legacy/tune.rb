require 'rubygems'
require 'id3lib'
require 'dm-core'
require 'dm-validations'

class Tune
  include DataMapper::Resource
  property :id,       Integer, :serial => true
  property :filename, String
  property :title,    String
  property :artist,   String
  property :album,    String
  property :track,    Integer

  validates_is_unique :filename
  before :create, :load_song_info

  def file
    File.new(APP[:library_dir] + '/' + filename)
  end

  private
    # Loads ID3 tags
    def load_song_info
      raise "File '#{APP[:library_dir] + '/' + filename}' does not exist!" unless File.exists?(APP[:library_dir] + '/' + filename)
      # These often have extra characters in them, I wish ID3Lib took care of them properly!
      self.attributes = {
        :title  => tag.title.nil? ? nil : tag.title.inspect.gsub(/^\\376\\377/,'').gsub(/\\000/,'').gsub(/^"(.*)"$/,'\1'),
        :artist => tag.artist.nil? ? nil : tag.artist.inspect.gsub(/^\\376\\377/,'').gsub(/\\000/,'').gsub(/^"(.*)"$/,'\1'),
        :album  => tag.album.nil? ? nil : tag.album.inspect.gsub(/^\\376\\377/,'').gsub(/\\000/,'').gsub(/^"(.*)"$/,'\1'),
        :track  => tag.track.nil? ? nil : tag.track.inspect.gsub(/^\\376\\377/,'').gsub(/\\000/,'').gsub(/^"(.*)"$/,'\1'),
      }
      puts "Attributes: #{self.attributes.inspect}"
    end
    def tag
      @tag ||= ID3Lib::Tag.new(APP[:library_dir] + '/' + filename)
    end
end

Catalog.auto_migrate! unless File.exist?('musicbox_development.sqlite3')
