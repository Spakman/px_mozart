# Copyright (C) 2010 Mark Somerville <mark@scottishclimbs.com>
# Released under the General Public License (GPL) version 3.
# See COPYING

require "spandex/card"

module Mozart
  class MusicCard < Spandex::Card
    top_left :back

    def show
      render %{
        <button position="top_left">Back</button>
        <text y="30">Music</text>
      }
    end
  end
end
