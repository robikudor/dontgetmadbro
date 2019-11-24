class Board
  def initialize()
    @board = Array.new(40) { [] }
  end

  def start_with_puppet(player)
    position = player.starting_position
    puppet = player.get_idle_puppet
    puppet.start_move
    board[position] << puppet
  end

  def move(player, dice, puppet)
    if dice == 6 && player.has_idle_puppets?
      start_with_puppet(player)
    else
      finished = puppet.move(dice)
      board_move(puppet, dice, finished)
    end
  end

  def board_move(puppet, dice, finished)
    position = find_puppet_location(puppet)
    board[position].delete(puppet)
    unless finished
      new_pos = (position + dice) % 40
      kick_puppet(new_pos, puppet)
      board[new_pos] << puppet
    end
  end

  # finish kicking
  def kick_puppet(position, puppet)
    return if board[position].empty?
    board[position].each do |p|
      p.team != puppet.team
      p.reset_puppet
      board[position].delete(p)
    end
  end

  def find_puppet_location(puppet)
    board.index { |field| field.include?(puppet) }
  end

  def roll_dice
    rand 1..6
  end

  attr_accessor :board
end
