# Copyright (C) 2010 Mark Somerville <mark@scottishclimbs.com>
# Released under the General Public License (GPL) version 3.
# See COPYING

require "spandex/application"

module Mozart
  class MozartApplication < Spandex::Application
    alias_method :old_previous_card, :previous_card

    # To accomodate the CardSwitcher, we need a modified version of this method
    # to ensure that CardSwitcher is the only card on the stack when passing
    # focus.
    def previous_card
      card = @cards.pop
      if @cards.size == 1
        if can_run_in_background?
          @socket << Honcho::Message.new(:passfocus)
          card.responded = true
        else
          @socket << Honcho::Message.new(:closing)
          @socket.close
          exit
        end
      else
        @cards << card
        old_previous_card
      end
    end
  end
end
