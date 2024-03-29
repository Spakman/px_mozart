# Copyright (C) 2010 Mark Somerville <mark@scottishclimbs.com>
# Released under the General Public License (GPL) version 3.
# See COPYING

require "spandex/list"
require_relative "seeking_card"

module Mozart
  class MusicOptionsCard < Spandex::Card
    include JogWheelListMethods

    top_left :back

    jog_wheel_button method: -> do
      case @list.selected_name
      when "Shuffle", "Unshuffle"
        @playlist.toggle_shuffled_state
        @application.previous_card
      when "Seek in track"
        load_card Mozart::SeekingCard, playlist: params[:playlist]
      end
    end

    def after_load
      @playlist = params[:playlist]
      @list = Spandex::List.new [
        -> { @playlist.shuffled? ? "Unshuffle" : "Shuffle" },
        "Seek in track"
      ]
    end

    def show
      render %{
        <button position=top_left>Back</button>
        #{@list.to_s}
      }
    end
  end
end
