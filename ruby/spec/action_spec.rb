# frozen_string_literal: true

require 'action'

RSpec.describe Action do
  subject(:action) { described_class.new('does some testing') }

  describe 'Action()' do
    subject(:action) { Action('another action') }

    it { is_expected.to be_an(Action) }
  end

  describe '#to_s' do
    it 'returns the name of the action' do
      expect(action.to_s).to eq('does some testing')
    end
  end

  describe '#do' do
    it 'executes the logic within the block' do
      value_to_change = 'old'
      action = Action('change values') { value_to_change = 'new' }

      expect { action.do }.to change { value_to_change }
        .from('old').to('new')
    end

    it 'codeblock has access to itself' do
      value_to_change = ''
      action = Action('change values') { |a| value_to_change = a.name }

      expect { action.do }.to change { value_to_change }
        .from('').to(action.name)
    end
  end
end
