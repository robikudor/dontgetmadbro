class Ply
  def initialize(number, finish_node)
    @number = number
    @starting_node = finish_node.next
    @finishing_node = finish_node
    @puppets = 4.times { |i| Puppet.new(number, i) }
  end
end
