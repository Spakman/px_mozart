$LOAD_PATH.unshift "#{ENV['PROJECT_X_BASE']}/lib/"
require "spandex/assertions"

Thread.abort_on_exception = true

module Messier
  class Model
    TABLE_FILEPATH = "#{File.expand_path('test/testtable')}"
  end
end

# require Track here so that we can ensure self.pk is overridden.
require "messier/models/track"

class Messier::Track < Messier::Model
  def self.pk(key)
    case key
    when "1"
      Struct.new(:url, :name, :artist, :album).new("file://#{File.expand_path('test/dlanod.ogg')}", "Donald", "Spakman", "Spakwards")
    when "2"
      Struct.new(:url, :name).new("file://#{File.expand_path('test/troosers.ogg')}", "Troosers")
    end
  end
end
