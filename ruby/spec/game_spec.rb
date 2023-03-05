# frozen_string_literal: true

require 'game'
require 'stringio'

RSpec.describe Game do
  let(:input) { StringIO.new }
  let(:out) { StringIO.new }
  let(:ui) { TUI.new(input, out) }
  let(:output) { out.string }
  subject(:game) { described_class.new(ui) }

  describe '#goto' do
    let(:room) { Room.new('Title', 'Description') }

    it 'stores the current room' do
      expect { game.goto(room) }.to(change { game.current_room })
    end

    it 'must receive a value' do
      expect { game.goto(nil) }.to raise_error(ArgumentError)
    end

    it 'displays the title and the description of the room' do
      game.goto(room)
      expect(output).to eq("\nTITLE\nDescription\n")
    end
  end

  describe '#look' do
    let(:room) { Room.new('Title', 'Description') }

    it 'displays the title and the description of the room' do
      game.goto(room)
      out.truncate(0)
      out.rewind
      game.look
      expect(output).to eq("\nTITLE\nDescription\n")
    end
  end

  describe '#injure!' do
    it 'lowers the amount of lives' do
      expect { game.injure! }
        .to change { game.player.lives }.by(-1)
    end

    it 'prints remaining lives' do
      game.injure!
      expect(output).to eq("You have 2 lives remaining.\n")
    end
  end

  describe '#win' do
    it 'displays YOU WON!' do
      expect { game.win }.to raise_error(UncaughtThrowError)
      expect(output).to eq("\nYOU WON!\n")
    end
  end

  describe '#lost' do
    it 'displays GAME OVER!' do
      expect { game.lost }.to raise_error(UncaughtThrowError)
      expect(output).to eq("\nGAME OVER!\n")
    end
  end

  describe '#loop (game loop)' do
    # The game will read the input line by line when there is a question
    # Each line answers the ">" prompt.
    let(:input) { StringIO.new("exit\n") }
    let(:room) { Room.new('Title', 'Description') }

    before do
      game.goto(room)
      out.truncate(0)
      out.rewind
    end

    it 'displays the available actions' do
      room.add('do this')
      room.add('do that')

      game.loop
      expect(output).to eq(<<~OUT)
        You can...
        [1] do this
        [2] do that
        >
        GAME OVER!
      OUT
    end

    it 'finishes with GAME OVER when the player dies' do
      player = Player.new(0) # Dead already
      game = described_class.new(ui, player)

      game.loop
      expect(output).to eq(<<~OUT)

        GAME OVER!
      OUT
    end

    describe 'the exit command' do
      let(:input) { StringIO.new("exit\n") }

      it 'exits on the exit command' do
        game.loop
        expect(output).to eq(<<~OUT)
          >
          GAME OVER!
        OUT
      end
    end

    describe 'the help command' do
      let(:input) { StringIO.new("help\nexit\n") }

      it 'prints the help' do
        game.loop
        expect(output).to include('To choose a listed option enter')
      end
    end

    describe 'the look command' do
      let(:input) { StringIO.new("look\nexit\n") }

      it 'prints description of the room' do
        game.loop
        expect(output).to eq(<<~OUT)
          >
          TITLE
          Description
          >
          GAME OVER!
        OUT
      end
    end

    describe 'unrecognized commands' do
      let(:input) { StringIO.new("other things\nexit\n") }
      it 'prints a reference to the help command' do
        game.loop
        expect(output).to eq(<<~OUT)
          >Invalid command; use 'help' to learn what commands are available.
          >
          GAME OVER!
        OUT
      end
    end

    describe 'choosing an action' do
      let(:input) { StringIO.new("1\nexit\n") }

      it 'prints description of the room' do
        kitchen = Room.new('Kitchen', 'with food')
        room.add(Action('go to the kitchen.') { game.goto(kitchen) })

        game.loop
        expect(output).to eq(<<~OUT)
          You can...
          [1] go to the kitchen.
          >
          KITCHEN
          with food
          >
          GAME OVER!
        OUT
      end
    end

    describe 'choosing an invalid action' do
      let(:input) { StringIO.new("2\nexit\n") }

      it 'prints description of the room' do
        kitchen = Room.new('Kitchen', 'with food')
        room.add(Action('go to the kitchen.') { game.goto(kitchen) })

        game.loop
        expect(output).to eq(<<~OUT)
          You can...
          [1] go to the kitchen.
          >Invalid choice!
          You can...
          [1] go to the kitchen.
          >
          GAME OVER!
        OUT
      end
    end
  end
end
