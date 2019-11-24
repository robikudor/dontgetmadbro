class GameBoard
  PLAYER_COUNT = 4
  TABLE_HEADINGS = ['Puppet', 'Status', 'Moves to finish'].freeze

  def initialize
    @board = Array.new(40) { [] }
    @players = PLAYER_COUNT.times.map { |i| Player.new(i) }
    @game_ongoing = true
    @player_round = nil
  end

  def start_game
    start_with_puppets
    set_starting_player
    while @game_ongoing
      dice = user_roll
      move(dice)
      @player_round = (@player_round + 1) % PLAYER_COUNT unless dice == 6
      display_game_status
      check_win
    end
  end

  private

  attr_accessor :board

  def move(dice)
    # we select the players puppet which has to move
    puppet = current_player.select_puppet(dice)
    # this means we have no puppets on board
    return unless puppet
    if puppet.status == :idle
      add_puppet_to_board(puppet)
    else
      puppet_location = find_puppet_location(puppet)
      new_step = puppet.steps_left - dice
      # check if the puppet will enter to the final location
      if new_step <= 4
        # check to don't go furteher than it can
        if can_move?(new_step)
          board[puppet_location].delete(puppet)
          puppet.move(new_step)
          puppet.finish
        end
      else
        # otherwise we just move on the board
        new_pos = (puppet_location + dice) % 40
        board[puppet_location].delete(puppet)
        kick_puppet(new_pos, puppet)
        board[new_pos] << puppet
        puppet.move(new_step)
      end
    end
  end

  def kick_puppet(position, puppet)
    board[position].each do |p|
      if p.team != puppet.team
        p.reset_puppet
        board[position].delete(p)
      end
    end
  end

  def can_move?(new_step)
    new_step > 0 && !current_player.finished_puppets.include?(new_step)
  end

  def find_puppet_location(puppet)
    board.index { |field| field.include?(puppet) }
  end

  def current_player
    @players[@player_round]
  end

  def set_starting_player
    starting_rolls = PLAYER_COUNT.times.map { roll_dice }
    p starting_rolls
    # deciding which user starts
    @player_round = starting_rolls.index(starting_rolls.max)
    puts "#{@player_round} starts"
  end

  def check_win
    # we check if the current user won, other players can't win in this round
    if current_player.won?
      @game_ongoing = false
      puts "!!! PLAYER #{@player_round} WON !!!"
    end
  end

  def user_roll
    puts "Player #{@player_round}'s turn. Press enter to roll!"
    gets.chomp
    dice = roll_dice
    puts "You rolled #{dice}"
    dice
  end

  def roll_dice
    rand 1..6
  end

  def start_with_puppets
    @players.each do |player|
      puppet = player.get_idle_puppet
      board[player.starting_position] << puppet
      puppet.start_moving
    end
  end

  def add_puppet_to_board(puppet)
    position = current_player.starting_position
    kick_puppet(position, puppet)
    board[position] << puppet
    puppet.start_moving
  end

  def display_game_status
    @players.each do |player|
      rows = player.puppets.map { |p| [p.id, p.status, p.steps_left] }
      puts Terminal::Table.new headings: TABLE_HEADINGS, rows: rows, title: "Player #{player.number}"
    end
    p board
  end
end
