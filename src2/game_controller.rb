class GameController
  PLAYER_COUNT = 4

  def initialize
    @players = []
    init_board
    init_players
  end

  def init_players
    node = @head
    count = 0
    loop do
      if node.is_a?(FinishField)
        @players << Ply.new(count, node)
        count += 1
      end
      node = node.next
      break if node == @head
    end
  end

  def init_board
    head = FinishField.new(0)
    @head = head
    (1..39).each do |i|
      head.next = i % 10 == 0 ? FinishField.new(i/10) : Field.new
      head = head.next
    end
    head.next = @head
  end

  def print
    puts @players
    node = @head.next
    while(node != @head)
      puts node
      node = node.next
    end
  end
end
