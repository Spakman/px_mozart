# Copyright (C) 2010 Mark Somerville <mark@scottishclimbs.com>
# Released under the General Public License (GPL) version 3.
# See COPYING

require "spandex/card"
require "libmozart/playlist"

module Mozart
  class InternetRadioCard < Spandex::Card
    top_left :back

    jog_wheel_button method: -> do
      Mozart::Player.instance.play_or_pause
      show
    end

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
      render_every 1 do
        if Mozart::Player.instance.playing?
          %{
            <button position="top_left">Back</button>
            <text y="10">Internet radio</text>
            <text y="20">#{Mozart::Player.instance.artist}</text>
            <text y="30">#{Mozart::Player.instance.album}</text>
            <text y="40">#{Mozart::Player.instance.track}</text>
          }
        elsif Mozart::Player.instance.paused?
          %{
            <button position="top_left">Back</button>
            <text halign="centre" valign="centre">Paused</text>
          }
        else
          %{
            <button position="top_left">Back</button>
            <text halign="centre" valign="centre">Connecting...</text>
          }
        end
      end
    end
  end
end
