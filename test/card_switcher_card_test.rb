require_relative "test_helper"
require "honcho/message"
require_relative "../lib/card_switcher_card"

class Mozart::MusicCard
  attr_reader :params
  def params=(params)
    @params = params
  end
end

class Mozart::CardSwitcherCard
  attr_accessor :latest
end

class CardSwitcherCardTest < Test::Unit::CardTestCase
  def setup
    setup_card_test Mozart::CardSwitcherCard
  end

  def teardown
    Mozart::Player.quiesce
  end

  def test_play_ids_switches_to_music_card
    @card.receive_message Honcho::Message.new(:pass_focus, method: "play_ids", params: "1, 2")
    assert_kind_of Mozart::MusicCard, @application.cards.last
  end

  def test_queue_ids_switches_to_music_card
    @card.receive_message Honcho::Message.new(:pass_focus, method: "queue_ids", params: "1, 2")
    assert_kind_of Mozart::MusicCard, @application.cards.last
  end

  def test_play_stream_switches_to_internet_radio_card
    @card.receive_message Honcho::Message.new(:pass_focus, method: "play_stream", params: "http://test.stream")
    assert_kind_of Mozart::InternetRadioCard, @application.cards.last
  end

  def test_no_params_switches_to_last_card
    @card.latest = Mozart::InternetRadioCard
    @card.receive_message Honcho::Message.new(:have_focus)
    assert_kind_of Mozart::InternetRadioCard, @application.cards.last
  end
end
