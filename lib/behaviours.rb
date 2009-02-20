module ContainerBehaviours
  def contains?  wanted_item, item_becomes_it= true
    it= wanted_item if item_becomes_it
    held_items.select{|item| item.is? wanted_item}.any?
  end

  def items *item_list
    item_list.each{|item| hold item}
  end

  def hold item_name
    unless self.contains? item_name, false
      item= fetch item_name
      held_items << item
      item.move_to self
    end
  end

  # should always be called from the item. Doesn't change the location of the item, just
  # removes it from the list of items in this container
  def release item_name
    if self.contains? item_name, false
      item= fetch item_name
      @items -= [item]
      #item.move_to :non_game_area
    end
  end

  def held_items
    @items ||= []
  end

  def held_items_ex_player
    held_items.delete_if{|item|item.is? :player}
  end

  def empty?
    # a location also holds the player. need to exclude the player here
    held_items_ex_player.empty?
  end

  def items_string empty_string= 'nothing'
    #return "nothing special" if self.empty?
    held_items_ex_player.sentence_join 'and', empty_string
    #    return hiep[0] if hiep.size== 1
    #    "#{hiep[0..-2].join(', ')} and #{hiep[-1]}"
  end

end


module ItemBehaviours #=========================================================================
  attr_reader :location

  def is_in? wanted_location
    it= wanted_location
    location.is? wanted_location
  end

  def location= location_name
    @location= fetch location_name
  end

  def move_to new_location
    unless location && location.is?(new_location)
      # tell the old location (if there is one) to let go
      self.location.release self if self.location
      # point location to the new location
      self.location= new_location
      # tell new location (if there is one) to hold on
      self.location.hold self if self.location
    end
  end

  def get
    return "You're already holding it!" if self.location.is? :player

    move_to :player
    "You pick up the #{name}"
  end

  def drop
    return "You're not holding it" unless self.location.is? :player

    move_to player.location
    "You put down #{name}"
  end


  def hide item_name
    fetch(item_name).move_to nil
  end
end
