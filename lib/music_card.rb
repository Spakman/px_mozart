# Copyright (C) 2010 Mark Somerville <mark@scottishclimbs.com>
# Released under the General Public License (GPL) version 3.
# See COPYING

require "spandex/card"
require "messier/models/track"
require "libmozart/playlist"

Thread.abort_on_exception = true

module Mozart
  class MusicCard < Spandex::Card
    top_left :back
    bottom_left method: -> { Mozart::Player.instance.previous_track; show }
    bottom_right method: -> { Mozart::Player.instance.next_track; show }
    jog_wheel_button method: -> { Mozart::Player.instance.play_or_pause; show }

    def play_ids(ids)
      @playlist = Mozart::Playlist.instance
      @playlist.owner = self
      @playlist.clear!
      add_to_playlist(ids)
      @playlist.rock_and_roll
    end

    # Add ids to the playlist. Called from play_ids or queue_ids.
    def add_to_playlist(ids)
      if ids.respond_to? :split
        ids.split(", ").each do |id|
          track = Messier::Track.pk(id)
          @playlist << track unless track.nil?
        end
      else
        track = Messier::Track.pk(ids.to_s)
        @playlist << track unless track.nil?
      end
    end

    # Enqueues ids. Will also start playing the playlist if Mozart is currently
    # playing something else.
    def queue_ids(ids)
      @playlist = Mozart::Playlist.instance
      if @playlist.owner != self
        play_ids(ids)
      else
        add_to_playlist(ids)
      end
    end

    # Show is called once before the playlist is initialised so we need to
    # catch that case. Also, when the playlist is cleared and replaced with
    # other tracks, the render thread will sometimes try to access the
    # current_track.name while there are no tracks in the playlist. We rescue a
    # NoMethodError to get around this race condition.
    def show
      return if @playlist.nil?
      render_every 1 do
        %{
          <button position="top_left">Back</button>
          <button position="bottom_left">Previous</button>
          <button position="bottom_right">Next</button>
          <text y="10" halign="centre">#{@playlist.current_track.name}</text>
          <text y="20" halign="centre">#{@playlist.current_track.album}</text>
          <text y="30" halign="centre">#{@playlist.current_track.artist}</text>
          <text y="40" width="240" halign="right">#{@playlist.position}/#{@playlist.size}</text>
        } rescue NoMethodError
      end
    end
  end
end
