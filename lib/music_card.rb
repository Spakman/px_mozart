# Copyright (C) 2010 Mark Somerville <mark@scottishclimbs.com>
# Released under the General Public License (GPL) version 3.
# See COPYING

require "spandex/card"
require "messier/models/track"
require "libmozart/playlist"

module Mozart
  class MusicCard < Spandex::Card
    top_left :back

    def play_ids(ids)
      @playlist = Mozart::Playlist.instance
      @playlist.owner = self
      @playlist.clear!
      add_to_playlist(ids)
      @playlist.rock_and_roll
    end

    def add_to_playlist(ids)
      ids.split(", ").each do |id|
        track = Messier::Track.pk(id)
        @playlist << track.url unless track.nil?
      end
    end

    def queue_ids(ids)
      @playlist = Mozart::Playlist.instance
      if @playlist.owner != self
        play_ids(ids)
      else
        add_to_playlist(ids)
      end
    end

    def show
      render %{
        <button position="top_left">Back</button>
        <text y="30">Music</text>
      }
    end
  end
end
