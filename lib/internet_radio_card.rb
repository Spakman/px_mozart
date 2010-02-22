# Copyright (C) 2010 Mark Somerville <mark@scottishclimbs.com>
# Released under the General Public License (GPL) version 3.
# See COPYING

require "spandex/card"
require "libmozart/playlist"

module Mozart
  class InternetRadioCard < Spandex::Card
    top_left :back

    def play_stream(stream)
      @playlist = Mozart::Playlist.new
      @playlist << stream
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
