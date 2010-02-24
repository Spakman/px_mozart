# Copyright (C) 2010 Mark Somerville <mark@scottishclimbs.com>
# Released under the General Public License (GPL) version 3.
# See COPYING

require "spandex/card"
require "messier/models/track"
require "libmozart/playlist"
require_relative "music_options_card"

Thread.abort_on_exception = true

module Mozart
  class MusicCard < Spandex::Card
    attr_reader :playlist

    top_left :back
    top_right card: MusicOptionsCard, params: -> { @playlist }
    bottom_left method: -> { Mozart::Player.instance.previous_track; show }
    bottom_right method: -> { Mozart::Player.instance.next_track; show }
    jog_wheel_button method: -> { Mozart::Player.instance.play_or_pause; show }

    IMAGE_PATH = File.expand_path(File.dirname(__FILE__) + '/img/')

    def after_initialize
      @playlist = Mozart::Playlist.new
    end

    # Clears the music playlist and populates it with the passed ids and starts
    # playing.
    def play_ids(ids)
      @playlist = Mozart::Playlist.new
      add_to_playlist(ids)
      Mozart::Player.instance.playlist = @playlist
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
      if @playlist.empty?
        play_ids(ids)
      else
        add_to_playlist(ids)
        unless @playlist.active?
          Mozart::Player.instance.playlist = @playlist
        end
      end
    end

    # Show is called once before the playlist is initialised so we need to
    # catch that case. Also, when the playlist is cleared and replaced with
    # other tracks, the render thread will sometimes try to access the
    # current_track.name while there are no tracks in the playlist. We rescue a
    # NoMethodError to get around this race condition.
    def show
      return if @playlist.nil? or @playlist.empty? or @playlist.current_track.nil?
      render_every 1 do
        %{
          <button position="top_left">Back</button>
          <button position="top_right">Options</button>
          <button position="bottom_left">Previous</button>
          <button position="bottom_right">Next</button>
          <text y="10" halign="centre">#{@playlist.current_track.name}</text>
          <text y="20" halign="centre">#{@playlist.current_track.album}</text>
          <text y="30" halign="centre">#{@playlist.current_track.artist}</text>
          <text y="40" width="240" halign="right">#{@playlist.position}/#{@playlist.size}</text>
          <text y="40" x="25" width="225" halign="left">#{Mozart::Player.instance.position}/#{Mozart::Player.instance.duration}</text>
          <image x="6" y="36" path="#{IMAGE_PATH}/#{Mozart::Player.instance.paused? ? 'pause' : 'play'}.png" />
        }
      end
    end
  end
end
