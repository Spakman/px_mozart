$LOAD_PATH.unshift "#{ENV['PROJECT_X_BASE']}/lib/"
require "spandex/assertions"

module Messier
  class Model
    TABLE_FILEPATH = "#{File.expand_path('test/testtable')}"
  end
end

require_relative "../lib/music_card"

class Messier::Track
  def self.pk(key)
    case key
    when "1"
      Struct.new(:url, :name, :artist, :album).new("file://#{File.expand_path('test/dlanod.ogg')}", "Donald", "Spakman", "Spakwards")
    when "2"
      Struct.new(:url, :name).new("file://#{File.expand_path('test/troosers.ogg')}", "Troosers")
    end
  end
end

class MusicCardTest < Test::Unit::CardTestCase
  def setup
    setup_card_test Mozart::MusicCard
    Mozart::Playlist.instance.clear!
    Mozart::Playlist.instance.owner = "not the card instance"
  end

  def test_play_ids
    # setup a playlist to ensure play_ids overwrites this
    Mozart::Playlist.instance << "file://#{File.expand_path('test/donald.ogg')}"

    @card.play_ids("1, 2")
    sleep 0.6
    assert_equal 2, Mozart::Playlist.instance.size
    assert Mozart::Player.instance.playing?
  end

  def test_queue_ids_already_playing_playlist
    # setup a playlist to ensure queue_ids adds to this
    Mozart::Playlist.instance.owner = @card
    Mozart::Playlist.instance << "file://#{File.expand_path('test/donald.ogg')}"
    sleep 0.3
    Mozart::Player.instance.play

    @card.queue_ids("1, 2")
    sleep 0.3
    assert_equal 3, Mozart::Playlist.instance.size
    assert Mozart::Player.instance.playing?
  end

  def test_queue_ids_switching_playlist_owner
    # setup a playlist to ensure queue_ids adds to this
    Mozart::Playlist.instance << "file://#{File.expand_path('test/donald.ogg')}"
    sleep 0.3
    Mozart::Player.instance.play

    @card.queue_ids("1, 2")
    sleep 0.3
    assert_equal 2, Mozart::Playlist.instance.size
    assert Mozart::Player.instance.playing?
  end

  def test_jog_wheel_button
    # setup a playlist to ensure queue_ids adds to this
    Mozart::Playlist.instance << "file://#{File.expand_path('test/donald.ogg')}"
    sleep 0.3
    Mozart::Player.instance.play

    sleep 0.3
    assert Mozart::Player.instance.playing?
    @card.jog_wheel_button
    sleep 0.2
    refute Mozart::Player.instance.playing?
    @card.jog_wheel_button
    sleep 0.2
    assert Mozart::Player.instance.playing?
  end

  def test_show
    @card.play_ids("1, 2")
    sleep 0.5
    @card.show
    sleep 0.5
    assert_button_label :top_left, "Back"
    assert_button_label :bottom_left, "Previous"
    assert_button_label :bottom_right, "Next"
    assert_text "Donald"
    assert_text "1/2"
    assert_text "Spakman"
    assert_text "Spakwards"
  end
end
