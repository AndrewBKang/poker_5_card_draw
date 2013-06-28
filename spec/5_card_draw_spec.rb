require 'rspec'
require '5_card_draw'

describe Card do
  
  before(:each) do
    @card = Card.new(:s,7)
  end
  
  describe "#suit" do
    it "returns the suit" do
      @card.suit.should == :s
    end
  end
  
  describe "#number" do
    it "returns the number" do
      @card.number.should == 7
    end
  end
  
end

describe Deck do
  
  before(:each) do
    @deck = Deck.new
    @player = Player.new
  end
  
  describe "#deal" do
    it "deals 52 different cards for 1 player" do
      deck.deal(player,52)
      player.hand.uniq.size.should == 52
    end
    
    it "deals 5 cards for 1 player by default" do
      deck.deal(player)
      player.hand.uniq.size.should == 5
    end
  end
  
end

describe Hand do
  
  attr_accessor :s1, :s13, :s12, :s11, :s10, :c10, :s9, :d9, :h9, :s2,
   :c3, :d4, :s5
  
  before do
    @s1 = Card.new(:s,1)
    @s13 = Card.new(:s,13)
    @s12 = Card.new(:s,12)
    @s11 = Card.new(:s,11)
    @s10 = Card.new(:s,10)
    @c10 = Card.new(:c,10)
    @s9 = Card.new(:s,9)
    @d9 = Card.new(:d,9)
    @h9 = Card.new(:h,9)
    @c9 = Card.new(:c,9)
    @s2 = Card.new(:s,2)
    @c3 = Card.new(:c,3)
    @d4 = Card.new(:d,4)
    @s5 = Card.new(:s,5)
  end
  
  describe "#cards" do
    it "returns an array of the cards" do
      Hand.new(s1,s12,s11,s10,h9).cards.should == [s1,s12,s11,s10,h9]
    end
  end
  
  describe "#tier" do
    it "returns high card" do
      Hand.new(s1,s12,s11,s10,h9).tier.should == :high_card
    end
      
    it "returns pair" do
      Hand.new(s10,c10,s13,s12,s11).tier.should == :pair
    end
    
    it "returns two pair" do
      Hand.new(s10,c10,s9,d9,s1).tier.should == :two_pair
    end
    
    it "returns three of a kind" do
      Hand.new(s9,h9,d9,c10,s11).tier.should == :three_of_a_kind
    end
    
    it "returns straight" do
      Hand.new(s1,s13,s12,s11,c10).tier.should == :straight
    end
    
    it "returns straight with ace in front" do
      Hand.new(s1,s2,c3,d4,s5).tier.should == :straight
    end
    
    it "returns flush" do
      Hand.new(s1,s13,s9,s5,s9).tier.should == :flush
    end
    
    it "returns full house" do
      Hand.new(s10,c10,s9,d9,h9).tier.should == :full_house
    end
    
    it "returns four of a kind" do
      Hand.new(s9,d9,h9,c9,s1).tier.should == :four_of_a_kind
    end
    
    it "returns straight flush" do
      Hand.new(s13,s12,s11,s10,s9).tier.should == :straight_flush
    end
    
    it "returns royal flush" do
      Hand.new(s1,s13,s12,s11,s10).tier.should == :royal_flush
    end
    
  end
  
  describe "#is_a_better_hand?" do
    
    it "returns true if better different tiers" do
      straight = Hand.new(s1,s13,s12,s11,c10)
      two_pair = Hand.new(s10,c10,s9,d9,s1)
      straight.is_a_better_hand?(two_pair).should == true
    end
    
    it "returns false if worse of different tiers" do
      full_house = Hand.new(s10,c10,s9,d9,h9)
      pair = Hand.new(s10,c10,s13,s12,s11)
      pair.is_a_better_hand?(full_house).should == false
    end
    
    it "returns true if better in same tier" do
      straight = Hand.new(s1,s13,s12,s11,c10)
      lower_straight = Hand.new(s1,s2,c3,d4,s5)
      straight.is_a_better_hand(lower_straight).should == true
    end
    
    it "returns false if worse in same tier" do
      straight = Hand.new(s13,s12,s11,c10,s9)
      higher_straight = Hand.new(s1,s13,s12,s11,c10)
      straight.is_a_better_hand(higher_straight).should == false
    end
  end
 
end

describe Player do
  
  before do
    @s1 = Card.new(:s,1)
    @s12 = Card.new(:s,12)
    @s11 = Card.new(:s,11)
    @s10 = Card.new(:s,10)
    @h9 = Card.new(:h,9)
  
    @player = Player.new
    @player.hand = Hand.new(s1,s12,s11,s10,h9)
    @player.pot = 100
    
  end
  
  describe "#discard" do
    
    player.discard("s1 s12 s11")
    player.hand.cards.should == [s10,h9]
    
  end
  
  describe "#fold" do
    it "empties the hand" do
      player.fold
      player.hand.cards.should == []
    end
  end
  
  describe "#see" do
    it "handles check" do
      player.see(0).should == 0
    end
    
    it "pot doesn't change when check is made" do
      player.see(0)
      player.pot.should == 100
    end
    
    it "returns the amount called" do
      player.see(60).should == 60
    end
    
    it "returns the amount called" do
      player.see(30)
      player.pot.should == 70
    end
    
    it "empties player pot if call is greater than player's pot" do
      player.see(120)
      player.pot.should == 0
    end
    
    it "returns only as much as player has" do
      player.see(120) == 100
    end
    
  end
  
  describe "#raise" do 
    it ""
    
  
end

describe Game do 
  
  #control how many cards can be dealt
  #when players bet, pot grows
  #keeps track of current bet
  #
  
end

