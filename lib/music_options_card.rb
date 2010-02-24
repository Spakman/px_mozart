# Copyright (C) 2010 Mark Somerville <mark@scottishclimbs.com>
# Released under the General Public License (GPL) version 3.
# See COPYING

require "spandex/list"

module Mozart
  class MusicOptionsCard < Spandex::Card
    top_left :back

    jog_wheel_button method: -> do
      case @list.selected_name
      when "Shuffle", "Unshuffle"
        @playlist.toggle_shuffled_state
        @application.previous_card
        respond_keep_focus
      end
    end

    def params=(params)
      @playlist = params
      @list = Spandex::List.new [
        -> { @playlist.shuffled? ? "Unshuffle" : "Shuffle" }
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
