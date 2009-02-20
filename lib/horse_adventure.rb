intro <<-TEXT
** Francesca and Alycia's Adventure Horse Game **

In this adventure you are a girl who has just woken up in a strange place. You don't know
where you are or how you got here.

You have to go exploring and see what you can find.
------------------------------------------------------------------------------------------

... You feel a bit dizzy as you look around.
TEXT

item :saddle do
  desc "an old leather saddle"
  on_look "It's a bit old, but it looks ok to use."
  on_get do
    if player.is_in?(:stable) && fetch(:stable).contains?(:cobwebs)
      "I can't get the saddle. There's too many cobwebs."
    end
  end
end

item :cobwebs do
  desc "lots and lots of dusty cobwebs"
  on_look "I think I see some spiders in there. There's no way I'm putting my hands near them."
  on_get "Yuck! no way!"
  on_sweep do
    if player.is_holding? :broom
      hide :cobwebs

      "You sweep away all to cobwebs. That looks a bit better now."
    else
      "You don't have anything to sweep them with"
    end
  end
end

item :broom do
  desc "a broom"
end

location :stable do
  desc "in an old dusty stable. I don't think anyone's been in here for a very long time."
  items :saddle, :cobwebs
  exit :south, :to=> :paddock, :desc=> 'back out into the sun'
end

location :paddock do
  desc "in a grassy paddock. It's quite nice out here in the sun."
  items :broom
  exit :north, :to=> :stable, :desc=> 'into the stable'
end

player do
  starts_in :paddock
end
