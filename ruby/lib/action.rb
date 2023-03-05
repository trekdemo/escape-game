# frozen_string_literal: true

# Actino is a block of logic with a human readable name
class Action
  attr_reader :name

  def initialize(name, &callback)
    @name = name
    @callback = callback
  end

  def do
    @callback&.call(self)
  end

  def to_s
    @name
  end
end

def Action(name, &callback)
  Action.new(name, &callback)
end
