require 'adventure_class'

class Player < AdventureClass
  acts_as :item
  acts_as :container


  def initialize &block
    super :player
    # not carying anything at start
    instance_exec &block
  end

  # player.is_holding? :broom looks better than player.contains? :broom :)
  def is_holding? wanted_item
    contains? wanted_item
  end

  def can_see? wanted_item
    location.contains? wanted_item
  end

#  def get wanted_item
#    return "You're already carrying it" if self.is_holding? wanted_item
#    return "I can't see that here" unless self.can_see? wanted_item
#    item= fetch wanted_item
#    hold item
#    "You've picked up #{item.name}"
#  end


  def inv
    return "You are carrying "+items_string
  end
  
  private #=====================================================================================

  # another alias
  def starts_in location_name
    move_to location_name
  end
end
