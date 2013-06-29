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
    num_of_cards.times { dealt_cards << @cards.shuffle.pop }
    player.hand.cards += dealt_cards
  end
  
  private
  
  def set_cards
    suits = [:s,:h,:c,:d]
    numbers = (2..14).to_a
    @cards = suits.product(numbers).map{|suit,number| Card.new(suit,number)}
  end

end

class Hand
  
  attr_accessor :cards
  
  def initialize(*cards)
    @cards = cards
    @tiers = set_tiers
  end
  
  def tier
    royal_straight? = numbers.sort == [10,11,12,13,14]
    return :royal_flush if flush? && royal_straight?
    return :straight_flush if flush? && straight?
    return :four_of_a_kind if n_of_kind?(4)
    return :full_house if n_of_kind?(2) && n_of_kind?(3)
    return :flush if flush?
    return :straight if straight?()
    return :three_of_a_kind if n_of_kind?(3)
    return :two_of_a_kind if n_of_kind?(2) && numbers.uniq = 3
    :high_card
  end
  
  #Ke's infinitely better compare method
  def <=>(hand)
    result = set_tiers[self.tier] <=> set_tiers[hand.tier]
    
    return result unless result == 0
    ke_sort(self.numbers) <=> ke_sort(hand.numbers)
  end
  
  
  protected 

  def ke_sort(card_nums)
    card_nums.sort_by{ |num| card_nums.count(num) * 15 + num }.reverse
  end
  
  # pairs(n=2), triples(n=3), quads(n=4)
  def n_of_kind?(n)
    flag = false
    numbers.uniq.each {|num| flag = true if numbers.count(num) == n }
    flag
  end
  
  def flush?
    suits.uniq.size == 1
  end  
  
  def straight?
    numbers.sort == (numbers.first..numbers.first+4).to_a
  end
  
  def numbers
    cards.map(&:number)
  end
  
  def suits
    cards.map(&:suit)
  end
  
  def set_tiers
    { :high_card        => 0,
      :pair             => 1,
      :two_pair         => 2,
      :three_of_a_kind  => 3,
      :straight         => 4,
      :flush            => 5,
      :full_house       => 6,
      :four_of_a_kind   => 7,
      :straight_flush   => 8,
      :royal_flush      => 9  }
  end
  
end

class Player
  
  attr_accessor :hand, :pot
  
  def discard(string)
    string.split(" ")
    
  end
  
  def fold
    
  end
  
  def see
    
  end
  
  def raise
    
  end
  
end