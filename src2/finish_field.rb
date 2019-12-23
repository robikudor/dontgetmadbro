class FinishField < Field
  def initialize(player)
    super()
    @player = player
    @next_finish = nil
  end
end
