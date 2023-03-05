# frozen_string_literal: true

require 'stringio'

require 'tui'
require 'room'

RSpec.describe TUI do
  let(:inp) { StringIO.new }
  let(:out) { StringIO.new }
  let(:output) { out.string }
  let(:ui) { described_class.new(inp, out) }

  describe '#display' do
    it 'prints a message' do
      ui.display('Message')
      expect(output).to eq("Message\n")
    end

    it 'prints new line without arguments' do
      ui.display
      expect(output).to eq("\n")
    end
  end

  describe '#display_actions' do
    it 'prints out a list of actions' do
      actions = ['action 1', 'action 2']
      ui.display_actions(actions)
      expect(output).to eq(<<~OUT)
        You can...
        [1] action 1
        [2] action 2
      OUT
    end

    it 'does not print without actions' do
      ui.display_actions([])
      expect(output).to eq('')
    end
  end

  describe '#display_header' do
    it 'prints header' do
      ui.display_header('Header')
      expect(output).to eq("\nHEADER\n")
    end
  end

  describe '#display_room' do
    it 'displays a room' do
      room = Room.new('Title', 'Description')
      ui.display_room(room)
      expect(output).to eq("\nTITLE\nDescription\n")
    end
  end

  describe '#ask' do
    it 'prints the question and a prompt' do
      inp.string = "My answer\n"
      ui.ask('What?')
      expect(output).to eq(<<~OUT.strip)
        What?
        >
      OUT
    end

    it 'prints only a prompt without question' do
      inp.string = "My answer\n"
      ui.ask
      expect(output).to eq('>')
    end

    it 'returns with the input from the user' do
      inp.string = "My answer\n"
      expect(ui.ask('What?')).to eq('My answer')
    end
  end
end
