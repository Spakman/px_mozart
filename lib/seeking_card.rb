# Copyright (C) 2010 Mark Somerville <mark@scottishclimbs.com>
# Released under the General Public License (GPL) version 3.
# See COPYING

require "spandex/list"

module Mozart
  class SeekingCard < Spandex::Card
    top_left :back

    jog_wheel_right method: -> do
      Mozart::Player.instance.seek_forwards
    end

    jog_wheel_left method: -> do
      Mozart::Player.instance.seek_backwards
    end

    jog_wheel_button method: -> do
      back_until Mozart::MusicCard
    end

    def show
      render_every 1 do
        %{
          <button position=top_left>Back</button>
          <title>Seeking</title>
          <text y="20" halign="centre">#{params[:playlist].current_track.name}</text>
          <text y="40" x="25" halign="left">#{Mozart::Player.instance.position}</text>
          <text y="40" width="231" halign="right">#{Mozart::Player.instance.duration}</text>
        }
      end
    end
  end
end
