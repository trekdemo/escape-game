# frozen_string_literal: true

require 'room'

RSpec.describe Room do
  subject(:room) { described_class.new('Room A', 'This is a square room.') }

  describe '#title' do
    specify { expect(room.title).to eq('Room A') }
  end

  describe '#description' do
    specify { expect(room.description).to eq('This is a square room.') }
  end

  describe '#actions' do
    specify { expect(room.actions).to eq([]) }
  end

  describe '#add' do
    it 'appends actions to the room' do
      expect { room.add('action') }.to(change { room.actions })
    end

    it 'appends multiple actions' do
      expect { room.add('one', 'two') }.to(change { room.actions })
      expect(room.actions).to eq(%w[one two])
    end
  end

  describe '#delete' do
    it 'removes the action from the room' do
      action = 'action'
      room.add(action)
      expect { room.remove(action) }.to(change { room.actions }.to([]))
    end

    it 'removes multiple actions from the room' do
      one = 'one'
      two = 'two'
      room.add(one, two)
      expect { room.remove(one, two) }.to(change { room.actions }.to([]))
    end
  end
end
