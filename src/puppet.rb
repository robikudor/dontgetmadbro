class Puppet
  STATUSES = %i[idle moving finished].freeze

  def initialize(id, team)
    @id = id
    @steps_left = 44
    @status = :idle
    @team = team
  end

  def move(new_step)
    @steps_left = new_step
  end

  def reset_puppet
    @steps_left = 44
    @status = :idle
  end

  def start_moving
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

  def finish
    @status = :finished
  end

  def inspect
    "(#{@team}-#{@id})"
  end

  attr_reader :id, :finished_position, :steps_left, :team, :status
end
