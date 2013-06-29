class Card
  
  attr_accessor :suit, :number
  
  def initialize(suit,number)
    @suit = suit
    @number = number
  end
  
end

class Deck
  
  def initialize
    set_cards
  end
  
  def deal(player, num_of_cards = 5)
    num_of_cards.times { player.hand.cards << @cards.pop }
  end
  
  private
  
  def set_cards
    suits,numbers = [:s,:h,:c,:d],(2..14).to_a
    @cards = suits.product(numbers).map{|s,n| Card.new(s,n)}.shuffle
  end

end

class Hand
  
  attr_accessor :cards
  
  def initialize
    @cards = []
  end
  
  def tier
    royal_straight = numbers.sort == [10,11,12,13,14]
    return :royal_flush if flush? && royal_straight
    return :straight_flush if flush? && straight?
    return :four_of_a_kind if n_of_kind?(4)
    return :full_house if n_of_kind?(2) && n_of_kind?(3)
    return :flush if flush?
    return :straight if straight?
    return :three_of_a_kind if n_of_kind?(3)
    return :two_pair if n_of_kind?(2) && numbers.uniq.size == 3
    return :pair if n_of_kind?(2)
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
  
  def n_of_kind?(n)
    flag = false
    numbers.uniq.each {|num| flag = true if numbers.count(num) == n }
    flag
  end
  
  def flush?
    suits.uniq.size == 1
  end  
  
  def straight?
    numbers.sort == (numbers.min..numbers.min + 4).to_a || 
    numbers.sort == [2,3,4,5,14]
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
  
  def initialize
    @hand = Hand.new
    @pot = 100
  end
  
  def turn_check
    print "Check Bet Fold\n"
    choice = gets.chomp
    case choice.downcase
    when /^[c]/
      return bet(0)
    when /^[b]/
      print "how much?\n"
      return bet(gets.to_i)
    when /^[f]/
      return fold
    else 
      raise ArgumentError.new "type c b or f"
    end
  end
  
  def turn_call(amt)
    print "Call Raise Fold"
    choice = gets.chomp
    case choice.downcase
    when /^[c]/
      return bet(amt)
    when /^[r]/
      return raiser(amt)
    when /^[f]/
    else
    end
      
  end
  
  def raiser(amt)
    print "Two-bet Three-bet Four-bet All-in Other"
    choice = gets.chomp
    case choice.downcase
    when /^[t][w]/
      bet(2 * amt)
    when /^[t][h]/
      bet(3 * amt)
    when /^[f]/
      bet(4 * amt)
    when /^[a]/
    when /^[o]/
    else
    end
  end
  
  def fold
    hand.cards = []
    "folded"
  end
  
  def bet(amt)
    self.pot > amt ? self.pot -= amt : (amt,self.pot = self.pot,0)
    amt
  end
  
  def discard(str)
    discards = discards(str)
    discards.product(hand.cards).each do |discard,card|
      hand.cards.delete(card) if matching?(card,discard)
    end
  end
  
  private
  
  # "s11, d10c9" => [[:s,11],[:d,10],[:c,9]]
  def discards(str)
    str.scan(/[shcd]/).zip(str.scan(/[2-9]|[1][0-4]/).map(&:to_i))
  end
  
  def matching?(card,discard)
    card.suit.to_s == discard[0] && card.number == discard[1]
  end
  
end

class Game
  
end