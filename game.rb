class Game
  PLAYER_COUNT = 2
  TABLE_HEADINGS = ['Puppet', 'Status', 'Moves to finish', 'Finishing Position'].freeze

  def initialize
    @board = Board.new
    @players = PLAYER_COUNT.times.map { |i| Player.new(i) }
    @game_ongoing = true
    players.each { |player| board.start_with_puppet(player) }
    starting_rolls = PLAYER_COUNT.times.map { roll_dice }
    p starting_rolls
    @player_round = starting_rolls.index(starting_rolls.max)
    puts "#{@player_round} starts"
  end

  attr_accessor :board, :players

  def play
    while @game_ongoing
      dice, puppet = user_input
      board.move(players[@player_round], dice, puppet)
      check_win
      display_board
      @player_round = (@player_round + 1) % PLAYER_COUNT unless dice == 6
    end
  end

  private

  def roll_dice
    rand 1..6
  end

  def check_win
    if players[@player_round].won?
      @game_ongoing = false
      puts "!!! PLAYER #{@player_round} WON !!!"
    end
  end

  def user_input
    puts "Player #{@player_round}'s turn. Press enter to roll!"
    gets.chomp
    dice = roll_dice
    puts "You rolled #{dice}"
    puts "Which puppet you want to move?"
    available_puppets = players[@player_round].moving_puppets
    available_puppets.each { |p| puts p.id }
    user_input_id = gets.chomp.to_i
    # validate user input
    [dice, available_puppets.select { |p| p.id == user_input_id }.first ]
  end

  def display_board
    players.each do |player|
      rows = player.puppets.map { |p| [p.id, p.status, p.steps_left, p.finished_position] }
      puts Terminal::Table.new headings: TABLE_HEADINGS, rows: rows, title: "Player #{player.number}"
    end
  end
end
