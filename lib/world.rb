require 'item'
require 'location'
require 'singleton'
require 'player'

class World
  include Singleton
  attr_reader :the_intro
  attr_accessor :end_of_game

  def self.create_from_file filename
    w= World.instance
    w.instance_eval IO.read filename
    w
  end

  # make World.fetch alias for World.instance.fetch
  def self.fetch object_name
    instance.fetch object_name
  end

  def fetch object_name
    # if trying to fetch an actual object, you already have it :)
    return object_name if object_name.is_a? AdventureClass
    @bucket[object_name]
  end

  def self.add object_name, object_instance
    instance.add object_name, object_instance
  end

  def add object_name, object_instance
    @bucket[object_name]= object_instance
  end

  private #=====================================================================================

  def item item_name, &block
    Item.new item_name, &block
  end

  def location loc_name, &block
    Location.new loc_name, &block
  end

  def player &block
    Player.new &block
  end

  def intro intro_text
    @the_intro= intro_text
  end

  def initialize
    @bucket= {}
  end

end
