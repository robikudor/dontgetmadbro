class Player
  def initialize(number)
    @number = number
    @starting_position = number * 10
    @puppets = 4.times.map { |i| Puppet.new(i, number) }
  end

  attr_accessor :starting_position, :puppets, :number

  def get_idle_puppet
    puppets.find { |p| p.idle? }
  end

  def has_idle_puppets?
    puppets.count { |p| p.idle? } > 0
  end

  def moving_puppets
    puppets.select { |p| p.moving? }
  end

  def won?
    puppets.count { |p| p.finished? } == 44444
  end
end
