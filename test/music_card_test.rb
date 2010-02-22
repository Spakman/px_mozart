require_relative "test_helper"
require_relative "../lib/music_card"

class Mozart::MusicCard
  attr_accessor :playlist
end

class MusicCardTest < Test::Unit::CardTestCase
  def setup
    setup_card_test Mozart::MusicCard
  end

  def teardown
    Mozart::Player.instance.quiesce
  end

  def test_play_ids
    # setup a playlist to ensure play_ids overwrites this
    @card.playlist = Mozart::Playlist.new
    @card.playlist << Struct.new(:url).new("file://#{File.expand_path('test/donald.ogg')}")

    @card.play_ids("1, 2")
    sleep 0.6
    assert_equal 2, @card.playlist.size
    assert Mozart::Player.instance.playing?
  end

  def test_queue_ids_already_playing_playlist
    # setup a playlist to ensure queue_ids adds to this
    @card.playlist = Mozart::Playlist.new
    @card.playlist << Struct.new(:url).new("file://#{File.expand_path('test/donald.ogg')}")
    sleep 0.3
    Mozart::Player.instance.playlist = @card.playlist

    @card.queue_ids("1, 2")
    sleep 0.3
    assert_equal 3, @card.playlist.size
    assert Mozart::Player.instance.playing?
  end

  def test_queue_ids_to_empty_playlist_switching_playlist_owner
    # setup a playlist to ensure queue_ids adds to this
    radio_playlist = Mozart::Playlist.new
    radio_playlist << Struct.new(:url).new("file://#{File.expand_path('test/donald.ogg')}")
    sleep 0.3
    Mozart::Player.instance.playlist = radio_playlist

    @card.queue_ids("1, 2")
    sleep 0.3
    assert_equal 2, @card.playlist.size
    assert Mozart::Player.instance.playing?
  end

  def test_queue_ids_to_populated_playlist_switching_playlist_owner
    @card.playlist << Struct.new(:url).new("file://#{File.expand_path('test/donald.ogg')}")
    # setup a playlist to ensure queue_ids adds to this
    radio_playlist = Mozart::Playlist.new
    radio_playlist << Struct.new(:url).new("file://#{File.expand_path('test/donald.ogg')}")
    sleep 0.3
    Mozart::Player.instance.playlist = radio_playlist

    @card.queue_ids("1, 2")
    sleep 0.3
    assert_equal 3, @card.playlist.size
    assert Mozart::Player.instance.playing?
    assert @card.playlist.active?
  end

  def test_jog_wheel_button
    # setup a playlist to ensure queue_ids adds to this
    @card.playlist = Mozart::Playlist.new
    @card.playlist << "file://#{File.expand_path('test/donald.ogg')}"
    sleep 0.3
    Mozart::Player.instance.playlist = @card.playlist

    sleep 3
    assert Mozart::Player.instance.playing?
    @card.jog_wheel_button
    sleep 0.2
    refute Mozart::Player.instance.playing?
    @card.jog_wheel_button
    sleep 0.2
    assert Mozart::Player.instance.playing?
  end

  def test_top_right
    @card.top_right
    assert_card Mozart::MusicOptionsCard
  end

  def test_show
    @card.play_ids("1, 2")
    sleep 0.5
    @card.show
    sleep 0.5
    assert_button_label :top_left, "Back"
    assert_button_label :top_right, "Options"
    assert_button_label :bottom_left, "Previous"
    assert_button_label :bottom_right, "Next"
    assert_text "Donald"
    assert_text "1/2"
    assert_text "Spakman"
    assert_text "Spakwards"
  end
end
