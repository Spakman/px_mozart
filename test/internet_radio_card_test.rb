$LOAD_PATH.unshift "#{ENV['PROJECT_X_BASE']}/lib/"
require "spandex/assertions"
require_relative "../lib/internet_radio_card"

class InternetRadioCardTest < Test::Unit::CardTestCase
  def setup
    setup_card_test Mozart::InternetRadioCard
    Mozart::Playlist.clear!
  end

  def test_play_stream
    # setup a playlist to ensure play_stream overwrites this
    Mozart::Playlist.instance << "file://#{File.expand_path('test/donald.ogg')}"
    Mozart::Playlist.instance << "file://#{File.expand_path('test/troosers.ogg')}"
    assert_equal 2, Mozart::Playlist.instance.size

    @card.play_stream("file://#{File.expand_path('test/dlanod.ogg')}")
    sleep 0.6
    assert_equal 1, Mozart::Playlist.instance.size
    assert Mozart::Player.instance.playing?
  end
end
