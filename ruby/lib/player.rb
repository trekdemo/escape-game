class Player
  attr_reader :lives, :current_room

  def initialize(lives = 3)
    @lives = lives
  end

  def goto(room)
    raise ArgumentError unless room

    @current_room = room
  end

  def alive?
    lives.positive?
  end

  def injure!(value = 1)
    @lives -= value
  end
end
