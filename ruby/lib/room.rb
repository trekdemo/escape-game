class Room
  attr_accessor :title, :description
  attr_reader :actions

  def initialize(title, description = nil)
    @title = title
    @description = description
    @actions = []
  end

  def add(*actions)
    @actions.concat(actions)
  end

  def remove(*actions)
    actions.each do |action|
      @actions.delete(action)
    end
  end
end
