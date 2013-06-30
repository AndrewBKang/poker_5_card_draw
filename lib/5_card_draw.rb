require 'colored'
class Card
  
  attr_accessor :suit, :number, :symbol
  
  def initialize(suit,number)
    @suit = suit
    @number = number
    set_symbol
  end
  
  def set_symbol
    suit_symbol = " \u2660 ".black_on_white if @suit == :s 
    suit_symbol = " \u2665 ".red_on_white if @suit == :h
    suit_symbol = " \u2663 ".black_on_white if @suit == :c
    suit_symbol = " \u2666 ".red_on_white if @suit == :d
    num = "#{number}".black_on_white unless number > 10
    num = "J".black_on_white if number == 11
    num = "Q".black_on_white if number == 12
    num = "K".black_on_white if number == 13
    num = "A".black_on_white if number == 14
    @symbol = suit_symbol + num
  end
  
  def black?
    suit == :s || suit == :c
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
    return :empty if cards == []
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
    { :empty            => 0,
      :high_card        => 0,
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
  
  def turn_discard
    print "suit and number of cards you want to discard:\n"
    num = gets
    discard(num)
  end
  
  def turn_check
    print "Check Bet Fold\n"
    choice = gets.chomp
    case choice.downcase
    when /^[c]/
      result = bet(0)
    when /^[b]/
      print "how much?\n"
      result = bet(gets.to_i)
    when /^[f]/
      result = fold
    else 
      raise ArgumentError.new "type c b or f"
    end
    result 
  end
  
  def turn_call(amt)
    print "Call Raise Fold\n"
    choice = gets.chomp
    case choice.downcase
    when /^[c]/
      result = bet(amt)
    when /^[r]/
      result = raiser(amt)
    when /^[f]/
      result = fold
    else
      raise ArgumentError.new "type c r or f"
    end
    result
  end
  
  private
  
  def raiser(amt)
    print "Two-bet Three-bet Four-bet All-in Other\n"
    choice = gets.chomp
    case choice.downcase
    when /^[t][w]/
      result = bet(amt)
    when /^[t][h]/
      result = bet(2 * amt)
    when /^[f]/
      result = bet(3 * amt)
    when /^[a]/
      result = bet(self.pot)
    when /^[o]/
      print "type amount:\n"
      bets = gets.to_i
      raise ArgumentError.new "type a larger amount" if bets < amt
      result = bet(bets)
    else
      raise ArgumentError.new "type: two three four all or other"
    end
    result
  end
  
  def fold
    hand.cards = []
    print "player has folded\n"
    0
  end
  
  def bet(amt)
    raise ArgumentError.new "type a number!" unless amt.is_a? Integer
    self.pot > amt ? self.pot -= amt : (amt,self.pot = self.pot,0)
    self.pot == 0 ? print("player is all-in\n") : print("player has bet: #{amt}\n") 
    amt
  end
  
  def discard(str)
    discards = discards(str)
    discards.product(hand.cards).each do |discard,card|
      hand.cards.delete(card) if matching?(card,discard)
    end
    discards.size
  end
  
  # "s11, d10c9" => [[:s,11],[:d,10],[:c,9]]
  def discards(str)
    str.scan(/[shcd]/).zip(str.scan(/[2-9]|[1][0-4]/).map(&:to_i))
  end
  
  def matching?(card,discard)
    card.suit.to_s == discard[0] && card.number == discard[1]
  end
  
end

class Game
  
  def initialize
    @plyrs = []
    set_game
    play
  end
  
  private
  
  def set_game
    print "----Poker 5 Card Draw ----\n"
    set_players
  end
  
  def play
    until game_over?
      round
    end
    "we have a winner!"
  end
  
  def game_over?
    @plyrs.select{|player| player.pot > 0}.size == 1
  end
  
  def round
    empty_hands
    deal_cards
    pots = 0
    3.times do 
      print "current pot: #{pots}\n"
      pot = turn 
      unless pot == nil
        pots += pot
      end
    end
    pots += bet_turn unless @plyrs.select{|player| player.hand.cards != []}.size == 1
    winners(pots)
  end
  
  def show_pots
    @plyrs.each_with_index {|player,index| print "P#{index+1}:#{player.pot} "}
    print "\n"
  end
  
  def empty_hands
    @plyrs.each {|player| player.hand.cards = []}
  end
  
  def deal_cards
    @deck = Deck.new
    @plyrs.each { |player| @deck.deal(player) }
  end
  
  def turn
    unless @plyrs.select{|player| player.hand.cards != []}.size == 1
      pots = 0
      begin
        pots += bet_turn
      rescue ArgumentError => e
        puts e
        retry
      end
      discard_turn
      pots
    end
  end
  
  def bet_turn
    show_pots
    pots = 0
    plyrs = @plyrs.dup
    went = []
    amts = [0]
    
    until plyrs.size == 0
      player = plyrs.shift
      next if player.hand.cards == []
      prev_pot = pots
      display_cards(player)
      print "Player #{@plyrs.index(player) + 1}'s bet turn\n"
      pots += pots == 0 ? player.turn_check : player.turn_call(amts.max)
      unless amts.include?(pots - prev_pot)
        plyrs += went
        went = []
      end
      amts << (pots - prev_pot)
      went << player
    end
    pots
  end
  
  def discard_turn
    @plyrs.each_with_index do |player,index|
      next if player.hand.cards == []
      display_cards(player)
      print "Player #{index+1}:\n"
      @deck.deal(player,player.turn_discard)
      display_cards(player)
      print "\n"
    end
  end
  
  def winners(amt)
    winners = []
    @plyrs.product(@plyrs).each do |player1,player2|
      case player1.hand <=> player2.hand
      when 1
        winners << player1
      when -1
        winners << player2
      else 
        winners += [player1,player2]
      end
    end
    distribute_pot(winners,amt)
  end
  
  def distribute_pot(winners,amt)
    winners = winners.sort_by{|player| winners.count(player)}
    counter = winners.count(winners.last)
    winners = winners.uniq.select{|player| winners.count(player) == counter}
    amt = amt.to_f / winners.size
    winners.each {|player| player.pot += amt}
  end
  
  def display_cards(player)
    player.hand.cards.each{|card| print card.symbol }
    print "\n"
  end
  
  def set_players
    @num_plyrs = ask_players
    @num_plyrs.times {@plyrs << Player.new}
  end
  
  def ask_players
    begin
      print "how many players?: "
      num_play = gets.to_i
      raise ArgumentError.new "type a number" unless num_play.to_i.is_a? Integer
    rescue ArgumentError => e
      puts e
      retry
    end
    num_play
  end
  
  
end