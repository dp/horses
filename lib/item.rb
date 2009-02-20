require 'adventure_class'

class Item < AdventureClass
  acts_as :item

  def initialize name , &block
    super name
    instance_exec &block
  end

end

