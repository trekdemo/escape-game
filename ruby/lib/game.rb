# frozen_string_literal: true

require 'forwardable'

require 'action'
require 'player'
require 'room'
require 'tui'

class Game
  extend Forwardable
  def_delegators :ui, :display, :ask
  def_delegators :player, :current_room

  attr_reader :player, :ui

  def initialize(ui = TUI.new, player = Player.new(3))
    @ui = ui
    @player = player
  end

  def goto(room)
    player.goto(room)
    look
  end

  def look
    ui.display_room(current_room)
  end

  def injure!(value = 1)
    player.injure!(value)
    ui.display "You have #{player.lives} lives remaining."
  end

  def win
    ui.display_header 'You won!'
    throw :halt
  end

  def lost
    ui.display_header 'Game over!'
    throw :halt
  end

  def help
    ui.display <<~MESSAGE
      To choose a listed option enter the number of your choice shown within
      brackets.
      Additionally, you can use the following commands.

      help    Prints this message
      look    Display the description of the room.
      exit    Immediately leaves the game.
    MESSAGE
  end

  def loop
    catch :halt do
      while player.alive?
        ui.display_actions(current_room.actions)
        handle_input(ask)
      end

      lost
    end
  end

  private

  def handle_input(choice_or_command)
    case choice_or_command
    when /look/i then look
    when /exit/i then lost
    when /help/i then help
    when /\d+/
      if (action = current_room.actions[choice_or_command.to_i - 1])
        action.do
      else
        ui.display 'Invalid choice!'
      end
    else
      ui.display "Invalid command; use 'help' to learn what commands are available."
    end
  end
end
