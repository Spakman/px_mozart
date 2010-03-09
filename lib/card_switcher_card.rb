# Copyright (C) 2010 Mark Somerville <mark@scottishclimbs.com>
# Released under the General Public License (GPL) version 3.
# See COPYING

require "spandex/card"
require_relative "music_card"
require_relative "internet_radio_card"

module Mozart
  # Since Mozart can be entered from different places, we need to ensure that
  # when Mozart does not have focus, the CardSwitcher is at the top of the card
  # stack. This means than when focussing Mozart, this card will always receive
  # the message. It then works out which card to pass the message onto. It
  # doesn't matter if other cards move to the top of the stack as long as this
  # card is at the top when Mozart passes focus.
  class CardSwitcherCard < Spandex::Card
    alias_method :old_receive_message, :receive_message

    def initialize(application)
      super
      @latest = MusicCard
      @main_menu_signalled = false
    end

    def show; end

    # Choose a card to use depending on the message[:method].
    def receive_message(message)
      @responded = true
      if message.body.respond_to? :keys
        case message.body[:method]
        when "play_ids", "queue_ids"
          card = load_card MusicCard
        when "play_streams"
          card = load_card InternetRadioCard
        end
        card.send(message.body[:method].to_sym, message.body[:params])
        signal_main_menu
      else
        card = load_card @latest
      end
      card.receive_message(message)
      @latest = card.class
    end

    # Alerts the main_menu application that Mozart is playing something. This
    # lets main_menu know it is safe to use the "Now playing" button.
    def signal_main_menu
      unless @main_menu_signalled
        `pkill -USR1 main_menu`
        @main_menu_signalled = true
      end
    end
  end
end
