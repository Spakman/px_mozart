$LOAD_PATH.unshift "#{ENV['PROJECT_X_BASE']}/lib/"
require "spandex/assertions"
require_relative "../lib/internet_radio_card"

class Mozart::InternetRadioCard < Spandex::Card
  attr_accessor :playlist
end

class InternetRadioCardTest < Test::Unit::CardTestCase
  def setup
    setup_card_test Mozart::InternetRadioCard
  end

  def teardown
    Mozart::Player.quiesce
  end

  def test_play_stream
    # setup a playlist to ensure play_stream overwrites this
    playlist = Mozart::Playlist.new("music")
    playlist << "file://#{File.expand_path('test/donald.ogg')}"
    playlist << "file://#{File.expand_path('test/troosers.ogg')}"
    Mozart::Player.instance.playlist = playlist
    sleep 0.3
    @card.play_stream("file://#{File.expand_path('test/dlanod.ogg')}")
    sleep 0.6
    assert Mozart::Player.instance.playing?
    sleep 0.5
    assert @card.playlist.active?
    assert_equal 1, @card.playlist.size
  end
end
