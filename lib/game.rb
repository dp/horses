require 'world'

World.create_from_file 'horse_adventure.rb'
world= World.instance
player= world.fetch :player

puts world.the_intro
puts player.location.look

begin
  print"What would you like to do? > "
  commands= gets
  puts
  words= commands.downcase.gsub('go','').split
#  p words

  noun= (words.size== 1 ? player.location.name : words[-1]).to_sym

  action= words[0]
  #puts "noun:#{noun} action:#{action}"

  if player.can_see?(noun) || player.is_in?(noun) || player.is_holding?(noun)
    target= world.fetch(noun)
    puts target.send("action_#{action}".to_sym) || target.send(action.to_sym)
  else
    puts "I can't see that here"
  end

end until world.end_of_game

puts "\n----\nBye!"
