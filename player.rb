
class Player
  def initialize(name, purse)
    @name = name
    @purse = purse
    @player_bet = 0
  end

  def name()
    @name
  end
  
  def bet()
    @player_bet
  end
  
  def has_folded?
    @folded
  end
  
  def fold_em()
    puts "\n", " \s #{@name} folded and is out of the game", "\n"
    @folded = true
    @keepers  = [7,7,7,7,7]
    @tally = 35
    @remaining = 0
  end
  
  def purse()
    @purse
  end
  
  def push_player_bet(bet)
    @player_bet += bet
  end
  
  def reset_player_bet()
    @player_bet = 0
  end
  
  def pull_from_purse(bet)
    @purse -= bet
  end
  
  def put_into_purse(winnings)
    @purse += winnings
  end
  
  def init_temp_vars()
    @keepers = []
    @tally = 0
    @folded = false
  end

  def keepers()
    @keepers
  end
  
  def push_keepers(value)
    @keepers.push(value)
  end
  
  def remaining()
    @remaining = 5 - @keepers.length
  end
  
  def tally()
    @tally
  end
  
  def push_tally(value)
    @tally += value
  end

  def can_raise?()
    @can_raise
  end

  def reset_can_raise()
    @can_raise = true
  end
  
  def cannot_raise_again()
    @can_raise = false
  end
  
  def ante_up?(ante)
    if @purse < ante
      puts "Too bad you're too poor to play this round your purse is #{@purse} and the ante is #{ante}"
      return false
    end
    
    puts "\n", "#{@name} the ante is #{ante} this round, are you in? [Y/n]"
    input = gets.chomp
    if input == 'n'
      return false
    else
      return anteing(ante)
    end
  end
  
  def anteing(ante)
    puts "\t #{@name} is in the round \t"
    @purse -= ante
    return true
  end
  
  def name_input()
    @name = gets.chomp.capitalize
    if @name.length == 0 
      puts "I didn't catch that can you repeat it"
      name_input()
    end
  end
  
  def ask_for_name()
    print "Player name > "
    name_input()
  end
end

