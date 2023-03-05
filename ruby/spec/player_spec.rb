# frozen_string_literal: true

require 'player'
require 'room'

RSpec.describe Player do
  subject(:player) { described_class.new(3) }

  describe '#lives' do
    it 'retuns the number of lives' do
      expect(player.lives).to eq(3)
    end
  end

  describe '#current_room' do
    let(:room) { Room.new('Title', 'Description') }

    it 'stores the current room' do
      player.goto(room)
      expect(player.current_room).to eq(room)
    end
  end

  describe '#goto' do
    let(:room) { Room.new('Title', 'Description') }

    it 'stores the current room' do
      expect { player.goto(room) }.to(change { player.current_room })
    end

    it 'must receive a value' do
      expect { player.goto(nil) }.to raise_error(ArgumentError)
    end
  end

  describe '#alive?' do
    it 'is true when lives is positive' do
      player = described_class.new(1)
      expect(player).to be_alive
    end

    it 'is false when lives is less than one' do
      player = described_class.new(0)
      expect(player).to_not be_alive
    end
  end

  describe '#injure!' do
    it 'lowers the amount of lives' do
      expect { player.injure! }
        .to change { player.lives }.by(-1)
    end

    it 'lowers the amount of lives by the given value' do
      expect { player.injure!(3) }
        .to change { player.lives }.by(-3)
    end
  end
end
