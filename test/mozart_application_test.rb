require_relative "test_helper"
require "honcho/message"
require_relative "../lib/mozart_application"
require_relative "../lib/card_switcher_card"

class Mozart::MozartApplication < Spandex::Application
  attr_reader :cards
  attr_accessor :has_focus
  entry_point Mozart::CardSwitcherCard
  can_run_in_background
end

class TestCard < Spandex::Card
  def show
    render "hello"
  end
end

class SecondTestCard < Spandex::Card
  def show
    render "bye"
  end
end

class MozartApplicationTest < Test::Unit::TestCase
  def setup
    @socket_path = "/tmp/#{File.basename($0)}.socket"
    FileUtils.rm_f @socket_path
    listening_socket = UNIXServer.open @socket_path
    listening_socket.listen 1
    Thread.new do
      @socket = listening_socket.accept
    end
    @application = Mozart::MozartApplication.new
  end

  def test_previous_card_when_passfocusing_application
    @application.has_focus = true
    @application.load_card TestCard
    sleep 0.2
    @socket.read(16)
    @application.previous_card
    refute @application.has_focus
    assert_equal "<passfocus 0>\n", @socket.read(14)
    assert_equal 1, @application.cards.size
    assert_kind_of Mozart::CardSwitcherCard, @application.cards.last
  end

  def test_previous_card_when_multiple_non_card_switcher_cards
    @application.load_card TestCard
    @application.load_card SecondTestCard
    assert_equal 3, @application.cards.size
    @application.previous_card
    assert_equal 2, @application.cards.size
    assert_kind_of TestCard, @application.cards.last
  end
end
