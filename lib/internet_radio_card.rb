# Copyright (C) 2010 Mark Somerville <mark@scottishclimbs.com>
# Released under the General Public License (GPL) version 3.
# See COPYING

require "spandex/card"
require "libmozart/playlist"

module Mozart
  class InternetRadioCard < Spandex::Card
    top_left :back

    def play_streams(streams)
      @playlist = Mozart::Playlist.new
      if streams.respond_to? :split
        streams.split(", ").each do |stream|
          if stream.start_with? '"' and stream.end_with? '"'
            @playlist << stream[1,stream.length-2]
          else
            @playlist << stream
          end
        end
      else
        @playlist << streams
      end
      Mozart::Player.instance.playlist = @playlist
    end

    def show
      render %{
        <button position="top_left">Back</button>
        <text y="30">Internet radio</text>
      }
    end
  end
end
