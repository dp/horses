require 'behaviours'

class Array
  def sentence_join join_word= 'and', empty_word=''
    return empty_word if self.empty?
    return self[0] if self.size== 1
    "#{self[0..-2].map{|i|i.to_str}.join(', ')} #{join_word} #{self[-1].to_str}"
  end
end


class AdventureClass
  attr_accessor :description, :name

  def metaclass
    class << self; self; end
  end

  def initialize name
    @description= @name= name.to_sym
    @@it= nil
    World.add name, self
  end

  def player
    @player||= World.fetch :player
  end

  def is? something
    return case something
    when NilClass then false
    when Symbol then name== something
    when AdventureClass then name== something.name
    else raise "Can't compare with #{something.class}"
    end
  end

  def it
    @@it
  end

  def it= value
    @@it= value
  end

  def quit
    World.instance.end_of_game= true
    "You have quit the game. Bye!"
  end

  def to_str
    description
  end

  def method_missing action, params=nil, &block
    if action.to_s[0..2]=='on_'
      # create a custom method named action_[action] for this instance
      action_name= "action_#{action.to_s[3..-1]}".to_sym
      method_body= params ? lambda{params} : lambda{instance_exec &block}
      self.metaclass.send :define_method, action_name, method_body
    elsif action.to_s[0..6]=='action_'
      return nil
    else
      "I don't know how to #{action} a #{name}"
    end
  end

  def look
    description
  end

  private #=====================================================================================

  def fetch object_name
    World.instance.fetch object_name
  end

  def self.acts_as behaviour
    include case behaviour
    when :container then ContainerBehaviours
    when :item then ItemBehaviours
    else raise "Don't know how to act as #{behaviour}"
    end
  end

  def it= object_name
    @@it= fetch object_name
  end
  
  def desc desc
    @description= desc
  end


end

