require 'adventure_class'


class Location < AdventureClass
  acts_as :container
  
  def initialize name , &block
    super name
    @exits= {}
    instance_exec &block
  end

  def exit direction, options
    @exits[direction]= options
  end

  def look
    "You are "+player.location+
      "\nYou can see "+ player.location.items_string('nothing special')+
      "\nYou can go "+player.location.exits_string
  end

  def exits_string
    return "Nowhere!" if @exits.empty?
    exit_strings= []
    @exits.keys.each do |exit_name|
      exit_strings << "#{exit_name.to_s.capitalize} (#{@exits[exit_name][:desc]})"
    end
    exit_strings.sentence_join 'or'
  end

  def north() move_player :north; end
  def south() move_player :south; end
  def east()  move_player :east;  end
  def west()  move_player :west;  end

  def inv() player.inv; end

  private #=====================================================================================

  def move_player direction
    if @exits[direction]
      player= fetch(:player)
      player.move_to(@exits[direction][:to])
      return player.location.look
    else
      "I can't see any way to go #{direction.capitalize}"
    end
  end
end
