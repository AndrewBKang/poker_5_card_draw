class Card
  
  attr_accessor :suit, :number
  
  def initialize(suit,number)
    @suit = suit
    @number = number
  end
  
end

class Deck
  
  def initialize
    @cards = []
    set_cards
  end
  
  def deal(player, num_of_cards = 5)
    dealt_cards = []
    num_of_cards.times do 
      dealt_cards << @cards.shuffle.pop
    end
    player.hand.cards += dealt_cards
  end
  
  private
  
  def set_cards
    suits = [:s,:h,:c,:d]
    numbers = (1..13).to_a
    
    suits.each do |suit|
      numbers.each do |number|
        @cards << Card.new(suit,number)
      end
    end
  end

  
end