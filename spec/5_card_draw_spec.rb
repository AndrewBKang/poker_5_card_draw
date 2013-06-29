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
      @deck.deal(@player,52)
      @player.hand.cards.uniq.size.should == 52
    end
    
    it "deals 5 cards for 1 player by default" do
      @deck.deal(@player)
      @player.hand.cards.uniq.size.should == 5
    end
  end
  
end

describe Hand do
  
  attr_accessor :s14, :s13, :s12, :s11, :s10, :c10, :s9, :d9, :h9, :c9, :s2,
   :c3, :d4, :s5, :hand, :hand2
  
  before do
    @s14 = Card.new(:s,14)
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
    @hand = Hand.new
    @hand2 = Hand.new
  end
  
  describe "#cards" do
    it "returns an array of the cards" do
      hand.cards += [s14,s12,s11,s10,h9]
      hand.cards.should == [s14,s12,s11,s10,h9]
    end
  end
  
  describe "#tier" do
    it "returns high card" do
      hand.cards += [s14,s12,s11,s10,h9]
      hand.tier.should == :high_card
    end
      
    it "returns pair" do
      hand.cards += [s10,c10,s13,s12,s11]
      hand.tier.should == :pair
    end
    
    it "returns two pair" do
      hand.cards += [s10,c10,s9,d9,s14]
      hand.tier.should == :two_pair
    end
    
    it "returns three of a kind" do
      hand.cards += [s9,h9,d9,c10,s11]
      hand.tier.should == :three_of_a_kind
    end
    
    it "returns straight" do
      hand.cards += [s14,s13,s12,s11,c10]
      hand.tier.should == :straight
    end
    
    it "returns straight with ace in front" do
      hand.cards += [s14,s2,c3,d4,s5]
      hand.tier.should == :straight
    end
    
    it "returns flush" do
      hand.cards += [s14,s13,s9,s5,s9]
      hand.tier.should == :flush
    end
    
    it "returns full house" do
      hand.cards += [s10,c10,s9,d9,h9]
      hand.tier.should == :full_house
    end
    
    it "returns four of a kind" do
      hand.cards += [s9,d9,h9,c9,s14]
      hand.tier.should == :four_of_a_kind
    end
    
    it "returns straight flush" do
      hand.cards += [s13,s12,s11,s10,s9]
      hand.tier.should == :straight_flush
    end
    
    it "returns royal flush" do
      hand.cards += [s14,s13,s12,s11,s10]
      hand.tier.should == :royal_flush
    end
    
  end
  
  describe "#<=>" do
    
    it "returns 1 if better different tiers" do
      hand.cards += [s14,s13,s12,s11,c10]
      hand2.cards += [s10,c10,s9,d9,s14]
      (hand <=> hand2).should == 1
    end
    
    it "returns -1 if worse of different tiers" do
      hand.cards += [s10,c10,s9,d9,h9]
      hand2.cards += [s10,c10,s13,s12,s11]
      (hand2 <=> hand).should == -1
    end
    
    it "returns 1 if better in same tier" do
      hand.cards += [s14,s13,s12,s11,c10]
      hand2.cards += [s14,s2,c3,d4,s5]
      (hand <=> hand2).should == 1
    end
    
    it "returns -1 if worse in same tier" do
      hand.cards += [s13,s12,s11,c10,s9]
      hand2.cards += [s14,s13,s12,s11,c10]
      (hand <=> hand2).should == -1
    end
    
    it "returns 0 if there is a draw" do
      hand.cards += [s13,s12,s11,c9,s9]
      hand2.cards += [s13,s12,s11,d9,h9]
      (hand <=> hand2).should == 0
    end
    
  end
 
end

describe Player do
  
  attr_accessor :s14, :s12, :s11, :s10, :h9, :player
  
  before do
    @s14 = Card.new(:s,14)
    @s12 = Card.new(:s,12)
    @s11 = Card.new(:s,11)
    @s10 = Card.new(:s,10)
    @h9 = Card.new(:h,9)
  
    @player = Player.new
    player.hand.cards += [s14,s12,s11,s10,h9]
    
  end
  
  describe "#discard" do
    
    it "discards" do
      player.discard("s14 s12 s11")
      player.hand.cards.should == [s10,h9]
    end
    
  end
  
  describe "#fold" do
    it "empties the hand" do
      player.fold
      player.hand.cards.should == []
    end
  end
  
  describe "#see" do
    it "handles check" do
      player.bet(0).should == 0
    end
    
    it "pot doesn't change when check is made" do
      player.bet(0)
      player.pot.should == 100
    end
    
    it "returns the amount called" do
      player.bet(60).should == 60
    end
    
    it "subtracts from own pot" do
      player.bet(30)
      player.pot.should == 70
    end
    
    it "empties player pot if call is greater than player's pot" do
      player.bet(120)
      player.pot.should == 0
    end
    
    it "returns only as much as player has" do
      player.bet(120).should == 100
    end
    
  end
  
  describe "#raise" do 
    
    it "" do
    end
  
  end
  
end

describe Game do 
  
  #control how many cards can be dealt
  #when players bet, pot grows
  #keeps track of current bet
  #
  
end

