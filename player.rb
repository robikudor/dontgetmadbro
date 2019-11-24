class Player
  def initialize(number)
    @number = number
    @starting_position = number * 10
    @puppets = 4.times.map { |i| Puppet.new(i, number) }
  end

  attr_accessor :starting_position, :puppets, :number

  def select_puppet(dice)
    return get_idle_puppet if dice == 6 and has_idle_puppets?
    select_moving_puppet
  end

  def select_moving_puppet
    puts "Which puppet you want to move? (Press enter to select the first one)"
    available_puppets = moving_puppets
    available_puppets.each { |p| puts p.id }
    user_input_id = gets.chomp.to_i
    available_puppets.find { |p| p.id == user_input_id } || available_puppets.first
  end

  def get_idle_puppet
    puppets.find { |p| p.idle? }
  end

  def has_idle_puppets?
    puppets.count { |p| p.idle? } > 0
  end

  def moving_puppets
    puppets.select { |p| p.moving? }
  end

  def finished_puppets
    puppets.select { |p| p.finished? }.map { |p| p.steps_left }
  end

  def won?
    puppets.all? { |p| p.finished? }
  end
end
