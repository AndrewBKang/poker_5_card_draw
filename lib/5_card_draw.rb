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
    
    suits.each do |suit|
      numbers.each do |number|
        @cards << Card.new(suit,number)
      end
    end
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
  end
  
  #compares two hands
  def <=>(hand)
    compare = set_tiers[self.tier] <=> set_tiers[hand.tier]
    return compare unless compare == 0
    compare_imp_hi_card(self.numbers.sort,hand.numbers.sort)
  end
  
  
  protected  
  
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
  
  #recursively look for highest different card
  def compare_imp_hi_card(nums1,nums2)
    compare = imp_hi_card(nums1) <=> imp_hi_card(nums2) 
    return compare if nums1.size == 1 || compare != 0
    compare_imp_hi_card(nums1[0..-2],nums2[0..-2])
  end
  
  #find the high card among cards of greatest occurence
  def imp_hi_card(nums)
    counts = []
    nums.uniq.each {|num| counts << nums.count(num)}
    nums.select{|num| nums.count(num) == counts.max}.max
  end
  
  #pairs(n=2), triples(n=3), quads(n=4)
  def n_of_kind?(n)
    flag = false
    numbers.uniq.each {|num| flag = true if numbers.count(num) == n }
    flag
  end
  
  def flush?
    suits.uniq.size == 1
  end  
  
  def straight?
    straights.include?(numbers.sort)
  end
  
  def straights
    straights = []
    9.times { |n| straights << [n+2,n+3,n+4,n+5,n+6] }
    straights + [2,3,4,5,14]
  end
  
  def numbers
    cards.map {|card| card.number}
  end
  
  def suits
    cards.map {|card| card.suit}
  end
  
  
end