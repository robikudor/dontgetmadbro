class Puppet
  STATUSES = %i[idle moving finished].freeze

  def initialize(id, team)
    @id = id
    @steps_left = 44
    @status = :idle
    @finished_position = nil
    @team = team
  end

  def move(steps)
    if @steps_left >= steps
      @steps_left -= steps
      puppet_finished?
    end
    finished?
  end

  def reset_puppet
    @steps_left = 44
    @status = :idle
  end

  def start_move
    @status = :moving
  end

  def idle?
    @status == :idle
  end

  def moving?
    @status == :moving
  end

  def finished?
    @status == :finished
  end

  def puppet_finished?
    if (1..4) === @steps_left
      @status = :finished
      @finished_position = @steps_left
    end
  end

  def inspect
    "[#{@team},#{@id}]"
  end

  attr_reader :id, :finished_position, :steps_left, :team, :status
end
